import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../core/constants/dimensions.dart';
import '../../../data/models/badge.dart' as models;

/// Grid widget showing earned and locked badges
class BadgeGrid extends StatelessWidget {
  final List<models.Badge> badges;
  final Function(models.Badge)? onBadgeTap;

  const BadgeGrid({
    super.key,
    required this.badges,
    this.onBadgeTap,
  });

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events,
                size: AppDimensions.iconSizeXLarge,
                color: AppColors.mediumGray,
              ),
              const SizedBox(height: AppDimensions.spacing16),
              Text(
                'No badges yet',
                style: AppTypography.headingMedium.copyWith(
                  color: AppColors.mediumGray,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                'Complete activities to earn badges',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.mediumGray,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.gridCrossAxisSpacing,
        mainAxisSpacing: AppDimensions.gridMainAxisSpacing,
        childAspectRatio: 0.85,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        return _buildBadgeCard(badge);
      },
    );
  }

  Widget _buildBadgeCard(models.Badge badge) {
    final isLocked = !badge.isUnlocked;

    return GestureDetector(
      onTap: () => onBadgeTap?.call(badge),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: AppDimensions.shadowBlurRadius,
              offset: const Offset(0, AppDimensions.shadowOffsetY),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isLocked 
                    ? AppColors.neutralGray 
                    : AppColors.softGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  badge.iconUrl,
                  style: TextStyle(
                    fontSize: 32,
                    color: isLocked ? AppColors.mediumGray : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing12),
            
            // Badge name
            Text(
              badge.name,
              style: AppTypography.headingSmall.copyWith(
                color: isLocked ? AppColors.mediumGray : AppColors.darkText,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.spacing4),
            
            // Badge description
            Text(
              badge.description,
              style: AppTypography.bodySmall.copyWith(
                color: isLocked ? AppColors.mediumGray : AppColors.mediumGray,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            // Lock indicator or unlock date
            if (isLocked)
              Padding(
                padding: const EdgeInsets.only(top: AppDimensions.spacing8),
                child: Icon(
                  Icons.lock,
                  size: AppDimensions.iconSizeSmall,
                  color: AppColors.mediumGray,
                ),
              )
            else if (badge.unlockedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: AppDimensions.spacing8),
                child: Text(
                  _formatUnlockDate(badge.unlockedAt!),
                  style: AppTypography.caption.copyWith(
                    color: AppColors.softGreen,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatUnlockDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Unlocked today';
    } else if (difference.inDays == 1) {
      return 'Unlocked yesterday';
    } else if (difference.inDays < 7) {
      return 'Unlocked ${difference.inDays} days ago';
    } else {
      return 'Unlocked ${date.month}/${date.day}/${date.year}';
    }
  }
}
