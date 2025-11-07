import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/dimensions.dart';
import '../utils/animations.dart';
import '../utils/accessibility.dart';

/// AnimatedProgressBar displays an animated progress indicator with gradient fill.
/// Animates from 0 to the target progress value when displayed.
/// Includes accessibility features: semantic labels for screen readers.
class AnimatedProgressBar extends StatefulWidget {
  final double progress; // Value between 0.0 and 1.0
  final double height;
  final List<Color> gradientColors;
  final Color backgroundColor;
  final Duration animationDuration;
  final String? semanticLabel;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    this.height = AppDimensions.progressBarHeight,
    this.gradientColors = AppColors.primaryGradient,
    this.backgroundColor = AppColors.neutralGray,
    this.animationDuration = AppAnimations.progressBarAnimation,
    this.semanticLabel,
  });

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AppAnimations.createProgressBarController(this);

    _animation = AppAnimations.createProgressAnimation(
      _controller,
      targetProgress: widget.progress,
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = AppAnimations.createProgressAnimation(
        _controller,
        targetProgress: widget.progress,
      );
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveSemanticLabel = widget.semanticLabel ??
        AccessibilityUtils.getProgressSemanticLabel(
          widget.progress,
          'Progress',
        );

    return Semantics(
      label: effectiveSemanticLabel,
      value: '${(widget.progress * 100).toInt()}%',
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return RepaintBoundary(
            child: Container(
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(AppDimensions.progressBarBorderRadius),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.progressBarBorderRadius),
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: _animation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: widget.gradientColors,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
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
}
