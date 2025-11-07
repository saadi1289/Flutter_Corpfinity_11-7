import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/dimensions.dart';
import '../constants/typography.dart';
import '../utils/accessibility.dart';

/// CustomButton is a reusable button widget with primary and secondary variants.
/// Supports 12px border radius as per design specifications.
/// Includes accessibility features: semantic labels, minimum touch targets.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final Widget? icon;
  final String? semanticLabel;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;
    final effectiveSemanticLabel = semanticLabel ?? 
        AccessibilityUtils.getButtonSemanticLabel(text, isLoading);

    return Semantics(
      label: effectiveSemanticLabel,
      button: true,
      enabled: isEnabled,
      child: SizedBox(
        height: _getHeight(),
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _getBackgroundColor(),
            foregroundColor: _getForegroundColor(),
            disabledBackgroundColor: AppColors.neutralGray,
            disabledForegroundColor: AppColors.mediumGray,
            elevation: variant == ButtonVariant.primary ? 2 : 0,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
              side: variant == ButtonVariant.secondary
                  ? BorderSide(color: _getBorderColor(), width: 1.5)
                  : BorderSide.none,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(),
              vertical: AppDimensions.spacing12,
            ),
          ),
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(_getForegroundColor()),
                  ),
                )
              : _buildButtonContent(),
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ExcludeSemantics(child: icon!),
          const SizedBox(width: AppDimensions.spacing8),
          Text(text, style: _getTextStyle()),
        ],
      );
    }
    return Text(text, style: _getTextStyle());
  }

  double _getHeight() {
    // Ensure minimum touch target size for accessibility
    double baseHeight;
    switch (size) {
      case ButtonSize.small:
        baseHeight = AppDimensions.buttonHeightSmall;
        break;
      case ButtonSize.medium:
        baseHeight = AppDimensions.buttonHeight;
        break;
      case ButtonSize.large:
        baseHeight = AppDimensions.buttonHeightLarge;
        break;
    }
    return baseHeight < AppDimensions.minTouchTarget 
        ? AppDimensions.minTouchTarget 
        : baseHeight;
  }

  double _getHorizontalPadding() {
    switch (size) {
      case ButtonSize.small:
        return AppDimensions.spacing16;
      case ButtonSize.medium:
        return AppDimensions.spacing24;
      case ButtonSize.large:
        return AppDimensions.spacing32;
    }
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case ButtonVariant.primary:
        return AppColors.calmBlue;
      case ButtonVariant.secondary:
        return AppColors.white;
    }
  }

  Color _getForegroundColor() {
    switch (variant) {
      case ButtonVariant.primary:
        return AppColors.white;
      case ButtonVariant.secondary:
        return AppColors.calmBlue;
    }
  }

  Color _getBorderColor() {
    return AppColors.calmBlue;
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return AppTypography.buttonSmall.copyWith(color: _getForegroundColor());
      case ButtonSize.medium:
        return AppTypography.buttonMedium.copyWith(color: _getForegroundColor());
      case ButtonSize.large:
        return AppTypography.buttonLarge.copyWith(color: _getForegroundColor());
    }
  }
}

enum ButtonVariant {
  primary,
  secondary,
}

enum ButtonSize {
  small,
  medium,
  large,
}
