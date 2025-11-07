import 'package:flutter/material.dart';
import 'accessibility.dart';
import '../constants/dimensions.dart';

/// AccessibilityTester provides utilities for testing accessibility compliance
/// during development and testing.
class AccessibilityTester {
  /// Check if a widget meets minimum touch target size
  static bool meetsMinTouchTarget(Size size) {
    return size.width >= AccessibilityUtils.minTouchTargetSize &&
        size.height >= AccessibilityUtils.minTouchTargetSize;
  }

  /// Validate that all interactive elements have semantic labels
  static List<String> findMissingSemanticLabels(BuildContext context) {
    final issues = <String>[];
    // This would require traversing the widget tree
    // Implementation would be done in actual testing
    return issues;
  }

  /// Test color contrast for common UI elements
  static Map<String, ContrastTestResult> testCommonContrasts() {
    final results = <String, ContrastTestResult>{};

    // Add test cases for common color combinations
    results['Primary button'] = ContrastTestResult(
      foreground: Colors.white,
      background: const Color(0xFF4A90E2),
      ratio: AccessibilityUtils.calculateContrastRatio(
        Colors.white,
        const Color(0xFF4A90E2),
      ),
    );

    return results;
  }

  /// Generate accessibility report
  static AccessibilityReport generateReport(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return AccessibilityReport(
      screenSize: mediaQuery.size,
      textScaleFactor: mediaQuery.textScaleFactor,
      accessibleNavigation: mediaQuery.accessibleNavigation,
      boldText: mediaQuery.boldText,
      highContrast: mediaQuery.highContrast,
      disableAnimations: mediaQuery.disableAnimations,
      invertColors: mediaQuery.invertColors,
    );
  }

  /// Check if text is readable at current scale
  static bool isTextReadable(double fontSize, double textScaleFactor) {
    final scaledSize = fontSize * textScaleFactor;
    // Minimum readable size is typically 12px
    return scaledSize >= 12.0;
  }

  /// Validate spacing meets touch target requirements
  static bool hasAdequateSpacing(double spacing) {
    // Minimum spacing between interactive elements should be at least 8px
    return spacing >= 8.0;
  }
}

/// Result of a contrast test
class ContrastTestResult {
  final Color foreground;
  final Color background;
  final double ratio;

  ContrastTestResult({
    required this.foreground,
    required this.background,
    required this.ratio,
  });

  bool get meetsWCAGAA => ratio >= 4.5;
  bool get meetsWCAGAAA => ratio >= 7.0;

  @override
  String toString() {
    return 'Contrast: ${ratio.toStringAsFixed(2)}:1 '
        '(AA: ${meetsWCAGAA ? "✓" : "✗"}, AAA: ${meetsWCAGAAA ? "✓" : "✗"})';
  }
}

/// Comprehensive accessibility report
class AccessibilityReport {
  final Size screenSize;
  final double textScaleFactor;
  final bool accessibleNavigation;
  final bool boldText;
  final bool highContrast;
  final bool disableAnimations;
  final bool invertColors;

  AccessibilityReport({
    required this.screenSize,
    required this.textScaleFactor,
    required this.accessibleNavigation,
    required this.boldText,
    required this.highContrast,
    required this.disableAnimations,
    required this.invertColors,
  });

  // ignore: deprecated_member_use

  bool get isSmallScreen => screenSize.width < AppDimensions.breakpointMedium;
  bool get isTablet => screenSize.width >= AppDimensions.breakpointTablet;
  bool get hasLargeText => textScaleFactor > 1.3;
  bool get hasAccessibilityFeatures =>
      accessibleNavigation || boldText || highContrast || invertColors;

  @override
  String toString() {
    return '''
Accessibility Report:
- Screen Size: ${screenSize.width.toInt()}x${screenSize.height.toInt()}
- Text Scale Factor: ${textScaleFactor.toStringAsFixed(2)}
- Screen Reader: ${accessibleNavigation ? "Enabled" : "Disabled"}
- Bold Text: ${boldText ? "Enabled" : "Disabled"}
- High Contrast: ${highContrast ? "Enabled" : "Disabled"}
- Reduce Motion: ${disableAnimations ? "Enabled" : "Disabled"}
- Invert Colors: ${invertColors ? "Enabled" : "Disabled"}
- Device Type: ${isTablet ? "Tablet" : (isSmallScreen ? "Small Phone" : "Phone")}
''';
  }
}
