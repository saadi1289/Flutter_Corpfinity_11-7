import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// LoadingIndicator displays an animated loading spinner
/// that appears after a configurable delay.
///
/// Features:
/// - Circular progress indicator with app colors
/// - Delayed appearance (default 500ms to avoid flashing for quick operations)
/// - Optional loading message text
/// - Fade-in animation when appearing
///
/// Requirements: 5.2, 15.2
class LoadingIndicator extends StatefulWidget {
  /// Optional message to display below the spinner
  final String? message;
  
  /// Delay before showing the indicator (default 500ms)
  final Duration delay;
  
  /// Size of the loading spinner
  final double size;
  
  /// Color of the loading spinner
  final Color? color;

  const LoadingIndicator({
    super.key,
    this.message,
    this.delay = const Duration(milliseconds: 500),
    this.size = 40.0,
    this.color,
  });

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    // Delay showing the indicator to avoid flashing for quick operations
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular progress indicator
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.color ?? AppColors.calmBlue,
              ),
            ),
          ),
          
          // Optional message text
          if (widget.message != null) ...[
            const SizedBox(height: 16),
            Text(
              widget.message!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
