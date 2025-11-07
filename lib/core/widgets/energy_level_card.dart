import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/dimensions.dart';
import '../constants/typography.dart';
import '../utils/animations.dart';
import '../utils/accessibility.dart';

/// EnergyLevelCard displays an energy level option with color coding and tap animation.
/// Used on the home screen for energy level selection.
/// Includes accessibility features: semantic labels, minimum touch targets.
class EnergyLevelCard extends StatefulWidget {
  final EnergyLevel energyLevel;
  final bool isSelected;
  final VoidCallback onTap;

  const EnergyLevelCard({
    super.key,
    required this.energyLevel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<EnergyLevelCard> createState() => _EnergyLevelCardState();
}

class _EnergyLevelCardState extends State<EnergyLevelCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
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
    widget.onTap();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final color = _getEnergyColor();
    final label = _getEnergyLabel();
    final description = _getEnergyDescription();
    final semanticLabel = AccessibilityUtils.getEnergyLevelSemanticLabel(
      label,
      widget.isSelected,
    );

    return Semantics(
      label: semanticLabel,
      button: true,
      selected: widget.isSelected,
      onTap: widget.onTap,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppDimensions.minTouchTarget,
            ),
            child: Container(
          decoration: BoxDecoration(
            color: widget.isSelected ? color.withOpacity(0.15) : AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
            border: Border.all(
              color: widget.isSelected ? color : color.withOpacity(0.3),
              width: widget.isSelected ? 2.5 : 1.5,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: AppDimensions.shadowBlurRadius,
                      spreadRadius: AppDimensions.shadowSpreadRadius,
                      offset: const Offset(0, AppDimensions.shadowOffsetY),
                    ),
                  ],
          ),
              padding: const EdgeInsets.all(AppDimensions.spacing20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      ExcludeSemantics(
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                          ),
                          child: Icon(
                            _getEnergyIcon(),
                            color: color,
                            size: AppDimensions.iconSizeMedium,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacing12),
                      Expanded(
                        child: ExcludeSemantics(
                          child: Text(
                            label,
                            style: AppTypography.headingMedium.copyWith(
                              color: widget.isSelected ? color : AppColors.darkText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing12),
                  ExcludeSemantics(
                    child: Text(
                      description,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.mediumGray,
                      ),
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

  Color _getEnergyColor() {
    switch (widget.energyLevel) {
      case EnergyLevel.low:
        return AppColors.energyLow;
      case EnergyLevel.medium:
        return AppColors.energyMedium;
      case EnergyLevel.high:
        return AppColors.energyHigh;
    }
  }

  String _getEnergyLabel() {
    switch (widget.energyLevel) {
      case EnergyLevel.low:
        return 'Low Energy';
      case EnergyLevel.medium:
        return 'Medium Energy';
      case EnergyLevel.high:
        return 'High Energy';
    }
  }

  String _getEnergyDescription() {
    switch (widget.energyLevel) {
      case EnergyLevel.low:
        return 'Gentle activities to recharge';
      case EnergyLevel.medium:
        return 'Balanced activities for focus';
      case EnergyLevel.high:
        return 'Active exercises to energize';
    }
  }

  IconData _getEnergyIcon() {
    switch (widget.energyLevel) {
      case EnergyLevel.low:
        return Icons.battery_2_bar_rounded;
      case EnergyLevel.medium:
        return Icons.battery_5_bar_rounded;
      case EnergyLevel.high:
        return Icons.battery_full_rounded;
    }
  }
}

enum EnergyLevel {
  low,
  medium,
  high,
}
