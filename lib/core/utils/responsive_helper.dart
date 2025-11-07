import 'package:flutter/material.dart';
import '../constants/dimensions.dart';

/// ResponsiveHelper provides utilities for responsive sizing based on screen width.
/// 
/// Breakpoints:
/// - Small: < 375px (e.g., iPhone SE)
/// - Medium: 375px - 414px (standard phones)
/// - Large: > 414px (large phones and tablets)
class ResponsiveHelper {
  /// Get the screen size category based on width
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < AppDimensions.breakpointMedium) {
      return ScreenSize.small;
    } else if (width < AppDimensions.breakpointLarge) {
      return ScreenSize.medium;
    } else {
      return ScreenSize.large;
    }
  }

  /// Get hero card height based on screen size
  static double getHeroCardHeight(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return 160.0;
      case ScreenSize.medium:
        return 180.0;
      case ScreenSize.large:
        return 200.0;
    }
  }

  /// Get avatar size based on screen size
  static double getAvatarSize(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return 56.0;
      case ScreenSize.medium:
        return 64.0;
      case ScreenSize.large:
        return 72.0;
    }
  }

  /// Check if screen is very small (< 375px)
  static bool isVerySmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < AppDimensions.breakpointMedium;
  }

  /// Check if screen is small (< 414px)
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < AppDimensions.breakpointLarge;
  }

  /// Get number of columns for grid based on screen size
  static int getGridColumns(BuildContext context) {
    return isVerySmallScreen(context) ? 1 : 2;
  }

  /// Get responsive padding based on screen size
  static double getScreenPadding(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return 12.0;
      case ScreenSize.medium:
        return AppDimensions.screenPaddingHorizontal;
      case ScreenSize.large:
        return 20.0;
    }
  }

  /// Get responsive spacing based on screen size
  static double getSpacing(BuildContext context, double baseSpacing) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return baseSpacing * 0.75; // 25% smaller on small screens
      case ScreenSize.medium:
        return baseSpacing;
      case ScreenSize.large:
        return baseSpacing * 1.25; // 25% larger on large screens
    }
  }

  /// Private constructor to prevent instantiation
  ResponsiveHelper._();
}

/// Screen size categories
enum ScreenSize {
  small,
  medium,
  large,
}
