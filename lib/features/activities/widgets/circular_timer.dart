import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';

/// Circular timer widget that displays countdown with a circular progress indicator
class CircularTimer extends StatelessWidget {
  final int totalSeconds;
  final int remainingSeconds;
  final bool isRunning;
  final VoidCallback? onPause;
  final VoidCallback? onResume;

  const CircularTimer({
    super.key,
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.isRunning,
    this.onPause,
    this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalSeconds > 0 
        ? remainingSeconds / totalSeconds 
        : 0.0;
    
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    final timeText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: () {
        if (isRunning && onPause != null) {
          onPause!();
        } else if (!isRunning && remainingSeconds > 0 && onResume != null) {
          onResume!();
        }
      },
      child: SizedBox(
        width: 160,
        height: 160,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background circle
            SizedBox(
              width: 160,
              height: 160,
              child: CustomPaint(
                painter: _CircularTimerPainter(
                  progress: progress,
                  isRunning: isRunning,
                ),
              ),
            ),
            
            // Time text and status
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeText,
                  style: AppTypography.displayLarge.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (remainingSeconds > 0)
                  Icon(
                    isRunning ? Icons.pause_circle_outline : Icons.play_circle_outline,
                    color: AppColors.calmBlue,
                    size: 24,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularTimerPainter extends CustomPainter {
  final double progress;
  final bool isRunning;

  _CircularTimerPainter({
    required this.progress,
    required this.isRunning,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    // Background circle
    final backgroundPaint = Paint()
      ..color = AppColors.neutralGray
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: isRunning 
            ? [AppColors.calmBlue, AppColors.softGreen]
            : [AppColors.mediumGray, AppColors.mediumGray],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularTimerPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isRunning != isRunning;
  }
}
