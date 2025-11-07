import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../core/constants/dimensions.dart';
import '../../../data/models/badge.dart' as models;

/// Animated badge unlock notification with pulse effect
class BadgeUnlockAnimation extends StatefulWidget {
  final models.Badge badge;
  final VoidCallback onComplete;

  const BadgeUnlockAnimation({
    super.key,
    required this.badge,
    required this.onComplete,
  });

  @override
  State<BadgeUnlockAnimation> createState() => _BadgeUnlockAnimationState();
}

class _BadgeUnlockAnimationState extends State<BadgeUnlockAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Pulse animation: 0 → 1.2 → 1.0
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _controller.forward().then((_) {
      // Wait a bit before dismissing
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          widget.onComplete();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacing32,
                    ),
                    padding: const EdgeInsets.all(AppDimensions.spacing32),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Badge icon with glow effect
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.softGreen.withOpacity(0.1),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.softGreen.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              widget.badge.iconUrl,
                              style: const TextStyle(fontSize: 50),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacing24),
                        
                        // "Badge Unlocked!" text
                        Text(
                          'Badge Unlocked!',
                          style: AppTypography.displaySmall.copyWith(
                            color: AppColors.softGreen,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacing8),
                        
                        // Badge name
                        Text(
                          widget.badge.name,
                          style: AppTypography.headingLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.spacing8),
                        
                        // Badge description
                        Text(
                          widget.badge.description,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.mediumGray,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Show badge unlock animation as an overlay
void showBadgeUnlockAnimation(BuildContext context, models.Badge badge) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => BadgeUnlockAnimation(
      badge: badge,
      onComplete: () {
        overlayEntry.remove();
      },
    ),
  );

  overlay.insert(overlayEntry);
}
