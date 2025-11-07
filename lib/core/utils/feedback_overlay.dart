import 'package:flutter/material.dart';
import '../widgets/success_indicator.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_message.dart';

/// FeedbackOverlay provides utility methods to show success, loading,
/// and error indicators as overlays on top of the current screen.
///
/// Features:
/// - Show success indicator with optional message
/// - Show loading indicator with delayed appearance
/// - Show error message with minimum display duration
/// - Automatic dismissal and cleanup
///
/// Requirements: 5.2, 15.2, 15.3, 15.4
class FeedbackOverlay {
  static OverlayEntry? _currentOverlay;

  /// Show a success indicator overlay
  /// 
  /// [context] - BuildContext for the overlay
  /// [message] - Optional success message
  /// [duration] - How long to display the success indicator (default 2 seconds)
  static void showSuccess(
    BuildContext context, {
    String? message,
    Duration displayDuration = const Duration(seconds: 2),
  }) {
    // Remove any existing overlay
    dismiss();

    final overlay = Overlay.of(context);
    
    _currentOverlay = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: SuccessIndicator(
            message: message,
            duration: const Duration(milliseconds: 400),
          ),
        ),
      ),
    );

    overlay.insert(_currentOverlay!);

    // Auto-dismiss after display duration
    Future.delayed(displayDuration, () {
      dismiss();
    });
  }

  /// Show a loading indicator overlay
  /// 
  /// [context] - BuildContext for the overlay
  /// [message] - Optional loading message
  /// 
  /// Note: Call dismiss() when the operation completes
  static void showLoading(
    BuildContext context, {
    String? message,
  }) {
    // Remove any existing overlay
    dismiss();

    final overlay = Overlay.of(context);
    
    _currentOverlay = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: LoadingIndicator(
            message: message,
            delay: const Duration(milliseconds: 500),
          ),
        ),
      ),
    );

    overlay.insert(_currentOverlay!);
  }

  /// Show an error message overlay
  /// 
  /// [context] - BuildContext for the overlay
  /// [message] - Error message to display
  /// [onRetry] - Optional retry callback
  static void showError(
    BuildContext context, {
    required String message,
    VoidCallback? onRetry,
  }) {
    // Remove any existing overlay
    dismiss();

    final overlay = Overlay.of(context);
    
    _currentOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: SafeArea(
          child: ErrorMessage(
            message: message,
            minDuration: const Duration(seconds: 3),
            onRetry: onRetry,
            onDismissed: () {
              dismiss();
            },
          ),
        ),
      ),
    );

    overlay.insert(_currentOverlay!);
  }

  /// Dismiss the current overlay
  static void dismiss() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}
