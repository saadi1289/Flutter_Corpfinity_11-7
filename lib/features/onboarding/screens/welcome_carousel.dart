import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:corpfinity_employee_app/core/constants/colors.dart';
import 'package:corpfinity_employee_app/core/constants/dimensions.dart';
import 'package:corpfinity_employee_app/core/widgets/custom_button.dart';
import 'package:corpfinity_employee_app/features/onboarding/widgets/carousel_slide.dart';
import 'package:corpfinity_employee_app/features/onboarding/widgets/navigation_dots.dart';

/// WelcomeCarousel displays a swipeable carousel with 3 educational slides
/// introducing the app's value proposition.
/// 
/// Features:
/// - PageView with 3 swipeable slides
/// - Navigation dots indicator with active/inactive states
/// - "Get Started" button that navigates to signup
/// - Slide transition animation (300ms)
class WelcomeCarousel extends StatefulWidget {
  const WelcomeCarousel({super.key});

  @override
  State<WelcomeCarousel> createState() => _WelcomeCarouselState();
}

class _WelcomeCarouselState extends State<WelcomeCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Carousel slide data
  final List<Map<String, dynamic>> _slides = [
    {
      'title': 'Quick Wellness Activities',
      'description':
          'Take a break with 1-5 minute wellness activities designed for busy professionals.',
      'icon': Icons.timer,
      'color': AppColors.calmBlue,
    },
    {
      'title': 'Personalized Recommendations',
      'description':
          'Get activity suggestions based on your energy level and wellness goals.',
      'icon': Icons.favorite,
      'color': AppColors.softGreen,
    },
    {
      'title': 'Track Your Progress',
      'description':
          'Build streaks, earn badges, and celebrate your wellness journey.',
      'icon': Icons.emoji_events,
      'color': AppColors.warmOrange,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onGetStarted() {
    context.go('/auth/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background using app colors
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: const [
                    AppColors.calmBlue,
                    AppColors.softGreen,
                  ],
                  stops: [
                    0.1 + (_currentPage * 0.05),
                    0.9 - (_currentPage * 0.05),
                  ],
                ),
              ),
            ),
          ),
          // Ambient decorative shapes (subtle, animated by page index)
          Positioned(
            top: 60 + (_currentPage * 10),
            left: -40 + (_currentPage * 8),
            child: _AmbientBlob(color: AppColors.white.withOpacity(0.12), size: 160),
          ),
          Positioned(
            bottom: 80 + (_currentPage * 6),
            right: -30 + (_currentPage * 10),
            child: _AmbientBlob(color: AppColors.white.withOpacity(0.10), size: 200),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacing16),
                    child: TextButton(
                      onPressed: _onGetStarted,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                // PageView with slides
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _slides.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final slide = _slides[index];
                      return CarouselSlide(
                        title: slide['title'],
                        description: slide['description'],
                        icon: slide['icon'],
                        iconColor: slide['color'],
                        isActive: index == _currentPage,
                      );
                    },
                  ),
                ),
                // Navigation dots
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.spacing24,
                  ),
                  child: NavigationDots(
                    currentIndex: _currentPage,
                    totalDots: _slides.length,
                    activeColor: AppColors.white,
                    inactiveColor: AppColors.white.withOpacity(0.35),
                  ),
                ),
                // Get Started button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing32,
                    vertical: AppDimensions.spacing24,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Get Started',
                      onPressed: _onGetStarted,
                      size: ButtonSize.large,
                      variant: ButtonVariant.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Private ambient blob widget for subtle background decoration
class _AmbientBlob extends StatelessWidget {
  final Color color;
  final double size;
  const _AmbientBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 60,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}
