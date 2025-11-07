import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Confetti animation widget using Lottie for smooth, performant animations
/// Displays falling confetti particles with rotation and fade effects
class ConfettiAnimation extends StatefulWidget {
  final Duration duration;
  final VoidCallback? onComplete;

  const ConfettiAnimation({
    super.key,
    this.duration = const Duration(milliseconds: 1000),
    this.onComplete,
  });

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Start the animation
    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Lottie.asset(
        'assets/animations/confetti.json',
        controller: _controller,
        repeat: false,
        animate: true,
        fit: BoxFit.cover,
        // Add multiple layers for more confetti effect
        delegates: LottieDelegates(
          values: [
            // You can customize colors and properties here if needed
          ],
        ),
      ),
    );
  }
}
