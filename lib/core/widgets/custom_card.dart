import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/dimensions.dart';

/// CustomCard is a reusable card widget with 16px border radius and shadow.
/// Provides consistent styling across the app.
/// Includes accessibility features: minimum touch targets for interactive cards.
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final double? elevation;
  final Border? border;
  final String? semanticLabel;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.onTap,
    this.elevation,
    this.border,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        border: border,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: AppDimensions.shadowBlurRadius,
            spreadRadius: AppDimensions.shadowSpreadRadius,
            offset: const Offset(0, AppDimensions.shadowOffsetY),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppDimensions.cardPadding),
        child: child,
      ),
    );

    if (onTap != null) {
      return Semantics(
        label: semanticLabel,
        button: true,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppDimensions.minTouchTarget,
              ),
              child: cardContent,
            ),
          ),
        ),
      );
    }

    return cardContent;
  }
}
