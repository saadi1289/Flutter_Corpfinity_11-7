import 'package:flutter/material.dart';
import '../constants/dimensions.dart';

/// Responsive utility class for handling different screen sizes and orientations.
/// Provides methods for responsive sizing and layout adjustments.
class Responsive {
  final BuildContext context;
  final MediaQueryData _mediaQuery;

  Responsive(this.context) : _mediaQuery = MediaQuery.of(context);

  /// Get screen width
  double get width => _mediaQuery.size.width;

  /// Get screen height
  double get height => _mediaQuery.size.height;

  /// Get text scale factor
  // ignore: deprecated_member_use
  double get textScaleFactor => _mediaQuery.textScaleFactor;

  /// Check if device is in portrait mode
  bool get isPortrait => _mediaQuery.orientation == Orientation.portrait;

  /// Check if device is in landscape mode
  bool get isLandscape => _mediaQuery.orientation == Orientation.landscape;

  /// Check if screen is small (< 375px)
  bool get isSmallScreen => width < AppDimensions.breakpointMedium;

  /// Check if screen is medium (375px - 414px)
  bool get isMediumScreen =>
      width >= AppDimensions.breakpointMedium && width < AppDimensions.breakpointLarge;

  /// Check if screen is large (414px - 768px)
  bool get isLargeScreen =>
      width >= AppDimensions.breakpointLarge && width < AppDimensions.breakpointTablet;

  /// Check if device is tablet (>= 768px)
  bool get isTablet => width >= AppDimensions.breakpointTablet;

  /// Get responsive value based on screen size
  T getResponsiveValue<T>({
    required T small,
    T? medium,
    T? large,
    T? tablet,
  }) {
    if (isTablet && tablet != null) return tablet;
    if (isLargeScreen && large != null) return large;
    if (isMediumScreen && medium != null) return medium;
    return small;
  }

  /// Get responsive spacing
  double getResponsiveSpacing(double baseSpacing) {
    if (isSmallScreen) return baseSpacing * 0.85;
    if (isTablet) return baseSpacing * 1.2;
    return baseSpacing;
  }

  /// Get responsive font size
  double getResponsiveFontSize(double baseFontSize) {
    // Account for user's text scale factor
    final scaledSize = baseFontSize * textScaleFactor;
    
    // Apply screen size adjustments
    if (isSmallScreen) return scaledSize * 0.95;
    if (isTablet) return scaledSize * 1.1;
    return scaledSize;
  }

  /// Get number of grid columns based on screen size
  int getGridColumns({int defaultColumns = 2}) {
    if (isTablet) return defaultColumns + 1;
    if (isSmallScreen && defaultColumns > 1) return defaultColumns - 1;
    return defaultColumns;
  }

  /// Get responsive padding
  EdgeInsets getResponsivePadding({
    double horizontal = AppDimensions.screenPaddingHorizontal,
    double vertical = AppDimensions.screenPaddingVertical,
  }) {
    return EdgeInsets.symmetric(
      horizontal: getResponsiveSpacing(horizontal),
      vertical: getResponsiveSpacing(vertical),
    );
  }

  /// Get safe area padding
  EdgeInsets get safeAreaPadding => _mediaQuery.padding;

  /// Get view insets (keyboard height, etc.)
  EdgeInsets get viewInsets => _mediaQuery.viewInsets;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => viewInsets.bottom > 0;
}

/// Extension on BuildContext for easy access to Responsive utilities
extension ResponsiveContext on BuildContext {
  Responsive get responsive => Responsive(this);
}
