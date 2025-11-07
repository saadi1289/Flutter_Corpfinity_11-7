import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';
import '../../../core/utils/animations.dart';
import '../../../data/models/wellness_pillar.dart';

/// WellnessPillarCard displays a wellness pillar with icon, name, description,
/// and available activities count in a grid layout
class WellnessPillarCard extends StatefulWidget {
  final WellnessPillar pillar;
  final VoidCallback onTap;
  final bool isSelected;

  const WellnessPillarCard({
    super.key,
    required this.pillar,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  State<WellnessPillarCard> createState() => _WellnessPillarCardState();
}

class _WellnessPillarCardState extends State<WellnessPillarCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Use standardized, subtle card tap animation
    _controller = AppAnimations.createCardTapController(this);
    _scaleAnimation = AppAnimations.createCardTapAnimation(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  Color _getIconColor() {
    switch (widget.pillar.id) {
      case 'stress-reduction':
        return AppColors.calmBlue;
      case 'increased-energy':
        return AppColors.warmOrange;
      case 'better-sleep':
        return AppColors.calmBlue;
      case 'physical-fitness':
        return AppColors.softGreen;
      case 'healthy-eating':
        return AppColors.softGreen;
      case 'social-connection':
        return AppColors.warmOrange;
      default:
        return AppColors.calmBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _getIconColor();
    
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
            border: Border.all(
              color: widget.isSelected ? iconColor : AppColors.neutralGray,
              width: widget.isSelected ? 3 : 1,
            ),
            boxShadow: widget.isSelected
              ? [
                  BoxShadow(
                    color: iconColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: AppDimensions.shadowBlurRadius,
                    spreadRadius: AppDimensions.shadowSpreadRadius,
                    offset: const Offset(0, AppDimensions.shadowOffsetY),
                  ),
                ],
          ),
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon and badge row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIcon(),
                  _buildActivityBadge(),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing12),
              
              // Pillar name
              Text(
                widget.pillar.name,
                style: AppTypography.headingMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              const SizedBox(height: AppDimensions.spacing4),
              
              // Pillar description
              Text(
                widget.pillar.description,
                style: AppTypography.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    // Map pillar IDs to icons
    IconData iconData;

    switch (widget.pillar.id) {
      case 'stress-reduction':
        iconData = Icons.spa_rounded;
        break;
      case 'increased-energy':
        iconData = Icons.bolt_rounded;
        break;
      case 'better-sleep':
        iconData = Icons.bedtime_rounded;
        break;
      case 'physical-fitness':
        iconData = Icons.fitness_center_rounded;
        break;
      case 'healthy-eating':
        iconData = Icons.restaurant_rounded;
        break;
      case 'social-connection':
        iconData = Icons.people_rounded;
        break;
      default:
        iconData = Icons.favorite_rounded;
    }

    final iconColor = _getIconColor();
    
    // Use outline icon when unselected, filled icon when selected
    return Icon(
      iconData,
      size: AppDimensions.iconSizeMedium,
      color: widget.isSelected 
        ? iconColor  // Filled with full color when selected
        : iconColor.withValues(alpha: 0.7),  // Outline effect when unselected
    );
  }

  Widget _buildActivityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing8,
        vertical: AppDimensions.spacing4,
      ),
      decoration: BoxDecoration(
        color: AppColors.calmBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: Text(
        '${widget.pillar.availableActivities}',
        style: AppTypography.captionBold.copyWith(
          color: AppColors.calmBlue,
        ),
      ),
    );
  }
}
