import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/error_handler.dart';
import '../../../core/widgets/error_snackbar.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';

/// ProfileSetupScreen allows users to configure their profile after registration
/// 
/// Features:
/// - Name and company input fields
/// - Multi-select wellness goal chips with bounce animation
/// - Notification preferences toggle switches
/// - Navigation to home screen after completion
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  bool _animateIn = false;
  
  // Wellness goals
  final List<String> _availableGoals = [
    'Stress Reduction',
    'Increased Energy',
    'Better Sleep',
    'Physical Fitness',
    'Healthy Eating',
    'Social Connection',
  ];
  final Set<String> _selectedGoals = {};
  
  // Notification preferences
  bool _notificationsEnabled = true;
  bool _dailyReminders = true;
  bool _achievementAlerts = true;
  
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Trigger subtle entrance animation after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _animateIn = true;
        });
      }
    });
  }

  Future<void> _handleContinue() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedGoals.isEmpty) {
        ErrorSnackBar.show(
          context,
          'Please select at least one wellness goal',
        );
        return;
      }

      setState(() => _isLoading = true);
      
      final success = await ErrorHandler.handleAsync(
        context,
        () async {
          final authProvider = context.read<AuthProvider>();
          await authProvider.updateProfile(
            name: _nameController.text.trim(),
            company: _companyController.text.trim(),
            wellnessGoals: _selectedGoals.toList(),
            notifications: NotificationPreferences(
              enabled: _notificationsEnabled,
              dailyReminders: _dailyReminders,
              achievementAlerts: _achievementAlerts,
            ),
          );
        },
        onSuccess: () {
          if (mounted) {
            context.go('/home');
          }
        },
      );
      
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _toggleGoal(String goal) {
    setState(() {
      if (_selectedGoals.contains(goal)) {
        _selectedGoals.remove(goal);
      } else {
        _selectedGoals.add(goal);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Set Up Your Profile',
          style: AppTypography.headingLarge.copyWith(color: AppColors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Gradient background layer
          _GradientBackdrop(),
          // Ambient shapes for subtle visual interest
          const _AmbientShapes(),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingHorizontal,
                vertical: AppDimensions.screenPaddingVertical,
              ),
              child: Form(
                key: _formKey,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  offset: _animateIn ? Offset.zero : const Offset(0, 0.04),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    opacity: _animateIn ? 1 : 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                // Personal Information Section
                _buildSectionTitle('Personal Information'),
                const SizedBox(height: AppDimensions.spacing16),
                
                _buildInputCard(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        enabled: !_isLoading,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'Enter your name',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                          ),
                        ),
                        validator: (value) => Validators.validateRequired(value, 'Name'),
                      ),
                      
                      const SizedBox(height: AppDimensions.spacing16),
                      
                      TextFormField(
                        controller: _companyController,
                        textInputAction: TextInputAction.done,
                        enabled: !_isLoading,
                        decoration: InputDecoration(
                          labelText: 'Company',
                          hintText: 'Enter your company name',
                          prefixIcon: const Icon(Icons.business_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                          ),
                        ),
                        validator: (value) => Validators.validateRequired(value, 'Company'),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppDimensions.spacing32),
                
                // Wellness Goals Section
                _buildSectionTitle('Wellness Goals'),
                const SizedBox(height: AppDimensions.spacing8),
                Text(
                  'Select areas you want to focus on',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.white.withOpacity(0.9)),
                ),
                const SizedBox(height: AppDimensions.spacing16),
                
                _buildInputCard(
                  child: Wrap(
                    spacing: AppDimensions.spacing8,
                    runSpacing: AppDimensions.spacing8,
                    children: _availableGoals.map((goal) {
                      return _WellnessGoalChip(
                        label: goal,
                        isSelected: _selectedGoals.contains(goal),
                        onTap: _isLoading ? null : () => _toggleGoal(goal),
                      );
                    }).toList(),
                  ),
                ),
                
                const SizedBox(height: AppDimensions.spacing32),
                
                // Notification Preferences Section
                _buildSectionTitle('Notification Preferences'),
                const SizedBox(height: AppDimensions.spacing16),
                
                _buildInputCard(
                  child: Column(
                    children: [
                      _buildToggleRow(
                        title: 'Enable Notifications',
                        subtitle: 'Receive wellness reminders and updates',
                        value: _notificationsEnabled,
                        onChanged: _isLoading
                            ? null
                            : (value) => setState(() => _notificationsEnabled = value),
                      ),
                      
                      const Divider(height: AppDimensions.spacing24),
                      
                      _buildToggleRow(
                        title: 'Daily Reminders',
                        subtitle: 'Get reminded to complete activities',
                        value: _dailyReminders,
                        onChanged: _isLoading || !_notificationsEnabled
                            ? null
                            : (value) => setState(() => _dailyReminders = value),
                      ),
                      
                      const Divider(height: AppDimensions.spacing24),
                      
                      _buildToggleRow(
                        title: 'Achievement Alerts',
                        subtitle: 'Celebrate your milestones and badges',
                        value: _achievementAlerts,
                        onChanged: _isLoading || !_notificationsEnabled
                            ? null
                            : (value) => setState(() => _achievementAlerts = value),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppDimensions.spacing40),
                
                // Continue button
                CustomButton(
                  text: 'Continue',
                  onPressed: _isLoading ? null : _handleContinue,
                  isLoading: _isLoading,
                  variant: ButtonVariant.primary,
                  size: ButtonSize.large,
                ),
                
                const SizedBox(height: AppDimensions.spacing24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.headingMedium.copyWith(color: AppColors.white),
    );
  }

  Widget _buildInputCard({required Widget child}) {
    // Enhanced glass morphism card with gradient border and elevated shadow
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.calmBlue.withOpacity(0.5),
            AppColors.softGreen.withOpacity(0.4),
            AppColors.warmOrange.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.calmBlue.withOpacity(0.2),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: -4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.98),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge - 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppDimensions.spacing24),
        child: child,
      ),
    );
  }

  Widget _buildToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing4),
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.mediumGray,
                ),
              ),
            ],
          ),
        ),
        _AnimatedToggleSwitch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Enhanced wellness goal chip with smooth animations and icon support
class _WellnessGoalChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _WellnessGoalChip({
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  State<_WellnessGoalChip> createState() => _WellnessGoalChipState();
}

class _WellnessGoalChipState extends State<_WellnessGoalChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _elevationAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _getIconForGoal(String goal) {
    switch (goal) {
      case 'Stress Reduction':
        return Icons.spa_outlined;
      case 'Increased Energy':
        return Icons.bolt_outlined;
      case 'Better Sleep':
        return Icons.bedtime_outlined;
      case 'Physical Fitness':
        return Icons.fitness_center_outlined;
      case 'Healthy Eating':
        return Icons.restaurant_outlined;
      case 'Social Connection':
        return Icons.people_outline;
      default:
        return Icons.favorite_outline;
    }
  }

  Future<void> _handleTap() async {
    if (widget.onTap == null) return;
    
    setState(() => _isPressed = true);
    await _controller.forward();
    await _controller.reverse();
    setState(() => _isPressed = false);
    
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing20,
            vertical: AppDimensions.spacing16,
          ),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? LinearGradient(
                    colors: [
                      AppColors.calmBlue,
                      AppColors.calmBlue.withBlue(255),
                      AppColors.softGreen,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: widget.isSelected ? null : AppColors.white,
            border: widget.isSelected
                ? null
                : Border.all(
                    color: AppColors.neutralGray,
                    width: 2,
                  ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.calmBlue.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: AppColors.softGreen.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: -2,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  _getIconForGoal(widget.label),
                  size: 20,
                  color: widget.isSelected ? AppColors.white : AppColors.calmBlue,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing8),
              Text(
                widget.label,
                style: AppTypography.bodyMedium.copyWith(
                  color: widget.isSelected ? AppColors.white : AppColors.darkText,
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Vibrant gradient backdrop matching the welcome page aesthetics
class _GradientBackdrop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

/// Subtle animated ambient shapes to add depth and polish
class _AmbientShapes extends StatelessWidget {
  const _AmbientShapes();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          // Top-left glow
          Positioned(
            left: -80,
            top: -60,
            child: _GlowCircle(
              diameter: 220,
              baseColor: AppColors.calmBlue,
              opacity: 0.35,
            ),
          ),
          // Top-right glow
          Positioned(
            right: -70,
            top: 40,
            child: _GlowCircle(
              diameter: 180,
              baseColor: AppColors.softGreen,
              opacity: 0.30,
            ),
          ),
          // Bottom accent
          Positioned(
            left: -50,
            bottom: -80,
            child: _GlowCircle(
              diameter: 240,
              baseColor: AppColors.warmOrange,
              opacity: 0.20,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double diameter;
  final Color baseColor;
  final double opacity;

  const _GlowCircle({
    required this.diameter,
    required this.baseColor,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: baseColor.withOpacity(opacity * 0.6),
        boxShadow: [
          BoxShadow(
            color: baseColor.withOpacity(opacity),
            blurRadius: 120,
            spreadRadius: 30,
          ),
        ],
      ),
    );
  }
}

/// Custom animated toggle switch with smooth transitions
class _AnimatedToggleSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _AnimatedToggleSwitch({
    required this.value,
    this.onChanged,
  });

  @override
  State<_AnimatedToggleSwitch> createState() => _AnimatedToggleSwitchState();
}

class _AnimatedToggleSwitchState extends State<_AnimatedToggleSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _positionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _colorAnimation = ColorTween(
      begin: AppColors.mediumGray,
      end: AppColors.calmBlue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_AnimatedToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onChanged != null
          ? () => widget.onChanged!(!widget.value)
          : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: 56,
            height: 32,
            decoration: BoxDecoration(
              color: _colorAnimation.value?.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _colorAnimation.value ?? AppColors.mediumGray,
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOutCubic,
                  left: widget.value ? 24 : 2,
                  top: 2,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: widget.value
                          ? const LinearGradient(
                              colors: AppColors.primaryGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: widget.value ? null : AppColors.mediumGray,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (widget.value
                                  ? AppColors.calmBlue
                                  : Colors.black)
                              .withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
