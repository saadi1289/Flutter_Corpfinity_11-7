import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/colors.dart';
import '../constants/dimensions.dart';
import '../constants/typography.dart';
import '../utils/accessibility.dart';

/// ActivityCard displays an activity in list or grid layout with thumbnail support.
/// Shows thumbnail, name, duration, difficulty, and location icon.
/// Includes accessibility features: semantic labels, minimum touch targets.
class ActivityCard extends StatelessWidget {
  final String name;
  final int durationMinutes;
  final ActivityDifficulty difficulty;
  final String location;
  final String? thumbnailUrl;
  final VoidCallback onTap;
  final bool isGridView;

  const ActivityCard({
    super.key,
    required this.name,
    required this.durationMinutes,
    required this.difficulty,
    required this.location,
    this.thumbnailUrl,
    required this.onTap,
    this.isGridView = false,
  });

  @override
  Widget build(BuildContext context) {
    final semanticLabel = AccessibilityUtils.getActivitySemanticLabel(
      name,
      durationMinutes,
      _getDifficultyLabel(),
      location,
    );

    return RepaintBoundary(
      child: Semantics(
        label: semanticLabel,
        button: true,
        onTap: onTap,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppDimensions.minTouchTarget,
              ),
              child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: AppDimensions.shadowBlurRadius,
                spreadRadius: AppDimensions.shadowSpreadRadius,
                offset: const Offset(0, AppDimensions.shadowOffsetY),
              ),
            ],
          ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExcludeSemantics(child: _buildThumbnail()),
                  Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacing12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ExcludeSemantics(
                          child: Text(
                            name,
                            style: AppTypography.headingSmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacing8),
                        ExcludeSemantics(child: _buildMetadata()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppDimensions.cardBorderRadius),
        topRight: Radius.circular(AppDimensions.cardBorderRadius),
      ),
      child: AspectRatio(
        aspectRatio: isGridView ? 1.0 : 16 / 9,
        child: thumbnailUrl != null && thumbnailUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: thumbnailUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.neutralGray,
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => _buildPlaceholder(),
                memCacheWidth: isGridView ? 400 : 800,
                maxWidthDiskCache: isGridView ? 400 : 800,
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.neutralGray,
      child: const Center(
        child: Icon(
          Icons.fitness_center,
          size: AppDimensions.iconSizeLarge,
          color: AppColors.mediumGray,
        ),
      ),
    );
  }

  Widget _buildMetadata() {
    return Row(
      children: [
        _buildMetadataItem(
          Icons.access_time,
          '$durationMinutes min',
        ),
        const SizedBox(width: AppDimensions.spacing12),
        _buildDifficultyIndicator(),
        const SizedBox(width: AppDimensions.spacing12),
        _buildMetadataItem(
          _getLocationIcon(),
          location,
        ),
      ],
    );
  }

  Widget _buildMetadataItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: AppDimensions.iconSizeSmall,
          color: AppColors.mediumGray,
        ),
        const SizedBox(width: AppDimensions.spacing4),
        Text(
          text,
          style: AppTypography.caption,
        ),
      ],
    );
  }

  Widget _buildDifficultyIndicator() {
    final color = _getDifficultyColor();
    final label = _getDifficultyLabel();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing8,
        vertical: AppDimensions.spacing4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getDifficultyColor() {
    switch (difficulty) {
      case ActivityDifficulty.low:
        return AppColors.difficultyLow;
      case ActivityDifficulty.medium:
        return AppColors.difficultyMedium;
      case ActivityDifficulty.high:
        return AppColors.difficultyHigh;
    }
  }

  String _getDifficultyLabel() {
    switch (difficulty) {
      case ActivityDifficulty.low:
        return 'Easy';
      case ActivityDifficulty.medium:
        return 'Medium';
      case ActivityDifficulty.high:
        return 'Hard';
    }
  }

  IconData _getLocationIcon() {
    final locationLower = location.toLowerCase();
    if (locationLower.contains('desk') || locationLower.contains('office')) {
      return Icons.desk;
    } else if (locationLower.contains('outdoor') || locationLower.contains('outside')) {
      return Icons.park;
    } else if (locationLower.contains('anywhere')) {
      return Icons.location_on;
    }
    return Icons.place;
  }
}

enum ActivityDifficulty {
  low,
  medium,
  high,
}
