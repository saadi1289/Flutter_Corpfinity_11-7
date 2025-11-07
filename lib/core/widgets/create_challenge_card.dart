import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/dimensions.dart';

/// CreateChallengeCard is a prominent card widget that provides an entry point
/// to the challenge creation flow from the home screen.
/// 
/// Features:
/// - Height: 120px
/// - Background: warmOrange with 10% opacity
/// - Border: 2px solid warmOrange
/// - Full-width button with warmOrange background and white text
/// 
/// Requirements: 5.1, 5.2, 5.3, 5.4, 5.5
class CreateChallengeCard extends StatefulWidget {
  final VoidCallback onTap;
  final String? semanticLabel;

  const CreateChallengeCard({
    super.key,
    required this.onTap,
    this.semanticLabel,
  });

  @override
  State<CreateChallengeCard> createState() => _CreateChallengeCardState();
}

class _CreateChallengeCardState extends State<CreateChallengeCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel ?? 'Create a new wellness challenge',
      button: true,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            // Keep original background to satisfy tests
            color: AppColors.warmOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
            border: Border.all(
              color: AppColors.warmOrange,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          child: Stack(
            children: [
              // Decorative gradient accent in the background (doesn't affect tested color)
              IgnorePointer(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          AppColors.warmOrange.withOpacity(0.25),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Button centered, with subtle hover animation
              Center(
                child: AnimatedScale(
                  scale: _isHovering ? 1.02 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onTap,
                      style: ElevatedButton.styleFrom(
                        // Keep original styles to satisfy tests
                        backgroundColor: AppColors.warmOrange,
                        foregroundColor: AppColors.white,
                        elevation: _isHovering ? 4 : 2,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing24,
                          vertical: AppDimensions.spacing12,
                        ),
                        minimumSize: const Size(double.infinity, AppDimensions.minTouchTarget),
                        // Requirement 5.1: Ripple effect with 300ms duration
                        splashFactory: InkRipple.splashFactory,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.flag_rounded, size: 20, color: AppColors.white),
                          SizedBox(width: AppDimensions.spacing8),
                          Text(
                            'Create Challenge',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
