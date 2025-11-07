import 'package:hive/hive.dart';

part 'enums.g.dart';

/// Energy level options for activity recommendations
@HiveType(typeId: 7)
enum EnergyLevel {
  @HiveField(0)
  low,
  
  @HiveField(1)
  medium,
  
  @HiveField(2)
  high;

  String get displayName {
    switch (this) {
      case EnergyLevel.low:
        return 'Low';
      case EnergyLevel.medium:
        return 'Medium';
      case EnergyLevel.high:
        return 'High';
    }
  }
}

/// Activity difficulty levels
@HiveType(typeId: 8)
enum Difficulty {
  @HiveField(0)
  low,
  
  @HiveField(1)
  medium,
  
  @HiveField(2)
  high;

  String get displayName {
    switch (this) {
      case Difficulty.low:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.high:
        return 'Hard';
    }
  }
}

/// Single Sign-On provider options
@HiveType(typeId: 9)
enum SSOProvider {
  @HiveField(0)
  google,
  
  @HiveField(1)
  microsoft;

  String get displayName {
    switch (this) {
      case SSOProvider.google:
        return 'Google';
      case SSOProvider.microsoft:
        return 'Microsoft';
    }
  }
}

/// Location context for challenge creation
@HiveType(typeId: 10)
enum LocationContext {
  @HiveField(0)
  home,
  
  @HiveField(1)
  office,
  
  @HiveField(2)
  gym,
  
  @HiveField(3)
  outdoor;

  String get displayName {
    switch (this) {
      case LocationContext.home:
        return 'Home';
      case LocationContext.office:
        return 'Office';
      case LocationContext.gym:
        return 'Gym';
      case LocationContext.outdoor:
        return 'Outdoor';
    }
  }
}

/// Wellness goal focus areas for challenge creation
@HiveType(typeId: 11)
enum WellnessGoal {
  @HiveField(0)
  stressReduction,
  
  @HiveField(1)
  increasedEnergy,
  
  @HiveField(2)
  betterSleep,
  
  @HiveField(3)
  physicalFitness,
  
  @HiveField(4)
  healthyEating,
  
  @HiveField(5)
  socialConnection;

  String get displayName {
    switch (this) {
      case WellnessGoal.stressReduction:
        return 'Stress Reduction';
      case WellnessGoal.increasedEnergy:
        return 'Increased Energy';
      case WellnessGoal.betterSleep:
        return 'Better Sleep';
      case WellnessGoal.physicalFitness:
        return 'Physical Fitness';
      case WellnessGoal.healthyEating:
        return 'Healthy Eating';
      case WellnessGoal.socialConnection:
        return 'Social Connection';
    }
  }
}
