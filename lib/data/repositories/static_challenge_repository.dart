import 'package:flutter/material.dart';
import '../models/static_challenge_model.dart';
import '../models/enums.dart';
import '../../core/constants/colors.dart';

/// Repository for static challenge data
/// Provides pre-defined challenges for each wellness area
class StaticChallengeRepository {
  /// Get challenge for a specific wellness area
  static StaticChallengeModel getChallengeForWellnessArea(WellnessGoal wellnessArea) {
    final challenge = _challenges[wellnessArea];
    if (challenge == null) {
      throw ArgumentError('No challenge found for wellness area: $wellnessArea');
    }
    return challenge;
  }

  /// Get all available challenges
  static List<StaticChallengeModel> getAllChallenges() {
    return _challenges.values.toList();
  }

  /// Check if a challenge exists for a wellness area
  static bool hasChallengeForWellnessArea(WellnessGoal wellnessArea) {
    return _challenges.containsKey(wellnessArea);
  }

  /// Static challenge definitions mapped to wellness areas
  static final Map<WellnessGoal, StaticChallengeModel> _challenges = {
    WellnessGoal.stressReduction: const StaticChallengeModel(
      id: 'static_stress_reduction',
      wellnessArea: WellnessGoal.stressReduction,
      title: 'Mindful Breathing Journey',
      goalDescription: 'Practice 5 minutes of deep breathing exercises twice daily to reduce stress and improve focus',
      duration: '7 days',
      icon: Icons.spa_outlined,
      motivationalText: 'Take a moment to breathe. Your mind will thank you.',
      accentColor: AppColors.calmBlue,
    ),
    
    WellnessGoal.increasedEnergy: const StaticChallengeModel(
      id: 'static_increased_energy',
      wellnessArea: WellnessGoal.increasedEnergy,
      title: 'Morning Energy Boost',
      goalDescription: 'Start each day with a 10-minute energizing routine combining stretches and light movement',
      duration: '5 days',
      icon: Icons.bolt_outlined,
      motivationalText: 'Fuel your day with movement and intention.',
      accentColor: AppColors.warmOrange,
    ),
    
    WellnessGoal.betterSleep: const StaticChallengeModel(
      id: 'static_better_sleep',
      wellnessArea: WellnessGoal.betterSleep,
      title: 'Restful Night Routine',
      goalDescription: 'Establish a calming bedtime routine 30 minutes before sleep, avoiding screens',
      duration: '10 days',
      icon: Icons.nightlight_outlined,
      motivationalText: 'Quality sleep is the foundation of wellness.',
      accentColor: AppColors.softPurple,
    ),
    
    WellnessGoal.physicalFitness: const StaticChallengeModel(
      id: 'static_physical_fitness',
      wellnessArea: WellnessGoal.physicalFitness,
      title: 'Active Living Quest',
      goalDescription: 'Complete 20 minutes of moderate physical activity daily, tracking your progress',
      duration: '14 days',
      icon: Icons.fitness_center_outlined,
      motivationalText: 'Every step forward is progress.',
      accentColor: AppColors.softGreen,
    ),
    
    WellnessGoal.healthyEating: const StaticChallengeModel(
      id: 'static_healthy_eating',
      wellnessArea: WellnessGoal.healthyEating,
      title: 'Nourish & Thrive',
      goalDescription: 'Add one serving of vegetables to each meal and stay hydrated with 8 glasses of water daily',
      duration: '7 days',
      icon: Icons.restaurant_outlined,
      motivationalText: 'Feed your body, fuel your life.',
      accentColor: AppColors.freshGreen,
    ),
    
    WellnessGoal.socialConnection: const StaticChallengeModel(
      id: 'static_social_connection',
      wellnessArea: WellnessGoal.socialConnection,
      title: 'Connection Circle',
      goalDescription: 'Reach out to a friend or colleague for a meaningful conversation each day',
      duration: '5 days',
      icon: Icons.people_outline,
      motivationalText: 'Strong connections create strong communities.',
      accentColor: AppColors.coralPink,
    ),
  };

  // Private constructor to prevent instantiation
  StaticChallengeRepository._();
}
