import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// SuccessIndicator displays an animated success checkmark
/// with a fade-in and scale animation.
///
/// Features:
/// - Animated checkmark icon with scale effect
/// - Fade-in animation (300-500ms duration)
/// - Optional success message text
/// - Circular background with success color
///
/// Requirements: 5.2, 15.3
class SuccessIndicator extends StatefulWidget {
  /// Optional message to display below the checkmark
  final String? message;
  
  /// Duration of the success animation (default 400ms, within 300-500ms range)
  final Duration duration;
  
  /// Size of the success indicator circle
  final double size;

  const SuccessIndicator({
    super.key,
    this.message,
    this.duration = const Duration(milliseconds: 400),
    this.size = 80.0,
  });

  @override
  State<SuccessIndicator> createState() => _SuccessIndicatorState();
}

class _SuccessIndicatorState extends State<SuccessIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Scale animation from 0.5 to 1.0 with elastic curve
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    // Fade animation from 0 to 1
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // Start animation immediately
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular background with checkmark
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: AppColors.softGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.softGreen.withOpacity(0.3),
                    blurRadius: 16.0,
                    spreadRadius: 4.0,
                  ),
                ],
              ),
              child: Icon(
                Icons.check_rounded,
                color: AppColors.white,
                size: widget.size * 0.6,
              ),
            ),
            
            // Optional message text
            if (widget.message != null) ...[
              const SizedBox(height: 16),
              Text(
                widget.message!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
