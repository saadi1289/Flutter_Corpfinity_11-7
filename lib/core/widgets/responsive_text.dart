import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../utils/accessibility.dart';

/// ResponsiveText is a text widget that automatically adjusts font size
/// based on screen size and respects user's text scale preferences.
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;
  final String? semanticLabel;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final textScaleFactor = AccessibilityUtils.getClampedTextScaleFactor(context);

    // Apply responsive font size adjustments
    TextStyle? effectiveStyle = style;
    if (effectiveStyle != null && effectiveStyle.fontSize != null) {
      final baseFontSize = effectiveStyle.fontSize!;
      final responsiveFontSize = _getResponsiveFontSize(
        baseFontSize,
        responsive,
      );

      effectiveStyle = effectiveStyle.copyWith(
        fontSize: responsiveFontSize,
      );
    }

    return Text(
      text,
      style: effectiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      semanticsLabel: semanticLabel,
      // Use MediaQuery.textScaleFactorOf to respect user preferences
      // ignore: deprecated_member_use
      textScaleFactor: textScaleFactor,
    );
  }

  double _getResponsiveFontSize(double baseFontSize, Responsive responsive) {
    if (responsive.isSmallScreen) {
      return baseFontSize * 0.95;
    } else if (responsive.isTablet) {
      return baseFontSize * 1.1;
    }
    return baseFontSize;
  }
}
