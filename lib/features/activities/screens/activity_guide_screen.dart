import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/widgets/custom_button.dart';
import '../providers/activity_provider.dart';
import '../providers/activity_guide_provider.dart';
import '../widgets/circular_timer.dart';

/// ActivityGuideScreen displays step-by-step instructions for completing an activity
/// Includes progress tracking, timer for timed activities, and navigation between steps
class ActivityGuideScreen extends StatefulWidget {
  final String activityId;

  const ActivityGuideScreen({
    super.key,
    required this.activityId,
  });

  @override
  State<ActivityGuideScreen> createState() => _ActivityGuideScreenState();
}

class _ActivityGuideScreenState extends State<ActivityGuideScreen> {
  @override
  void initState() {
    super.initState();
    
    // Load activity and start guide
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final activityProvider = context.read<ActivityProvider>();
      final guideProvider = context.read<ActivityGuideProvider>();
      
      final activity = activityProvider.getActivityById(widget.activityId);
      if (activity != null) {
        guideProvider.startActivity(activity);
      } else {
        // Activity not found, go back
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityGuideProvider>(
      builder: (context, guideProvider, child) {
        final activity = guideProvider.currentActivity;
        final currentStep = guideProvider.currentStep;

        if (activity == null || currentStep == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: AppColors.darkText),
              onPressed: () {
                _showExitDialog(context, guideProvider);
              },
            ),
            title: Text(
              activity.name,
              style: AppTypography.headingMedium,
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Progress bar
                _buildProgressBar(guideProvider),
                
                // Step content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDimensions.spacing24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Step number
                        Text(
                          'Step ${currentStep.stepNumber} of ${activity.steps.length}',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.calmBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacing16),
                        
                        // Step title
                        Text(
                          currentStep.title,
                          style: AppTypography.displayMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.spacing32),
                        
                        // Illustration/Image placeholder
                        if (currentStep.imageUrl != null)
                          _buildStepImage(currentStep.imageUrl!)
                        else
                          _buildPlaceholderImage(),
                        
                        const SizedBox(height: AppDimensions.spacing32),
                        
                        // Timer (if step has timer)
                        if (currentStep.timerSeconds != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppDimensions.spacing32),
                            child: CircularTimer(
                              totalSeconds: currentStep.timerSeconds!,
                              remainingSeconds: guideProvider.remainingSeconds,
                              isRunning: guideProvider.isTimerRunning,
                              onPause: guideProvider.pauseTimer,
                              onResume: guideProvider.resumeTimer,
                            ),
                          ),
                        
                        // Instruction text
                        Text(
                          currentStep.instruction,
                          style: AppTypography.bodyLarge.copyWith(
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Navigation buttons
                _buildNavigationButtons(context, guideProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(ActivityGuideProvider guideProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing12,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.progressBarBorderRadius),
        child: LinearProgressIndicator(
          value: guideProvider.progress,
          minHeight: AppDimensions.progressBarHeight,
          backgroundColor: AppColors.neutralGray,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.calmBlue),
        ),
      ),
    );
  }

  Widget _buildStepImage(String imageUrl) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        color: AppColors.neutralGray,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderImage();
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        gradient: const LinearGradient(
          colors: [AppColors.calmBlue, AppColors.softGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Icon(
        Icons.self_improvement,
        size: 80,
        color: AppColors.white,
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, ActivityGuideProvider guideProvider) {
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
        child: Row(
          children: [
            // Previous button (if not first step)
            if (guideProvider.currentStepIndex > 0)
              Expanded(
                child: CustomButton(
                  text: 'Previous',
                  onPressed: guideProvider.previousStep,
                  variant: ButtonVariant.secondary,
                ),
              ),
            
            if (guideProvider.currentStepIndex > 0)
              const SizedBox(width: AppDimensions.spacing12),
            
            // Next/Complete button
            Expanded(
              flex: guideProvider.currentStepIndex > 0 ? 1 : 1,
              child: CustomButton(
                text: guideProvider.hasNextStep ? 'Next Step' : 'Complete',
                onPressed: () {
                  if (guideProvider.hasNextStep) {
                    guideProvider.nextStep();
                  } else {
                    guideProvider.completeActivity();
                    // Navigate to completion screen
                    context.go(
                      '/completion?activity=${Uri.encodeComponent(guideProvider.currentActivity!.name)}',
                    );
                  }
                },
                variant: ButtonVariant.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExitDialog(BuildContext context, ActivityGuideProvider guideProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Activity?'),
        content: const Text('Are you sure you want to exit? Your progress will not be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              guideProvider.reset();
              Navigator.of(context).pop();
              context.pop();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}
