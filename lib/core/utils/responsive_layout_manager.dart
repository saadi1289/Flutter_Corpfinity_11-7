import 'package:flutter/material.dart';
import '../constants/dimensions.dart';

/// ResponsiveLayoutManager determines layout configuration based on screen size
/// and provides responsive sizing utilities for the homescreen redesign.
/// 
/// Breakpoints:
/// - < 600px: Mobile (1 column)
/// - 600-1200px: Tablet (2 columns)
/// - > 1200px: Desktop (3 columns, max 600px content width)
/// 
/// Usage:
/// ```dart
/// final layoutManager = ResponsiveLayoutManager(context);
/// 
/// // Get number of grid columns
/// final columns = layoutManager.gridColumns;
/// 
/// // Get hero section height
/// final heroHeight = layoutManager.heroSectionHeight;
/// 
/// // Get responsive text style
/// final textStyle = layoutManager.getResponsiveTextStyle(baseStyle);
/// ```
class ResponsiveLayoutManager {
  final BuildContext context;
  final MediaQueryData _mediaQuery;
  
  // Breakpoints for responsive design
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1200.0;
  
  // Content constraints
  static const double maxContentWidth = 600.0;
  
  // Hero section height as percentage of viewport
  static const double heroHeightMobilePercent = 0.35;
  static const double heroHeightTabletPercent = 0.30;
  
  // Font size constraints
  static const double minBodyFontSize = 14.0;
  static const double maxBodyFontSize = 24.0;
  
  ResponsiveLayoutManager(this.context) 
      : _mediaQuery = MediaQuery.of(context);
  
  /// Get screen width
  double get screenWidth => _mediaQuery.size.width;
  
  /// Get screen height
  double get screenHeight => _mediaQuery.size.height;
  
  /// Check if device is mobile (< 600px)
  bool get isMobile => screenWidth < mobileBreakpoint;
  
  /// Check if device is tablet (600-1200px)
  bool get isTablet => screenWidth >= mobileBreakpoint && 
                       screenWidth < tabletBreakpoint;
  
  /// Check if device is desktop (> 1200px)
  bool get isDesktop => screenWidth >= tabletBreakpoint;
  
  /// Get number of grid columns based on screen width
  /// Returns: 1 (mobile), 2 (tablet), or 3 (desktop)
  int get gridColumns {
    if (isMobile) return 1;
    if (isTablet) return 2;
    return 3;
  }
  
  /// Get hero section height (30-40% of viewport)
  /// Returns height in pixels
  double get heroSectionHeight {
    final heightPercent = isMobile 
        ? heroHeightMobilePercent 
        : heroHeightTabletPercent;
    return screenHeight * heightPercent;
  }
  
  /// Get maximum content width for centered layouts
  /// Returns actual width or maxContentWidth, whichever is smaller
  double get contentMaxWidth {
    if (isMobile) return screenWidth;
    return screenWidth > maxContentWidth ? maxContentWidth : screenWidth;
  }
  
  /// Get responsive text style with adjusted font size
  /// Font sizes are adjusted based on screen size (14-24px range)
  TextStyle getResponsiveTextStyle(TextStyle baseStyle) {
    final baseFontSize = baseStyle.fontSize ?? 16.0;
    double adjustedSize = baseFontSize;
    
    // Apply screen size adjustments
    if (isMobile) {
      adjustedSize = baseFontSize; // Base size for mobile
    } else if (isTablet) {
      adjustedSize = baseFontSize + 2.0; // +2px for tablet
    } else {
      adjustedSize = baseFontSize + 4.0; // +4px for desktop
    }
    
    // Clamp to min/max constraints for body text
    if (baseStyle.fontSize != null && baseStyle.fontSize! <= 18.0) {
      adjustedSize = adjustedSize.clamp(minBodyFontSize, maxBodyFontSize);
    }
    
    return baseStyle.copyWith(fontSize: adjustedSize);
  }
  
  /// Get responsive spacing based on screen size
  /// Returns spacing adjusted for current screen size
  double getResponsiveSpacing(double baseSpacing) {
    if (isMobile) return baseSpacing;
    if (isTablet) return baseSpacing * 1.1;
    return baseSpacing * 1.2;
  }
  
  /// Get responsive padding for screen edges
  EdgeInsets get screenPadding {
    final horizontal = isMobile 
        ? AppDimensions.screenPaddingHorizontal 
        : getResponsiveSpacing(AppDimensions.screenPaddingHorizontal);
    
    return EdgeInsets.symmetric(
      horizontal: horizontal,
      vertical: AppDimensions.screenPaddingVertical,
    );
  }
  
  /// Get grid spacing (cross-axis and main-axis)
  double get gridSpacing => AppDimensions.gridSpacing;
  
  /// Get cross-axis spacing for grids
  double get gridCrossAxisSpacing => AppDimensions.gridCrossAxisSpacing;
  
  /// Get main-axis spacing for grids
  double get gridMainAxisSpacing => AppDimensions.gridMainAxisSpacing;
  
  /// Check if orientation changed and needs reflow
  /// Reflow should complete within 300ms as per requirements
  bool get isPortrait => _mediaQuery.orientation == Orientation.portrait;
  
  /// Check if orientation is landscape
  bool get isLandscape => _mediaQuery.orientation == Orientation.landscape;
  
  /// Get avatar size based on screen size
  double get avatarSize {
    if (isMobile) return 64.0;
    return 80.0; // Larger for tablet and desktop
  }
  
  /// Get card minimum height
  double get cardMinHeight => 120.0;
  
  /// Get navigation item size (48x48 points for accessibility)
  double get navigationItemSize => 48.0;
  
  /// Get minimum touch target size (44x44 points per WCAG)
  double get minTouchTargetSize => AppDimensions.minTouchTarget;
  
  /// Get spacing between touch targets (8px minimum)
  double get touchTargetSpacing => AppDimensions.spacing8;
}

/// Extension on BuildContext for easy access to ResponsiveLayoutManager
extension ResponsiveLayoutContext on BuildContext {
  ResponsiveLayoutManager get layout => ResponsiveLayoutManager(this);
}
