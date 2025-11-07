import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';

/// SettingsSection groups related settings with a title
class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing24,
            vertical: AppDimensions.spacing8,
          ),
          child: Text(
            title,
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.mediumGray,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Enhanced Section Content Card with gradient border
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing16,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.calmBlue.withOpacity(0.3),
                AppColors.softGreen.withOpacity(0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
            boxShadow: [
              BoxShadow(
                color: AppColors.calmBlue.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(1.5),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge - 1.5),
            ),
            child: Column(
              children: _buildChildrenWithDividers(),
            ),
          ),
        ),
      ],
    );
  }

  /// Build children with dividers between them
  List<Widget> _buildChildrenWithDividers() {
    final List<Widget> widgets = [];
    
    for (int i = 0; i < children.length; i++) {
      widgets.add(children[i]);
      
      // Add divider between items (but not after the last one)
      if (i < children.length - 1) {
        widgets.add(
          const Divider(
            height: 1,
            thickness: 1,
            indent: AppDimensions.spacing16,
            endIndent: AppDimensions.spacing16,
          ),
        );
      }
    }
    
    return widgets;
  }
}
