import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:corpfinity_employee_app/core/constants/colors.dart';
import 'package:corpfinity_employee_app/core/constants/dimensions.dart';
import 'package:corpfinity_employee_app/core/constants/typography.dart';
import 'package:corpfinity_employee_app/core/widgets/selection_card.dart';
import 'package:corpfinity_employee_app/core/widgets/challenge_display_card.dart';
import 'package:corpfinity_employee_app/core/widgets/static_challenge_card.dart';
import 'package:corpfinity_employee_app/data/repositories/static_challenge_repository.dart';
import 'package:corpfinity_employee_app/core/utils/responsive_helper.dart';
import 'package:corpfinity_employee_app/data/models/enums.dart';
import 'package:corpfinity_employee_app/data/models/enum_helpers.dart';
import 'package:corpfinity_employee_app/features/challenges/providers/challenge_flow_provider.dart';

/// ChallengeFlowScreen - Multi-step challenge creation flow
/// 
/// The screen guides users through:
/// 1. Energy level selection
/// 2. Location context selection
/// 3. Wellness goal selection
/// 4. Challenge generation and display
/// 
/// Features responsive design:
/// - Scrollable cards on small screens (< 375px)
/// - Adaptive grid: 2 columns on medium/large, 1 column on very small screens
/// - Minimum 44x44px touch targets maintained
class ChallengeFlowScreen extends StatefulWidget {
  const ChallengeFlowScreen({super.key});

  @override
  State<ChallengeFlowScreen> createState() => _ChallengeFlowScreenState();
}

class _ChallengeFlowScreenState extends State<ChallengeFlowScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _transitionController;
  int _previousStep = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    // Ensure the initial step content is visible on first build.
    // Without this, FadeTransition opacity may start at 0, causing a blank screen
    // until a step change triggers an animation.
    _transitionController.value = 1.0;
    
    // Reset flow when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChallengeFlowProvider>().resetFlow();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChallengeFlowProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Challenge'),
            leading: Semantics(
              label: provider.currentStep > 0 
                ? 'Go back to previous step' 
                : 'Go back to previous screen',
              button: true,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (provider.currentStep > 0) {
                    provider.goToPreviousStep();
                  } else {
                    context.pop();
                  }
                },
              ),
            ),
          ),
          body: Builder(
            builder: (context) {
              // Animate to the new step when it changes
              if (provider.currentStep != _previousStep) {
                _animateToStep(provider.currentStep);
                _previousStep = provider.currentStep;
              }
              
              return PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable swipe
                children: [
                  _buildEnergySelectionStep(provider),
                  _buildLocationSelectionStep(provider),
                  _buildGoalSelectionStep(provider),
                ],
              );
            },
          ),
        );
      },
    );
  }

  /// Animate to the specified step with slide/fade transition
  void _animateToStep(int step) {
    if (_pageController.hasClients) {
      _transitionController.forward(from: 0.0);
      _pageController.animateToPage(
        step,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Build interactive step indicator with dots and lines
  Widget _buildStepIndicator(ChallengeFlowProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepDot(0, provider),
        _buildStepLine(provider.selectedEnergy != null),
        _buildStepDot(1, provider),
        _buildStepLine(provider.selectedLocation != null),
        _buildStepDot(2, provider),
      ],
    );
  }

  /// Build individual step dot with tap handling
  Widget _buildStepDot(int step, ChallengeFlowProvider provider) {
    final isActive = step == provider.currentStep;
    final isCompleted = _isStepCompleted(step, provider);
    final canNavigate = step < provider.currentStep || isCompleted;
    
    return GestureDetector(
      onTap: canNavigate ? () => _navigateToStep(step, provider) : null,
      child: Semantics(
        label: 'Step ${step + 1}${isActive ? ', current step' : ''}${isCompleted ? ', completed' : ''}',
        button: canNavigate,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isActive ? 12 : 8,
          height: isActive ? 12 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted || isActive 
              ? AppColors.calmBlue 
              : AppColors.neutralGray,
            border: isActive 
              ? Border.all(color: AppColors.calmBlue, width: 2)
              : null,
          ),
        ),
      ),
    );
  }

  /// Build line connecting step dots
  Widget _buildStepLine(bool isCompleted) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 40,
      height: 2,
      color: isCompleted ? AppColors.calmBlue : AppColors.neutralGray,
    );
  }

  /// Check if a step is completed based on selections
  bool _isStepCompleted(int step, ChallengeFlowProvider provider) {
    switch (step) {
      case 0:
        return provider.selectedEnergy != null;
      case 1:
        return provider.selectedLocation != null;
      case 2:
        return provider.selectedGoal != null;
      default:
        return false;
    }
  }

  /// Navigate to a specific step
  /// Allows navigation to previous completed steps
  /// Prevents navigation to future incomplete steps
  void _navigateToStep(int targetStep, ChallengeFlowProvider provider) {
    final currentStep = provider.currentStep;
    
    if (targetStep == currentStep) {
      return; // Already on this step
    }
    
    if (targetStep > currentStep) {
      // Prevent navigation to future steps
      return;
    }
    
    // Navigate backwards using goToPreviousStep() in a loop
    while (provider.currentStep > targetStep) {
      provider.goToPreviousStep();
    }
  }

  Widget _buildEnergySelectionStep(ChallengeFlowProvider provider) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final padding = ResponsiveHelper.getScreenPadding(context);
          final isSmallScreen = ResponsiveHelper.isSmallScreen(context);

          // Calculate responsive card width: (screenWidth - padding) / 3
          final horizontalPadding = padding * 2;
          final spacingBetweenCards = 16.0 * 2; // 16px spacing between 3 cards = 2 gaps
          final cardWidth = (screenWidth - horizontalPadding - spacingBetweenCards) / 3;

          final fadeAnimation = _transitionController.drive(
            CurveTween(curve: Curves.easeOut)).drive(Tween<double>(begin: 0.0, end: 1.0));
          final slideAnimation = _transitionController.drive(
            Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero).chain(CurveTween(curve: Curves.easeOut)));

          return Padding(
            padding: EdgeInsets.all(padding),
            child: FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Center the prompt and cards vertically within available space
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: isSmallScreen ? AppDimensions.spacing16 : AppDimensions.spacing24),
                              _buildCreativeHeader(
                                title: "How's your energy today?",
                                subtitle: "Tune into your vibe — we'll craft a mini‑challenge that matches your spark.",
                                tags: const [
                                  'slow & steady 🌙',
                                  'balanced ☀️',
                                  'fast & bold ⚡️',
                                ],
                                accentColor: AppColors.warmOrange,
                              ),
                              SizedBox(height: isSmallScreen ? AppDimensions.spacing24 : AppDimensions.spacing40),
                              // Creative tip banner to keep the screen feeling alive
                              _buildInfoBanner(
                                title: 'Quick tip',
                                message: "Not sure which to pick? Try Balanced — it's a steady choice for most days.",
                                accentColor: AppColors.warmOrange,
                                icon: Icons.lightbulb_outline,
                              ),
                              const SizedBox(height: AppDimensions.spacing16),
                              // Energy level cards - horizontal scrollable layout
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: cardWidth,
                                      child: _buildEnergyCard(
                                        provider,
                                        EnergyLevel.low,
                                        AppColors.energyLow,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    SizedBox(
                                      width: cardWidth,
                                      child: _buildEnergyCard(
                                        provider,
                                        EnergyLevel.medium,
                                        AppColors.energyMedium,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    SizedBox(
                                      width: cardWidth,
                                      child: _buildEnergyCard(
                                        provider,
                                        EnergyLevel.high,
                                        AppColors.energyHigh,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Step indicator
                    Padding(
                      padding: EdgeInsets.only(bottom: isSmallScreen ? AppDimensions.spacing16 : AppDimensions.spacing24),
                      child: _buildStepIndicator(provider),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnergyCard(
    ChallengeFlowProvider provider,
    EnergyLevel energy,
    Color accentColor,
  ) {
    final isSelected = provider.selectedEnergy == energy;
    
    return RepaintBoundary(
      child: SizedBox(
        height: 100,
        child: SelectionCard(
          label: EnergyLevelHelper.getLabel(energy),
          icon: EnergyLevelHelper.getIcon(energy),
          isSelected: isSelected,
          accentColor: accentColor,
          useOutlineIcon: true,
          onTap: () {
            provider.selectEnergy(energy);
            // Auto-advance to next step after 300ms delay
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                provider.goToNextStep();
              }
            });
          },
          iconSize: 36,
        ),
      ),
    );
  }

  Widget _buildLocationSelectionStep(ChallengeFlowProvider provider) {
    return SafeArea(
      bottom: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final padding = ResponsiveHelper.getScreenPadding(context);
          final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
          final isVerySmallScreen = ResponsiveHelper.isVerySmallScreen(context);

          final fadeAnimation = _transitionController.drive(
            CurveTween(curve: Curves.easeOut)).drive(Tween<double>(begin: 0.0, end: 1.0));
          final slideAnimation = _transitionController.drive(
            Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero).chain(CurveTween(curve: Curves.easeOut)));

          return Padding(
            padding: EdgeInsets.all(padding),
            child: FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Center the prompt and grid vertically
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 420,
                            maxHeight: constraints.maxHeight,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: isSmallScreen ? AppDimensions.spacing16 : AppDimensions.spacing24),
                              _buildCreativeHeader(
                                title: 'Where are you right now?',
                                subtitle: 'Your space shapes the flow — pick a scene that matches your moment.',
                                tags: const [
                                  'homey calm 🛋️',
                                  'office focus 💼',
                                  'gym grind 🏋️',
                                  'outdoor refresh 🌿',
                                ],
                                accentColor: AppColors.calmBlue,
                              ),
                              SizedBox(height: isSmallScreen ? AppDimensions.spacing24 : AppDimensions.spacing40),
                              // Creative guidance banner
                              _buildInfoBanner(
                                title: 'Pro move',
                                message: 'Choose where you will actually be for the next 10–15 minutes to make it stick.',
                                accentColor: AppColors.calmBlue,
                                icon: Icons.place_outlined,
                              ),
                              const SizedBox(height: AppDimensions.spacing16),
                              // Location cards - adaptive grid with proper constraints
                              SingleChildScrollView(
                                child: Center(
                                  child: isVerySmallScreen
                                      ? _buildSingleColumnLocationGrid(provider)
                                      : _buildTwoColumnLocationGrid(provider),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Step indicator
                    Padding(
                      padding: EdgeInsets.only(bottom: isSmallScreen ? AppDimensions.spacing16 : AppDimensions.spacing24),
                      child: _buildStepIndicator(provider),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build 2-column grid for location cards (medium/large screens)
  Widget _buildTwoColumnLocationGrid(ChallengeFlowProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // First row: Home and Office
        Row(
          children: [
            Expanded(
              child: _buildLocationCard(
                provider,
                LocationContext.home,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildLocationCard(
                provider,
                LocationContext.office,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Second row: Gym and Outdoor
        Row(
          children: [
            Expanded(
              child: _buildLocationCard(
                provider,
                LocationContext.gym,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildLocationCard(
                provider,
                LocationContext.outdoor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build single-column grid for location cards (very small screens)
  Widget _buildSingleColumnLocationGrid(ChallengeFlowProvider provider) {
    return Column(
      children: [
        _buildLocationCard(provider, LocationContext.home),
        const SizedBox(height: 12),
        _buildLocationCard(provider, LocationContext.office),
        const SizedBox(height: 12),
        _buildLocationCard(provider, LocationContext.gym),
        const SizedBox(height: 12),
        _buildLocationCard(provider, LocationContext.outdoor),
      ],
    );
  }

  /// Get location-specific color for color-coded styling
  Color _getLocationColor(LocationContext location) {
    switch (location) {
      case LocationContext.home:
        return AppColors.warmOrange;
      case LocationContext.office:
        return AppColors.professionalBlue;
      case LocationContext.gym:
        return AppColors.energeticRed;
      case LocationContext.outdoor:
        return AppColors.natureGreen;
    }
  }

  /// Get wellness goal-specific color for color-coded styling
  Color _getGoalColor(WellnessGoal goal) {
    switch (goal) {
      case WellnessGoal.stressReduction:
        return AppColors.calmBlue;
      case WellnessGoal.increasedEnergy:
        return AppColors.warmOrange;
      case WellnessGoal.betterSleep:
        return AppColors.softPurple;
      case WellnessGoal.physicalFitness:
        return AppColors.softGreen;
      case WellnessGoal.healthyEating:
        return AppColors.freshGreen;
      case WellnessGoal.socialConnection:
        return AppColors.coralPink;
    }
  }

  Widget _buildLocationCard(
    ChallengeFlowProvider provider,
    LocationContext location,
  ) {
    final isSelected = provider.selectedLocation == location;
    final color = _getLocationColor(location);
    
    return RepaintBoundary(
      child: SizedBox(
        height: 130,
        child: SelectionCard(
          label: LocationContextHelper.getLabel(location),
          icon: LocationContextHelper.getIcon(location),
          isSelected: isSelected,
          accentColor: color,
          useOutlineIcon: true,
          onTap: () {
            provider.selectLocation(location);
            // Auto-advance to next step after 300ms delay
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                provider.goToNextStep();
              }
            });
          },
          iconSize: 40,
        ),
      ),
    );
  }

  Widget _buildGoalSelectionStep(ChallengeFlowProvider provider) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final padding = ResponsiveHelper.getScreenPadding(context);
          final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
          final isVerySmallScreen = ResponsiveHelper.isVerySmallScreen(context);

          final fadeAnimation = _transitionController.drive(
            CurveTween(curve: Curves.easeOut)).drive(Tween<double>(begin: 0.0, end: 1.0));
          final slideAnimation = _transitionController.drive(
            Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero).chain(CurveTween(curve: Curves.easeOut)));

          return Padding(
            padding: EdgeInsets.all(padding),
            child: FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Center the prompt and grid vertically
                    Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                              SizedBox(height: isSmallScreen ? AppDimensions.spacing16 : AppDimensions.spacing24),
                              _buildCreativeHeader(
                                title: 'What wellness area do you want to focus on?',
                                subtitle: 'Plant a seed — we’ll weave a personalized challenge just for you.',
                                tags: const [
                                  'de‑stress 🌊',
                                  'energize ⚡️',
                                  'sleep deeply 🌙',
                                  'move strong 💪',
                                  'nourish 🥗',
                                  'connect 🤝',
                                ],
                                accentColor: AppColors.softPurple,
                              ),
                              SizedBox(height: isSmallScreen ? AppDimensions.spacing24 : AppDimensions.spacing40),
                              // Creative nudge banner
                              _buildInfoBanner(
                                title: 'Set an intention',
                                message: 'Pick the area that feels meaningful right now — small steps grow big change.',
                                accentColor: AppColors.softPurple,
                                icon: Icons.spa_outlined,
                              ),
                              const SizedBox(height: AppDimensions.spacing16),
                              // Wellness goal cards - adaptive grid
                              // Add horizontal padding so cards don't collide with screen edges
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.spacing16,
                                ),
                                child: Center(
                                  child: isVerySmallScreen
                                      ? _buildSingleColumnGoalGrid(provider)
                                      : _buildTwoColumnGoalGrid(provider),
                                ),
                              ),
                              // Challenge display section (show as soon as a wellness goal is selected)
                              if (provider.selectedGoal != null) ...[
                                const SizedBox(height: 32),
                                // "Your Challenge" header
                                Text(
                                  'Your Challenge',
                                  style: AppTypography.headingMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                // Elegant static challenge card display (from ElegantChallengeCreationScreen)
                                StaticChallengeCard(
                                  challenge: StaticChallengeRepository.getChallengeForWellnessArea(
                                    provider.selectedGoal!,
                                  ),
                                ),
                                const SizedBox(height: AppDimensions.spacing24),
                                // Start Challenge button
                                Semantics(
                                  label: 'Start this wellness challenge',
                                  button: true,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _handleStartChallenge(context, provider);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.calmBlue,
                                      foregroundColor: AppColors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: AppDimensions.spacing16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppDimensions.buttonBorderRadius,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Start Challenge',
                                      style: AppTypography.buttonLarge,
                                    ),
                                  ),
                                ),
                              ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Step indicator
                    Padding(
                      padding: EdgeInsets.only(bottom: isSmallScreen ? AppDimensions.spacing16 : AppDimensions.spacing24),
                      child: _buildStepIndicator(provider),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Creative step header with title, subtitle, and decorative tag pills
  Widget _buildCreativeHeader({
    required String title,
    required String subtitle,
    required List<String> tags,
    required Color accentColor,
  }) {
    return Semantics(
      label: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Text(
            title,
            style: AppTypography.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacing12),
          // Subtitle
          Text(
            subtitle,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.mediumGray),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacing16),
          // Decorative tags
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: tags.map((t) => _buildTagPill(t, accentColor)).toList(),
          ),
        ],
      ),
    );
  }

  /// Small pill-shaped decorative tag with subtle accent
  Widget _buildTagPill(String text, Color accentColor) {
    return Semantics(
      label: text,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing12,
        ),
        decoration: BoxDecoration(
          // Rectangular card with no borders (replacing pill styling)
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: AppTypography.bodySmall.copyWith(color: AppColors.darkText),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// Soft guidance banner used to add creative text on selection screens
  Widget _buildInfoBanner({
    required String title,
    required String message,
    required Color accentColor,
    required IconData icon,
  }) {
    return Semantics(
      label: '$title. $message',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          // Rectangular card with subtle background tint and no borders
          color: accentColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: accentColor, size: 24),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.darkText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build 2-column grid for goal cards (medium/large screens)
  Widget _buildTwoColumnGoalGrid(ChallengeFlowProvider provider) {
    return Column(
      children: [
        // First row: Stress Reduction and Increased Energy
        Row(
          children: [
            Expanded(
              child: _buildGoalCard(
                provider,
                WellnessGoal.stressReduction,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGoalCard(
                provider,
                WellnessGoal.increasedEnergy,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Second row: Better Sleep and Physical Fitness
        Row(
          children: [
            Expanded(
              child: _buildGoalCard(
                provider,
                WellnessGoal.betterSleep,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGoalCard(
                provider,
                WellnessGoal.physicalFitness,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Third row: Healthy Eating and Social Connection
        Row(
          children: [
            Expanded(
              child: _buildGoalCard(
                provider,
                WellnessGoal.healthyEating,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGoalCard(
                provider,
                WellnessGoal.socialConnection,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build single-column grid for goal cards (very small screens)
  Widget _buildSingleColumnGoalGrid(ChallengeFlowProvider provider) {
    return Column(
      children: [
        _buildGoalCard(provider, WellnessGoal.stressReduction),
        const SizedBox(height: 12),
        _buildGoalCard(provider, WellnessGoal.increasedEnergy),
        const SizedBox(height: 12),
        _buildGoalCard(provider, WellnessGoal.betterSleep),
        const SizedBox(height: 12),
        _buildGoalCard(provider, WellnessGoal.physicalFitness),
        const SizedBox(height: 12),
        _buildGoalCard(provider, WellnessGoal.healthyEating),
        const SizedBox(height: 12),
        _buildGoalCard(provider, WellnessGoal.socialConnection),
      ],
    );
  }

  /// Handle Start Challenge button tap
  /// Placeholder navigation - will be implemented in future tasks
  void _handleStartChallenge(
    BuildContext context,
    ChallengeFlowProvider provider,
  ) {
    // Show confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Challenge started! This will navigate to the challenge tracking screen.'),
        backgroundColor: AppColors.calmBlue,
        duration: const Duration(seconds: 2),
      ),
    );

    // Placeholder: Navigate back to home after a delay
    // In future, this will navigate to a challenge tracking/detail screen
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        context.go('/home');
      }
    });
  }

  Widget _buildGoalCard(
    ChallengeFlowProvider provider,
    WellnessGoal goal,
  ) {
    final isSelected = provider.selectedGoal == goal;
    final color = _getGoalColor(goal);
    
    return RepaintBoundary(
      child: SizedBox(
        height: 110,
        child: SelectionCard(
          label: WellnessGoalHelper.getLabel(goal),
          icon: WellnessGoalHelper.getIcon(goal),
          isSelected: isSelected,
          accentColor: color,
          useOutlineIcon: true,
          onTap: () {
            provider.selectGoal(goal);
          },
          iconSize: 36,
        ),
      ),
    );
  }

  Widget _buildPlaceholderStep(String title, String stepText) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.spacing24),
            Text(
              title,
              style: AppTypography.headingLarge,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Text(
              'This step will be implemented in upcoming tasks',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacing24),
              child: Text(
                stepText,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.mediumGray,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
