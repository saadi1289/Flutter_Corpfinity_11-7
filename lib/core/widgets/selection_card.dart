import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/dimensions.dart';
import '../constants/typography.dart';

/// SelectionCard is a reusable card widget for multi-choice selection flows.
/// 
/// Features:
/// - Two styling modes controlled by [useOutlineIcon]:
///   - Outline mode (default): Icons with colored outline when unselected, filled when selected
///   - Legacy mode: Circular container with icon
/// - Unselected state: white background, outlined icon, dark text
/// - Selected state: white background, filled icon, colored border and shadow, dark text
/// - Scale animation (1.0 → 1.05) on selection with glow effect
/// - Minimum 44x44px touch target for accessibility
/// 
/// Used in challenge creation flow for energy, location, and goal selection.
class SelectionCard extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? accentColor;
  final double? iconSize;
  final bool useOutlineIcon;

  const SelectionCard({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.accentColor,
    this.iconSize,
    this.useOutlineIcon = true,
  });

  @override
  State<SelectionCard> createState() => _SelectionCardState();
}

class _SelectionCardState extends State<SelectionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void didUpdateWidget(SelectionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _animationController.forward();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveAccentColor = widget.accentColor ?? AppColors.calmBlue;

    return Semantics(
      label: '${widget.label} option. ${widget.isSelected ? "Selected" : "Not selected"}',
      button: true,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppDimensions.minTouchTarget,
                minWidth: AppDimensions.minTouchTarget,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  // Subtle gradient for elegant appearance
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.isSelected
                        ? [
                            AppColors.white,
                            (effectiveAccentColor).withOpacity(0.08),
                          ]
                        : [
                            AppColors.white,
                            AppColors.lightGray,
                          ],
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
                  border: Border.all(
                    color: widget.isSelected
                        ? effectiveAccentColor.withOpacity(0.7)
                        : AppColors.mediumGray.withOpacity(0.4),
                    width: widget.isSelected ? 2.5 : 1.0,
                  ),
                  boxShadow: widget.isSelected
                      ? [
                          BoxShadow(
                            color: effectiveAccentColor.withOpacity(0.20),
                            blurRadius: 16,
                            spreadRadius: 1,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : _defaultShadow,
                ),
                padding: const EdgeInsets.all(AppDimensions.spacing16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: _buildIcon(effectiveAccentColor),
                    ),
                    const SizedBox(height: AppDimensions.spacing8),
                    Flexible(
                      child: Text(
                        widget.label,
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.darkText,
                          fontWeight: widget.isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
  
  // Optimized shadow - reused to avoid recreation
  static final List<BoxShadow> _defaultShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: AppDimensions.shadowBlurRadius,
      spreadRadius: AppDimensions.shadowSpreadRadius,
      offset: const Offset(0, AppDimensions.shadowOffsetY),
    ),
  ];

  Widget _buildIcon(Color accentColor) {
    if (widget.useOutlineIcon) {
      // Outline/fill icon behavior
      // Unselected: colored outline with reduced opacity
      // Selected: filled with full accent color
      return Icon(
        widget.icon,
        size: widget.iconSize ?? AppDimensions.iconSizeXLarge,
        color: widget.isSelected 
          ? accentColor  // Filled with full color
          : accentColor.withOpacity(0.7),  // Outline effect with reduced opacity
      );
    } else {
      // Legacy behavior: circular container with icon
      return _buildLegacyIcon(accentColor);
    }
  }

  Widget _buildLegacyIcon(Color accentColor) {
    // Legacy icon rendering with circular container
    final effectiveIconSize = widget.iconSize ?? AppDimensions.iconSizeXLarge;
    final containerSize = effectiveIconSize + 8; // Add padding for container
    
    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        color: widget.isSelected ? accentColor : AppColors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.isSelected ? AppColors.white : AppColors.darkText,
          width: 2,
        ),
      ),
      child: Icon(
        widget.icon,
        size: effectiveIconSize * 0.7, // Icon size relative to container
        color: widget.isSelected ? AppColors.white : AppColors.darkText,
      ),
    );
  }
}
