import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';

/// UserLevelBadge displays the user's current level in a styled badge.
/// 
/// Features:
/// - Rounded badge with semi-transparent background
/// - Level icon and text
/// - Consistent styling with app theme
/// 
/// Requirements: 3.2
class UserLevelBadge extends StatelessWidget {
  /// User's current level
  final int level;

  const UserLevelBadge({
    super.key,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing12,
        vertical: AppDimensions.spacing8,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(
          color: AppColors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: AppDimensions.iconSizeSmall,
            color: AppColors.white,
          ),
          const SizedBox(width: AppDimensions.spacing4),
          Text(
            'Level $level',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 1),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
