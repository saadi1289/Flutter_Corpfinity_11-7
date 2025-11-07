import 'package:flutter/material.dart';
import 'enums.dart';

/// Helper class for LocationContext enum
class LocationContextHelper {
  /// Get display label for location context
  static String getLabel(LocationContext location) {
    return location.displayName;
  }

  /// Get icon for location context
  static IconData getIcon(LocationContext location) {
    switch (location) {
      case LocationContext.home:
        return Icons.home_outlined;
      case LocationContext.office:
        return Icons.business_outlined;
      case LocationContext.gym:
        return Icons.fitness_center_outlined;
      case LocationContext.outdoor:
        return Icons.park_outlined;
    }
  }
}

/// Helper class for EnergyLevel enum
class EnergyLevelHelper {
  /// Get display label for energy level
  static String getLabel(EnergyLevel energy) {
    return energy.displayName;
  }

  /// Get icon for energy level
  static IconData getIcon(EnergyLevel energy) {
    switch (energy) {
      case EnergyLevel.low:
        return Icons.battery_2_bar_outlined;
      case EnergyLevel.medium:
        return Icons.battery_5_bar_outlined;
      case EnergyLevel.high:
        return Icons.battery_full_outlined;
    }
  }

  /// Get color for energy level
  static Color getColor(EnergyLevel energy, BuildContext context) {
    // These colors should match AppColors from the theme
    switch (energy) {
      case EnergyLevel.low:
        return const Color(0xFFFF6B6B); // energyLow
      case EnergyLevel.medium:
        return const Color(0xFFFFA500); // energyMedium
      case EnergyLevel.high:
        return const Color(0xFF4CAF50); // energyHigh
    }
  }
}

/// Helper class for WellnessGoal enum
class WellnessGoalHelper {
  /// Get display label for wellness goal
  static String getLabel(WellnessGoal goal) {
    return goal.displayName;
  }

  /// Get icon for wellness goal
  static IconData getIcon(WellnessGoal goal) {
    switch (goal) {
      case WellnessGoal.stressReduction:
        return Icons.spa_outlined;
      case WellnessGoal.increasedEnergy:
        return Icons.bolt_outlined;
      case WellnessGoal.betterSleep:
        return Icons.bedtime_outlined;
      case WellnessGoal.physicalFitness:
        return Icons.directions_run_outlined;
      case WellnessGoal.healthyEating:
        return Icons.restaurant_outlined;
      case WellnessGoal.socialConnection:
        return Icons.people_outline;
    }
  }
}
