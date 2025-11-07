import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../core/constants/dimensions.dart';
import '../../../data/models/completed_activity.dart';

/// List widget showing chronological activity history
class HistoryList extends StatelessWidget {
  final List<CompletedActivity> activities;

  const HistoryList({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: AppDimensions.iconSizeXLarge,
                color: AppColors.mediumGray,
              ),
              const SizedBox(height: AppDimensions.spacing16),
              Text(
                'No activities yet',
                style: AppTypography.headingMedium.copyWith(
                  color: AppColors.mediumGray,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                'Complete your first activity to see it here',
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

    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      itemCount: activities.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppDimensions.spacing12),
      itemBuilder: (context, index) {
        final activity = activities[index];
        return _buildHistoryCard(activity);
      },
    );
  }

  Widget _buildHistoryCard(CompletedActivity activity) {
    return Container(
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
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.softGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: AppColors.softGreen,
              size: AppDimensions.iconSizeMedium,
            ),
          ),
          const SizedBox(width: AppDimensions.spacing16),
          
          // Activity details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.activityName,
                  style: AppTypography.headingSmall,
                ),
                const SizedBox(height: AppDimensions.spacing4),
                Text(
                  _formatDateTime(activity.completedAt),
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          
          // Points
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing12,
              vertical: AppDimensions.spacing8,
            ),
            decoration: BoxDecoration(
              color: AppColors.calmBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  size: AppDimensions.iconSizeSmall,
                  color: AppColors.warmOrange,
                ),
                const SizedBox(width: AppDimensions.spacing4),
                Text(
                  '+${activity.pointsEarned}',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.calmBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final activityDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (activityDate == today) {
      dateStr = 'Today';
    } else if (activityDate == yesterday) {
      dateStr = 'Yesterday';
    } else {
      dateStr = '${_getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}';
    }

    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$dateStr at $hour:$minute $period';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
