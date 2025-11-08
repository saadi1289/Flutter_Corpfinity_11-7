import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// AppLogo widget displays the Corpfinity logo throughout the app
/// 
/// Features:
/// - Configurable size (small, medium, large, custom)
/// - Optional white background for dark surfaces
/// - Fallback to icon if image asset is not found
/// - Maintains aspect ratio
class AppLogo extends StatelessWidget {
  final AppLogoSize size;
  final double? customSize;
  final bool showBackground;
  final Color? backgroundColor;

  const AppLogo({
    super.key,
    this.size = AppLogoSize.medium,
    this.customSize,
    this.showBackground = false,
    this.backgroundColor,
  });

  /// Small logo (40x40)
  const AppLogo.small({
    super.key,
    this.showBackground = false,
    this.backgroundColor,
  })  : size = AppLogoSize.small,
        customSize = null;

  /// Medium logo (80x80) - default
  const AppLogo.medium({
    super.key,
    this.showBackground = false,
    this.backgroundColor,
  })  : size = AppLogoSize.medium,
        customSize = null;

  /// Large logo (120x120)
  const AppLogo.large({
    super.key,
    this.showBackground = false,
    this.backgroundColor,
  })  : size = AppLogoSize.large,
        customSize = null;

  /// Extra large logo (160x160)
  const AppLogo.extraLarge({
    super.key,
    this.showBackground = false,
    this.backgroundColor,
  })  : size = AppLogoSize.extraLarge,
        customSize = null;

  /// Custom size logo
  const AppLogo.custom({
    super.key,
    required this.customSize,
    this.showBackground = false,
    this.backgroundColor,
  }) : size = AppLogoSize.custom;

  double get _logoSize {
    if (customSize != null) return customSize!;
    switch (size) {
      case AppLogoSize.small:
        return 40;
      case AppLogoSize.medium:
        return 80;
      case AppLogoSize.large:
        return 120;
      case AppLogoSize.extraLarge:
        return 160;
      case AppLogoSize.custom:
        return customSize ?? 80;
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      'assets/images/corpfinity_logo.png',
      width: _logoSize,
      height: _logoSize,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to icon if image not found
        return _buildFallbackLogo();
      },
    );

    if (showBackground) {
      return Container(
        width: _logoSize,
        height: _logoSize,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          borderRadius: BorderRadius.circular(_logoSize * 0.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: EdgeInsets.all(_logoSize * 0.15),
        child: logo,
      );
    }

    return logo;
  }

  Widget _buildFallbackLogo() {
    return Container(
      width: _logoSize,
      height: _logoSize,
      decoration: BoxDecoration(
        color: showBackground ? (backgroundColor ?? AppColors.white) : Colors.transparent,
        borderRadius: BorderRadius.circular(_logoSize * 0.2),
      ),
      child: Center(
        child: Icon(
          Icons.spa_outlined,
          size: _logoSize * 0.5,
          color: const Color(0xFF64dfdf),
        ),
      ),
    );
  }
}

enum AppLogoSize {
  small,
  medium,
  large,
  extraLarge,
  custom,
}
