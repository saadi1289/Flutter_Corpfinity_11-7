import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'custom_button.dart';

/// Dialog widget for displaying critical errors
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const ErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.onDismiss,
  });

  /// Shows an error dialog
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
        onRetry: onRetry,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.gentleRed.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: AppColors.gentleRed,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.mediumGray,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Action buttons
            if (onRetry != null)
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Retry',
                      onPressed: () {
                        Navigator.of(context).pop();
                        onRetry?.call();
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Cancel',
                      variant: ButtonVariant.secondary,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onDismiss?.call();
                      },
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'OK',
                  onPressed: () {
                    Navigator.of(context).pop();
                    onDismiss?.call();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
