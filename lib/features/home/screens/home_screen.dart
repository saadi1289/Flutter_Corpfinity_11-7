import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';
import '../../../core/widgets/hero_card.dart';
import '../../../core/widgets/supportive_section_card.dart';
import '../../../core/widgets/create_challenge_card.dart';
import '../providers/home_provider.dart';

/// HomeScreen displays the main dashboard with energy level selection
/// and quick stats for the user
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize with mock data for now
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HomeProvider>();
      provider.fetchQuickStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            final state = provider.state;
            
            return CustomScrollView(
              slivers: [
                // Hero Card at top
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
                    child: Column(
                      children: [
                        const SizedBox(height: AppDimensions.spacing16),
                        RepaintBoundary(
                          child: HeroCard(
                            userName: state.userName,
                            profileImageUrl: state.profileImageUrl,
                            progressValue: state.levelProgress,
                            currentLevel: state.currentLevel,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Daily Progress Summary Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenPaddingHorizontal,
                      vertical: AppDimensions.spacing8,
                    ),
                    child: RepaintBoundary(
                      child: SupportiveSectionCard(
                        title: 'Daily Progress Summary',
                        content: '${state.totalActivities} activities completed today',
                        icon: Icons.check_circle_outline,
                        accentColor: AppColors.calmBlue,
                      ),
                    ),
                  ),
                ),
                
                // Tip of the Day Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenPaddingHorizontal,
                      vertical: AppDimensions.spacing8,
                    ),
                    child: RepaintBoundary(
                      child: SupportiveSectionCard(
                        title: 'Tip of the Day',
                        content: _getTipOfTheDay(),
                        icon: Icons.lightbulb_outline,
                        accentColor: AppColors.warmOrange,
                      ),
                    ),
                  ),
                ),
                
                // Current Streak Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenPaddingHorizontal,
                      vertical: AppDimensions.spacing8,
                    ),
                    child: RepaintBoundary(
                      child: SupportiveSectionCard(
                        title: 'Current Streak',
                        content: '${state.currentStreak} days in a row! Keep it up!',
                        icon: Icons.local_fire_department,
                        accentColor: AppColors.energyHigh,
                      ),
                    ),
                  ),
                ),
                
                // Create Challenge Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
                    child: CreateChallengeCard(
                      onTap: () => context.push('/challenge/elegant-create'),
                    ),
                  ),
                ),
                
                // Bottom spacing for navigation bar
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppDimensions.spacing16),
                ),
              ],
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing16,
            vertical: AppDimensions.spacing8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                key: const ValueKey('nav_home'),
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: true,
                onTap: () {},
              ),
              _NavBarItem(
                key: const ValueKey('nav_library'),
                icon: Icons.library_books_rounded,
                label: 'Library',
                isActive: false,
                onTap: () => context.push('/library'),
              ),
              _NavBarItem(
                key: const ValueKey('nav_progress'),
                icon: Icons.trending_up_rounded,
                label: 'Progress',
                isActive: false,
                onTap: () => context.push('/progress'),
              ),
              _NavBarItem(
                key: const ValueKey('nav_profile'),
                icon: Icons.person_rounded,
                label: 'Profile',
                isActive: false,
                onTap: () => context.push('/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Navigation bar item widget
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.calmBlue : AppColors.mediumGray;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing12,
          vertical: AppDimensions.spacing8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: AppDimensions.iconSizeMedium,
            ),
            const SizedBox(height: AppDimensions.spacing4),
            Text(
              label,
              style: AppTypography.captionBold.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
