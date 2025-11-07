import 'package:flutter/material.dart';
import '../constants/dimensions.dart';
import '../constants/typography.dart';
import 'custom_card.dart';

/// SupportiveSectionCard is a reusable card widget for displaying supportive
/// information sections on the home screen (e.g., Daily Progress, Tips, Streaks).
///
/// Features:
/// - Minimum height of 100px
/// - Icon positioned on the left (32px size)
/// - Title using bodyLarge typography
/// - Content using bodyMedium typography
/// - Uses existing CustomCard styling for consistency
/// - Supports custom accent colors for the icon
class SupportiveSectionCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color accentColor;

  const SupportiveSectionCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title: $content',
      child: CustomCard(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 100.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon on the left
              Icon(
                icon,
                size: AppDimensions.iconSizeLarge,
                color: accentColor,
              ),
              const SizedBox(width: AppDimensions.spacing16),
              // Title and content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyLarge,
                    ),
                    const SizedBox(height: AppDimensions.spacing8),
                    Text(
                      content,
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
