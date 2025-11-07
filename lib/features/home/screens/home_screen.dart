import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/widgets/supportive_section_card.dart';
import '../../../core/widgets/create_challenge_card.dart';
import '../../../core/widgets/animated_bottom_navigation.dart';
import '../providers/home_provider.dart';
import '../widgets/animated_hero_section.dart';
import '../widgets/featured_carousel.dart';
import '../widgets/animated_content_card.dart';
import '../../../core/utils/responsive_layout_manager.dart';

/// HomeScreen displays the main dashboard with energy level selection
/// and quick stats for the user
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  
  // Requirement 17.2: Throttle scroll updates to 16ms (60fps)
  Timer? _scrollThrottle;
  static const _scrollThrottleDuration = Duration(milliseconds: 16);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // Initialize with mock data for now
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HomeProvider>();
      provider.fetchQuickStats();
      provider.loadFeaturedItems();
      provider.initializePerformanceMonitoring();
      
      // Requirement 16.3: Detect reduced motion preference
      _checkReducedMotionPreference();
    });
    
    // Requirement 17.2: Add throttled scroll listener for parallax calculations
    // Throttle to 16ms max (60fps) to avoid excessive updates
    _scrollController.addListener(_handleScroll);
  }
  
  /// Throttled scroll handler to optimize performance
  /// Requirement 17.2: Throttle scroll updates to 16ms (60fps)
  /// Requirement 2.3: Maintain smooth parallax transitions without jank
  /// Requirement 12.4: Avoid layout recalculations during scroll
  void _handleScroll() {
    // If throttle timer is active, skip this update
    if (_scrollThrottle?.isActive ?? false) return;
    
    // Set up throttle timer to limit updates to 60fps
    _scrollThrottle = Timer(_scrollThrottleDuration, () {
      // Only update if still mounted
      if (mounted) {
        final provider = context.read<HomeProvider>();
        provider.handleScrollPosition(_scrollController.offset);
      }
    });
  }
  
  /// Check if reduced motion is enabled and update animation config
  /// Requirement 16.3: Switch to AnimationConfig.reduced() when reduced motion is enabled
  void _checkReducedMotionPreference() {
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    if (reducedMotion) {
      final provider = context.read<HomeProvider>();
      provider.enableReducedAnimations();
    }
  }

  @override
  void dispose() {
    // Requirement 17.2: Clean up throttle timer
    _scrollThrottle?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh(BuildContext context) async {
    final provider = context.read<HomeProvider>();
    
    // Fetch updated data
    final success = await provider.fetchQuickStats();
    
    if (!success && context.mounted) {
      // Show error message if refresh failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to refresh data. Please try again.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            final state = provider.state;
            
            return RefreshIndicator(
              onRefresh: () => _handleRefresh(context),
              // Requirement 5.3: Custom animated refresh indicator
              color: AppColors.calmBlue,
              backgroundColor: AppColors.white,
              strokeWidth: 3.0,
              displacement: 40.0,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                // Animated Hero Section at top with parallax
                SliverToBoxAdapter(
                  child: RepaintBoundary(
                    child: AnimatedHeroSection(
                      userName: state.userName,
                      profileImageUrl: state.profileImageUrl,
                      progressValue: state.levelProgress,
                      currentLevel: state.currentLevel,
                      scrollController: _scrollController,
                      enableParallax: !state.shouldReduceAnimations,
                      fadeInDuration: state.animationConfig.fadeInDuration,
                    ),
                  ),
                ),
                
                // Featured Carousel Section
                if (state.featuredItems.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.spacing16,
                      ),
                      child: RepaintBoundary(
                        child: FeaturedCarousel(
                          items: state.featuredItems,
                          autoAdvanceDuration: const Duration(seconds: 5),
                          transitionDuration: state.animationConfig.carouselTransitionDuration,
                          onItemChanged: (index) {
                            provider.updateCarouselIndex(index);
                          },
                        ),
                      ),
                    ),
                  ),
                
                // Content Cards Grid with responsive layout
                SliverPadding(
                  padding: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
                  sliver: Builder(
                    builder: (context) {
                      final layoutManager = ResponsiveLayoutManager(context);
                      final gridColumns = layoutManager.gridColumns;
                      
                      // Build list of content cards
                      final contentCards = [
                        RepaintBoundary(
                          child: AnimatedContentCard(
                            animationDelay: 0,
                            enableHoverEffect: true,
                            visibilityKey: const Key('daily_progress_card'),
                            child: SupportiveSectionCard(
                              title: 'Daily Progress Summary',
                              content: '${state.totalActivities} activities completed today',
                              icon: Icons.check_circle_outline,
                              accentColor: AppColors.calmBlue,
                            ),
                          ),
                        ),
                        RepaintBoundary(
                          child: AnimatedContentCard(
                            animationDelay: 100,
                            enableHoverEffect: true,
                            visibilityKey: const Key('tip_of_day_card'),
                            child: SupportiveSectionCard(
                              title: 'Tip of the Day',
                              content: _getTipOfTheDay(),
                              icon: Icons.lightbulb_outline,
                              accentColor: AppColors.warmOrange,
                            ),
                          ),
                        ),
                        RepaintBoundary(
                          child: AnimatedContentCard(
                            animationDelay: 200,
                            enableHoverEffect: true,
                            visibilityKey: const Key('current_streak_card'),
                            child: SupportiveSectionCard(
                              title: 'Current Streak',
                              content: '${state.currentStreak} days in a row! Keep it up!',
                              icon: Icons.local_fire_department,
                              accentColor: AppColors.energyHigh,
                            ),
                          ),
                        ),
                        RepaintBoundary(
                          child: AnimatedContentCard(
                            animationDelay: 300,
                            enableHoverEffect: true,
                            visibilityKey: const Key('create_challenge_card'),
                            onTap: () => context.push('/challenge/create'),
                            child: CreateChallengeCard(
                              // Navigate to the unified ChallengeFlowScreen
                              onTap: () => context.push('/challenge/create'),
                            ),
                          ),
                        ),
                      ];
                      
                      return SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridColumns,
                          crossAxisSpacing: layoutManager.gridCrossAxisSpacing,
                          mainAxisSpacing: layoutManager.gridMainAxisSpacing,
                          childAspectRatio: gridColumns == 1 ? 3.0 : 2.5,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => contentCards[index],
                          childCount: contentCards.length,
                        ),
                      );
                    },
                  ),
                ),
                
                  // Bottom spacing for navigation bar
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppDimensions.spacing16),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      
      // Bottom Navigation Bar (placeholder for future implementation)
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  String _getTipOfTheDay() {
    // Rotate through tips based on day of year
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final tips = [
      'Take a 5-minute walk break every hour to boost energy',
      'Stay hydrated - aim for 8 glasses of water today',
      'Practice deep breathing for 2 minutes to reduce stress',
      'Stretch your body for 5 minutes to improve flexibility',
      'Take a moment to appreciate something positive today',
      'Get some sunlight exposure to boost your mood',
      'Try a new healthy snack today',
      'Connect with a colleague or friend for social wellness',
      'Take short breaks to rest your eyes from screens',
      'Practice gratitude by writing down three things you\'re thankful for',
    ];
    
    return tips[dayOfYear % tips.length];
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    // Define navigation items
    final navigationItems = [
      const NavigationItem(
        icon: Icons.home_rounded,
        label: 'Home',
        route: '/home',
      ),
      const NavigationItem(
        icon: Icons.library_books_rounded,
        label: 'Library',
        route: '/library',
      ),
      const NavigationItem(
        icon: Icons.trending_up_rounded,
        label: 'Progress',
        route: '/progress',
      ),
      const NavigationItem(
        icon: Icons.person_rounded,
        label: 'Profile',
        route: '/profile',
      ),
    ];

    // Determine current index based on current route
    final currentRoute = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    for (int i = 0; i < navigationItems.length; i++) {
      if (currentRoute == navigationItems[i].route) {
        currentIndex = i;
        break;
      }
    }

    return AnimatedBottomNavigation(
      currentIndex: currentIndex,
      items: navigationItems,
      onTap: (index) {
        // Navigate to the selected route using GoRouter
        // Requirement 13.3: Immediate tap feedback (<100ms)
        // Requirement 15.1: Navigation callbacks with GoRouter integration
        final route = navigationItems[index].route;
        if (currentRoute != route) {
          context.go(route);
        }
      },
    );
  }
}
