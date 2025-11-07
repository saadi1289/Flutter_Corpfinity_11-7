import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/dimensions.dart';
import '../constants/typography.dart';
import '../utils/accessibility.dart';

/// WellnessPillarCard displays a wellness pillar option in a grid layout.
/// Shows icon, name, description, and available activities count.
/// Includes accessibility features: semantic labels, minimum touch targets.
class WellnessPillarCard extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;
  final int availableActivities;
  final VoidCallback onTap;
  final Color? accentColor;

  const WellnessPillarCard({
    super.key,
    required this.name,
    required this.description,
    required this.icon,
    required this.availableActivities,
    required this.onTap,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.calmBlue;
    final semanticLabel = AccessibilityUtils.getWellnessPillarSemanticLabel(
      name,
      description,
      availableActivities,
    );

    return Semantics(
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
            border: Border.all(
              color: AppColors.neutralGray,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: AppDimensions.shadowBlurRadius,
                spreadRadius: AppDimensions.shadowSpreadRadius,
                offset: const Offset(0, AppDimensions.shadowOffsetY),
              ),
            ],
          ),
              padding: const EdgeInsets.all(AppDimensions.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ExcludeSemantics(
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                          ),
                          child: Icon(
                            icon,
                            color: color,
                            size: AppDimensions.iconSizeMedium,
                          ),
                        ),
                      ),
                      if (availableActivities > 0)
                        ExcludeSemantics(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.spacing8,
                              vertical: AppDimensions.spacing4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                            ),
                            child: Text(
                              '$availableActivities',
                              style: AppTypography.captionBold.copyWith(
                                color: color,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing12),
                  ExcludeSemantics(
                    child: Text(
                      name,
                      style: AppTypography.headingMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing4),
                  ExcludeSemantics(
                    child: Text(
                      description,
                      style: AppTypography.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
