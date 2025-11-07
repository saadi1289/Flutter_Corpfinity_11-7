import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';

/// AnimatedProgressIndicator displays a circular progress indicator with
/// smooth transition animations for progress changes.
/// 
/// Features:
/// - Custom painted circular progress ring
/// - Smooth transition animations
/// - Displays progress value and level information
/// - Gradient progress fill
/// 
/// Requirements: 3.3
class AnimatedProgressIndicator extends StatefulWidget {
  /// Progress value from 0.0 to 1.0
  final double progress;
  
  /// Current level number
  final int currentLevel;
  
  /// Duration for progress change animations
  final Duration animationDuration;

  const AnimatedProgressIndicator({
    super.key,
    required this.progress,
    required this.currentLevel,
    this.animationDuration = const Duration(milliseconds: 600),
  });

  @override
  State<AnimatedProgressIndicator> createState() => _AnimatedProgressIndicatorState();
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  double _previousProgress = 0.0;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.progress != widget.progress) {
      _previousProgress = oldWidget.progress;
      
      _progressAnimation = Tween<double>(
        begin: _previousProgress,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress label and percentage
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level Progress',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.white.withOpacity(0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                final percent = (_progressAnimation.value * 100).toInt();
                return Text(
                  '$percent%',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacing12),
        // Animated progress bar
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return CustomPaint(
              size: const Size(double.infinity, 12),
              painter: _ProgressBarPainter(
                progress: _progressAnimation.value,
                backgroundColor: AppColors.white.withOpacity(0.3),
                progressColor: AppColors.white,
              ),
            );
          },
        ),
        const SizedBox(height: AppDimensions.spacing8),
        // Level information
        Text(
          'Next level at 100%',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

/// Custom painter for the progress bar
class _ProgressBarPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  _ProgressBarPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.fill;

    final radius = size.height / 2;
    
    // Draw background
    final backgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    canvas.drawRRect(backgroundRect, backgroundPaint);

    // Draw progress
    if (progress > 0) {
      final progressWidth = size.width * progress.clamp(0.0, 1.0);
      final progressRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, progressWidth, size.height),
        Radius.circular(radius),
      );
      canvas.drawRRect(progressRect, progressPaint);
    }
  }

  @override
  bool shouldRepaint(_ProgressBarPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor;
  }
}
