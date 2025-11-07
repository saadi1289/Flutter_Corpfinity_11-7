import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// Inline error widget for form validation errors
class InlineError extends StatelessWidget {
  final String message;
  final EdgeInsets? padding;

  const InlineError({
    super.key,
    required this.message,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 4, left: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error,
            color: AppColors.gentleRed,
            size: 16,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.gentleRed,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
