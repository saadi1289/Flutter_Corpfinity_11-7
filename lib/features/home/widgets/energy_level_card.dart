import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';
import '../providers/home_provider.dart';

/// EnergyLevelCard displays a selectable card for energy level selection
/// with distinct colors for Low, Medium, and High energy levels
class EnergyLevelCard extends StatefulWidget {
  final EnergyLevel energyLevel;
  final VoidCallback onTap;
  final bool isSelected;

  const EnergyLevelCard({
    super.key,
    required this.energyLevel,
    required this.onTap,
    this.isSelected = false,
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
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getCardColor() {
    switch (widget.energyLevel) {
      case EnergyLevel.low:
        return AppColors.energyLow;
      case EnergyLevel.medium:
        return AppColors.energyMedium;
      case EnergyLevel.high:
        return AppColors.energyHigh;
    }
  }

  IconData _getIcon() {
    switch (widget.energyLevel) {
      case EnergyLevel.low:
        return Icons.battery_2_bar_rounded;
      case EnergyLevel.medium:
        return Icons.battery_5_bar_rounded;
      case EnergyLevel.high:
        return Icons.battery_full_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = _getCardColor();

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: cardColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
            border: Border.all(
              color: widget.isSelected ? cardColor : cardColor.withValues(alpha: 0.3),
              width: widget.isSelected ? 2.5 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: cardColor.withValues(alpha: 0.15),
                blurRadius: AppDimensions.shadowBlurRadius,
                spreadRadius: AppDimensions.shadowSpreadRadius,
                offset: const Offset(0, AppDimensions.shadowOffsetY),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spacing12),
                  decoration: BoxDecoration(
                    color: cardColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIcon(),
                    size: AppDimensions.iconSizeLarge,
                    color: cardColor,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing12),
                
                // Title
                Text(
                  widget.energyLevel.displayName,
                  style: AppTypography.headingMedium.copyWith(
                    color: cardColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacing4),
                
                // Description
                Text(
                  widget.energyLevel.description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.mediumGray,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
