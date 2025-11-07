import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'accessibility.dart';

/// ColorContrastValidator validates that all color combinations in the app
/// meet WCAG AA accessibility standards (4.5:1 contrast ratio).
class ColorContrastValidator {
  /// Validate all primary color combinations used in the app
  static Map<String, bool> validateAppColors() {
    final results = <String, bool>{};

    // Primary text on backgrounds
    results['Dark text on white'] = AccessibilityUtils.meetsContrastRatio(
      AppColors.darkText,
      AppColors.white,
    );

    results['Dark text on light gray'] = AccessibilityUtils.meetsContrastRatio(
      AppColors.darkText,
      AppColors.lightGray,
    );

    results['Dark text on neutral gray'] = AccessibilityUtils.meetsContrastRatio(
      AppColors.darkText,
      AppColors.neutralGray,
    );

    results['Medium gray on white'] = AccessibilityUtils.meetsContrastRatio(
      AppColors.mediumGray,
      AppColors.white,
    );

    // Button text combinations
    results['White text on calm blue'] = AccessibilityUtils.meetsContrastRatio(
      AppColors.white,
      AppColors.calmBlue,
    );

    results['White text on soft green'] = AccessibilityUtils.meetsContrastRatio(
      AppColors.white,
      AppColors.softGreen,
    );

    results['White text on warm orange'] = AccessibilityUtils.meetsContrastRatio(
      AppColors.white,
      AppColors.warmOrange,
    );

    results['White text on gentle red'] = AccessibilityUtils.meetsContrastRatio(
      AppColors.white,
      AppColors.gentleRed,
    );

    // Secondary button combinations
    results['Calm blue text on white'] = AccessibilityUtils.meetsContrastRatio(
      AppColors.calmBlue,
      AppColors.white,
    );

    // Energy level combinations
    results['Gentle red on white'] = AccessibilityUtils.meetsContrastRatio(
      AppColors.gentleRed,
      AppColors.white,
    );

    results['Warm orange on white'] = AccessibilityUtils.meetsContrastRatio(
      AppColors.warmOrange,
      AppColors.white,
    );

    results['Soft green on white'] = AccessibilityUtils.meetsContrastRatio(
      AppColors.softGreen,
      AppColors.white,
    );

    return results;
  }

  /// Get detailed contrast ratio for a color combination
  static double getContrastRatio(Color foreground, Color background) {
    return AccessibilityUtils.calculateContrastRatio(foreground, background);
  }

  /// Print validation results to console (for development)
  static void printValidationResults() {
    final results = validateAppColors();
    print('\n=== Color Contrast Validation Results ===\n');

    results.forEach((combination, passes) {
      final ratio = getContrastRatio(
        _getColorFromCombination(combination, true),
        _getColorFromCombination(combination, false),
      );
      final status = passes ? '✓ PASS' : '✗ FAIL';
      print('$status - $combination: ${ratio.toStringAsFixed(2)}:1');
    });

    final totalTests = results.length;
    final passedTests = results.values.where((v) => v).length;
    print('\n$passedTests/$totalTests tests passed\n');
  }

  /// Helper to extract colors from combination string (simplified)
  static Color _getColorFromCombination(String combination, bool isForeground) {
    // This is a simplified helper - in production, you'd parse the string properly
    if (combination.contains('Dark text')) {
      return isForeground ? AppColors.darkText : AppColors.white;
    }
    if (combination.contains('Medium gray')) {
      return isForeground ? AppColors.mediumGray : AppColors.white;
    }
    if (combination.contains('White text on calm blue')) {
      return isForeground ? AppColors.white : AppColors.calmBlue;
    }
    if (combination.contains('White text on soft green')) {
      return isForeground ? AppColors.white : AppColors.softGreen;
    }
    if (combination.contains('White text on warm orange')) {
      return isForeground ? AppColors.white : AppColors.warmOrange;
    }
    if (combination.contains('White text on gentle red')) {
      return isForeground ? AppColors.white : AppColors.gentleRed;
    }
    if (combination.contains('Calm blue text')) {
      return isForeground ? AppColors.calmBlue : AppColors.white;
    }
    return AppColors.white;
  }
}
