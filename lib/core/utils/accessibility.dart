import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../constants/dimensions.dart';

/// Accessibility utility class for ensuring WCAG compliance and accessibility features.
class AccessibilityUtils {
  /// Minimum touch target size for accessibility (44x44 logical pixels)
  static const double minTouchTargetSize = AppDimensions.minTouchTarget;

  /// Ensure minimum touch target size
  static Size ensureMinTouchTarget(Size size) {
    return Size(
      size.width < minTouchTargetSize ? minTouchTargetSize : size.width,
      size.height < minTouchTargetSize ? minTouchTargetSize : size.height,
    );
  }

  /// Wrap widget with minimum touch target constraints
  static Widget withMinTouchTarget(Widget child) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: minTouchTargetSize,
        minHeight: minTouchTargetSize,
      ),
      child: child,
    );
  }

  /// Create semantic label for energy level
  static String getEnergyLevelSemanticLabel(String level, bool isSelected) {
    return '$level energy level${isSelected ? ', selected' : ''}. Double tap to select.';
  }

  /// Create semantic label for wellness pillar
  static String getWellnessPillarSemanticLabel(
    String name,
    String description,
    int availableActivities,
  ) {
    return '$name. $description. $availableActivities activities available. Double tap to view activities.';
  }

  /// Create semantic label for activity card
  static String getActivitySemanticLabel(
    String name,
    int duration,
    String difficulty,
    String location,
  ) {
    return '$name. Duration: $duration minutes. Difficulty: $difficulty. Location: $location. Double tap to start activity.';
  }

  /// Create semantic label for progress indicator
  static String getProgressSemanticLabel(double progress, String context) {
    final percentage = (progress * 100).toInt();
    return '$context progress: $percentage percent complete';
  }

  /// Create semantic label for badge
  static String getBadgeSemanticLabel(String name, bool isUnlocked) {
    return '$name badge${isUnlocked ? ', earned' : ', locked'}';
  }

  /// Create semantic label for button with loading state
  static String getButtonSemanticLabel(String text, bool isLoading) {
    return isLoading ? '$text, loading' : text;
  }

  /// Check if color contrast ratio meets WCAG AA standard (4.5:1)
  static bool meetsContrastRatio(Color foreground, Color background) {
    final ratio = calculateContrastRatio(foreground, background);
    return ratio >= 4.5;
  }

  /// Calculate contrast ratio between two colors
  static double calculateContrastRatio(Color color1, Color color2) {
    final luminance1 = _calculateRelativeLuminance(color1);
    final luminance2 = _calculateRelativeLuminance(color2);
    
    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;
    
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Calculate relative luminance of a color
  static double _calculateRelativeLuminance(Color color) {
    final r = _linearizeColorComponent(color.r * 255.0);
    final g = _linearizeColorComponent(color.g * 255.0);
    final b = _linearizeColorComponent(color.b * 255.0);
    
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Linearize color component for luminance calculation
  static double _linearizeColorComponent(double component) {
    final normalized = component / 255.0;
    if (normalized <= 0.03928) {
      return normalized / 12.92;
    }
    return _pow((normalized + 0.055) / 1.055, 2.4);
  }

  /// Power function helper
  static double _pow(double base, double exponent) {
    return math.pow(base, exponent).toDouble();
  }

  /// Create semantic hint for interactive elements
  static String getInteractionHint(String action) {
    return 'Double tap to $action';
  }

  /// Announce message to screen readers
  static Future<void> announceToScreenReader(BuildContext context, String message) async {
    // Use SemanticsService from Flutter services
    // ignore: deprecated_member_use
    await SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Check if screen reader is enabled
  static bool isScreenReaderEnabled(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }

  /// Get appropriate text scale factor (clamped for readability)
  static double getClampedTextScaleFactor(BuildContext context) {
    // ignore: deprecated_member_use
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    // Clamp between 0.8 and 2.0 for optimal readability
    return textScaleFactor.clamp(0.8, 2.0);
  }
}
