import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// ErrorMessage displays an error message with an icon
/// and automatic dismissal after a minimum duration.
///
/// Features:
/// - Error icon with red accent color
/// - Error message text
/// - Minimum display duration of 3 seconds
/// - Fade-in and fade-out animations
/// - Optional retry action button
///
/// Requirements: 5.2, 15.4
class ErrorMessage extends StatefulWidget {
  /// The error message to display
  final String message;
  
  /// Minimum duration to display the error (default 3 seconds)
  final Duration minDuration;
  
  /// Optional callback when the error is dismissed
  final VoidCallback? onDismissed;
  
  /// Optional retry action
  final VoidCallback? onRetry;

  const ErrorMessage({
    super.key,
    required this.message,
    this.minDuration = const Duration(seconds: 3),
    this.onDismissed,
    this.onRetry,
  });

  @override
  State<ErrorMessage> createState() => _ErrorMessageState();
}

class _ErrorMessageState extends State<ErrorMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Start animation
    _controller.forward();

    // Auto-dismiss after minimum duration
    Future.delayed(widget.minDuration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  void _dismiss() async {
    await _controller.reverse();
    if (mounted) {
      widget.onDismissed?.call();
    }
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
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.energyLow,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Error icon
              Icon(
                Icons.error_outline_rounded,
                color: AppColors.energyLow,
                size: 32,
              ),
              const SizedBox(width: 12),
              
              // Error message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Error',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.message,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Optional retry button
              if (widget.onRetry != null) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    widget.onRetry?.call();
                    _dismiss();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.calmBlue,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
