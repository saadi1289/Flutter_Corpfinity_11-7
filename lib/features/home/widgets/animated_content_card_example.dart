import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';
import '../../../core/widgets/supportive_section_card.dart';
import '../../../core/widgets/create_challenge_card.dart';
import 'animated_content_card.dart';

/// Example demonstrating how to use AnimatedContentCard to wrap content cards
/// with entrance animations and interactive effects.
///
/// This example shows:
/// 1. Wrapping existing cards with AnimatedContentCard
/// 2. Applying staggered entrance animations (100ms delay between cards)
/// 3. Adding tap callbacks for interactive cards
/// 4. Using visibility detection for scroll-triggered animations
class AnimatedContentCardExample extends StatelessWidget {
  const AnimatedContentCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedContentCard Example'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(height: AppDimensions.spacing16),
            ),
            
            // Example 1: Daily Progress Card with 0ms delay
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingHorizontal,
                  vertical: AppDimensions.spacing8,
                ),
                child: AnimatedContentCard(
                  animationDelay: 0,
                  visibilityKey: const Key('daily_progress_card'),
                  child: const SupportiveSectionCard(
                    title: 'Daily Progress Summary',
                    content: '5 activities completed today',
                    icon: Icons.check_circle_outline,
                    accentColor: AppColors.calmBlue,
                  ),
                ),
              ),
            ),
            
            // Example 2: Tip of the Day Card with 100ms delay
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingHorizontal,
                  vertical: AppDimensions.spacing8,
                ),
                child: AnimatedContentCard(
                  animationDelay: 100,
                  visibilityKey: const Key('tip_card'),
                  child: const SupportiveSectionCard(
                    title: 'Tip of the Day',
                    content: 'Take a 5-minute walk break every hour to boost energy',
                    icon: Icons.lightbulb_outline,
                    accentColor: AppColors.warmOrange,
                  ),
                ),
              ),
            ),
            
            // Example 3: Current Streak Card with 200ms delay
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingHorizontal,
                  vertical: AppDimensions.spacing8,
                ),
                child: AnimatedContentCard(
                  animationDelay: 200,
                  visibilityKey: const Key('streak_card'),
                  child: const SupportiveSectionCard(
                    title: 'Current Streak',
                    content: '7 days in a row! Keep it up!',
                    icon: Icons.local_fire_department,
                    accentColor: AppColors.energyHigh,
                  ),
                ),
              ),
            ),
            
            // Example 4: Interactive Card with onTap callback and 300ms delay
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
                child: AnimatedContentCard(
                  animationDelay: 300,
                  visibilityKey: const Key('create_challenge_card'),
                  onTap: () {
                    // Handle tap - navigate or show dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Create Challenge tapped!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: CreateChallengeCard(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Create Challenge tapped!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            
            // Example 5: Custom card content with hover disabled
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingHorizontal,
                  vertical: AppDimensions.spacing8,
                ),
                child: AnimatedContentCard(
                  animationDelay: 400,
                  enableHoverEffect: false, // Disable hover for this card
                  visibilityKey: const Key('custom_card'),
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.cardPadding),
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.cardBorderRadius,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Custom Card',
                          style: AppTypography.bodyLarge,
                        ),
                        const SizedBox(height: AppDimensions.spacing8),
                        Text(
                          'This card has hover effects disabled',
                          style: AppTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Bottom spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: AppDimensions.spacing16),
            ),
          ],
        ),
      ),
    );
  }
}

/// Usage Notes:
/// 
/// 1. Basic Usage:
/// ```dart
/// AnimatedContentCard(
///   child: YourCardWidget(),
/// )
/// ```
/// 
/// 2. With Staggered Animation:
/// ```dart
/// AnimatedContentCard(
///   animationDelay: 100, // 100ms delay
///   child: YourCardWidget(),
/// )
/// ```
/// 
/// 3. With Tap Callback:
/// ```dart
/// AnimatedContentCard(
///   onTap: () => print('Card tapped'),
///   child: YourCardWidget(),
/// )
/// ```
/// 
/// 4. With Custom Visibility Key:
/// ```dart
/// AnimatedContentCard(
///   visibilityKey: const Key('unique_card_id'),
///   child: YourCardWidget(),
/// )
/// ```
/// 
/// 5. Disable Hover Effects:
/// ```dart
/// AnimatedContentCard(
///   enableHoverEffect: false,
///   child: YourCardWidget(),
/// )
/// ```
/// 
/// Platform Behavior:
/// - Desktop (Windows, macOS, Linux): Hover effects enabled (scale + shadow)
/// - Mobile (iOS, Android): Press state animation (slight scale down)
/// - Web: Hover effects enabled
/// 
/// Animation Details:
/// - Entrance: 300ms fade-in + slide-up from 10% below
/// - Hover transition: 200ms ease-in-out
/// - Scale on hover: 105% (1.05x)
/// - Shadow on hover: 16px blur with 0.15 opacity
/// - Press scale: 98% (0.98x) on mobile
/// - Ripple effect: Material InkWell with card border radius
