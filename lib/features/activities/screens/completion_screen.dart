import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/widgets/custom_button.dart';
import '../widgets/confetti_animation.dart';
import '../providers/activity_guide_provider.dart';
import '../../home/providers/home_provider.dart';

/// CompletionScreen displays success feedback after completing an activity
/// Shows confetti animation, success message, and updated stats
class CompletionScreen extends StatefulWidget {
  final String? activityName;

  const CompletionScreen({
    super.key,
    this.activityName,
  });

  @override
  State<CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen> {
  bool _showConfetti = true;

  @override
  void initState() {
    super.initState();
    
    // Update user progress after completion
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateProgress();
    });
  }

  void _updateProgress() {
    // Update home provider with new stats
    // This simulates updating the user's progress
    final homeProvider = context.read<HomeProvider>();
    homeProvider.incrementActivityCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.softGreen, AppColors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Confetti animation overlay
              if (_showConfetti)
                Positioned.fill(
                  child: ConfettiAnimation(
                    duration: const Duration(milliseconds: 1000),
                    onComplete: () {
                      setState(() {
                        _showConfetti = false;
                      });
                    },
                  ),
                ),
              
              // Main content
              Column(
                children: [
                  // Close button
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.spacing16),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: AppColors.darkText),
                        onPressed: () {
                          _navigateHome(context);
                        },
                      ),
                    ),
                  ),
                  
                  // Success content
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppDimensions.spacing24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Success icon
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.softGreen.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.check_circle,
                                size: 80,
                                color: AppColors.softGreen,
                              ),
                            ),
                            
                            const SizedBox(height: AppDimensions.spacing32),
                            
                            // Success message
                            Text(
                              'Great Job!',
                              style: AppTypography.displayLarge.copyWith(
                                color: AppColors.darkText,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: AppDimensions.spacing12),
                            
                            // Activity name
                            if (widget.activityName != null)
                              Text(
                                'You completed "${widget.activityName}"',
                                style: AppTypography.bodyLarge.copyWith(
                                  color: AppColors.darkText,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            
                            const SizedBox(height: AppDimensions.spacing40),
                            
                            // Updated stats
                            _buildStatsSection(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Action buttons
                  _buildActionButtons(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return Container(
          padding: const EdgeInsets.all(AppDimensions.spacing24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkText.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Your Progress',
                style: AppTypography.headingMedium.copyWith(
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing20),
              
              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    icon: Icons.local_fire_department,
                    label: 'Streak',
                    value: '${homeProvider.currentStreak}',
                    color: AppColors.warmOrange,
                  ),
                  _buildStatItem(
                    icon: Icons.trending_up,
                    label: 'Weekly Goal',
                    value: '${(homeProvider.weeklyProgress * 100).toInt()}%',
                    color: AppColors.calmBlue,
                  ),
                  _buildStatItem(
                    icon: Icons.star,
                    label: 'Total',
                    value: '${homeProvider.totalActivities}',
                    color: AppColors.softGreen,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacing12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: AppDimensions.iconSizeLarge,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        Text(
          value,
          style: AppTypography.headingLarge.copyWith(
            color: AppColors.darkText,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTypography.caption,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.darkText.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              text: 'Do Another Activity',
              onPressed: () {
                _resetAndNavigateHome(context);
              },
              variant: ButtonVariant.primary,
            ),
            const SizedBox(height: AppDimensions.spacing12),
            CustomButton(
              text: 'Return Home',
              onPressed: () {
                _navigateHome(context);
              },
              variant: ButtonVariant.secondary,
            ),
          ],
        ),
      ),
    );
  }

  void _resetAndNavigateHome(BuildContext context) {
    // Reset activity guide provider
    context.read<ActivityGuideProvider>().reset();
    // Navigate to home
    context.go('/home');
  }

  void _navigateHome(BuildContext context) {
    // Reset activity guide provider
    context.read<ActivityGuideProvider>().reset();
    // Navigate to home
    context.go('/home');
  }
}
