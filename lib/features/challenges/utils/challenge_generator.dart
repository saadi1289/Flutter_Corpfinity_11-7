import 'package:corpfinity_employee_app/data/models/enums.dart';

/// ChallengeGenerator - Utility class for generating personalized wellness challenges
/// 
/// This class provides static methods to generate contextual wellness challenges
/// based on user inputs: energy level, location context, and wellness goal.
/// 
/// Current Implementation: Static placeholder logic with 10-15 challenge variations
/// Future Enhancement: AI-powered challenge generation using ML models or LLM APIs
/// 
/// Usage:
/// ```dart
/// final challenge = ChallengeGenerator.generateChallenge(
///   energy: EnergyLevel.medium,
///   location: LocationContext.office,
///   goal: WellnessGoal.stressReduction,
/// );
/// ```
class ChallengeGenerator {
  // Private constructor to prevent instantiation
  ChallengeGenerator._();

  /// Generate a personalized wellness challenge based on user context
  /// 
  /// Parameters:
  /// - [energy]: User's current energy level (Low, Medium, High)
  /// - [location]: User's current location context (Home, Office, Gym, Outdoor)
  /// - [goal]: User's wellness focus area
  /// 
  /// Returns: A contextual challenge string tailored to the user's inputs
  /// 
  /// Future: This method will be replaced with AI-powered generation that:
  /// - Calls an ML model or LLM API (e.g., OpenAI, Claude, custom model)
  /// - Considers user history and preferences
  /// - Generates more diverse and personalized challenges
  /// - Adapts based on user feedback and completion rates
  static String generateChallenge({
    required EnergyLevel energy,
    required LocationContext location,
    required WellnessGoal goal,
  }) {
    // Get contextual challenge variations
    final challenges = _getChallengeVariations(energy, location, goal);
    
    // Return the first challenge from the list
    // Future: Implement randomization or smart selection based on user history
    return challenges.first;
  }

  /// Get a list of challenge variations based on user context
  /// 
  /// This method returns multiple challenge options for the given combination
  /// of energy, location, and goal. Currently returns 1-2 variations per context.
  /// 
  /// Future: Expand to return more variations and implement smart selection
  static List<String> _getChallengeVariations(
    EnergyLevel energy,
    LocationContext location,
    WellnessGoal goal,
  ) {
    // ========================================================================
    // LOW ENERGY CHALLENGES
    // ========================================================================
    // When energy is low, focus on gentle, restorative activities
    
    if (energy == EnergyLevel.low) {
      // Low energy + Stress Reduction
      if (goal == WellnessGoal.stressReduction) {
        if (location == LocationContext.home) {
          return [
            'Take 5 deep breaths and practice gentle stretching for 3 minutes in a comfortable space',
            'Listen to calming music while doing light shoulder rolls and neck stretches',
          ];
        } else if (location == LocationContext.office) {
          return [
            'Step away from your desk and do 5 minutes of seated breathing exercises',
            'Close your eyes and practice progressive muscle relaxation at your desk',
          ];
        }
        return [
          'Take 5 deep breaths and practice gentle stretching for 3 minutes',
          'Listen to calming music while doing light shoulder rolls',
        ];
      }
      
      // Low energy + Better Sleep
      if (goal == WellnessGoal.betterSleep) {
        if (location == LocationContext.home) {
          return [
            'Do a 5-minute body scan meditation lying down to relax your muscles',
            'Practice progressive muscle relaxation for 10 minutes before rest',
          ];
        }
        return [
          'Do a 5-minute body scan meditation to relax your muscles',
          'Practice gentle breathing exercises to prepare for better rest',
        ];
      }
      
      // Low energy + Increased Energy
      if (goal == WellnessGoal.increasedEnergy) {
        if (location == LocationContext.outdoor) {
          return [
            'Take a slow 5-minute walk outside and drink a glass of water',
            'Get some fresh air and sunlight for 5 minutes to boost energy',
          ];
        }
        return [
          'Take a 5-minute walk and drink a glass of water',
          'Do 10 gentle jumping jacks and stretch your arms overhead',
        ];
      }
      
      // Low energy + Healthy Eating
      if (goal == WellnessGoal.healthyEating) {
        return [
          'Prepare a light, nutritious snack with fruits and stay hydrated',
          'Drink a glass of water and eat a piece of fruit for quick energy',
        ];
      }
      
      // Low energy + Social Connection
      if (goal == WellnessGoal.socialConnection) {
        return [
          'Send a thoughtful message to a friend or family member',
          'Make a quick call to check in with someone you care about',
        ];
      }
    }

    // ========================================================================
    // MEDIUM ENERGY CHALLENGES
    // ========================================================================
    // When energy is medium, balance activity with manageable intensity
    
    if (energy == EnergyLevel.medium) {
      // Medium energy + Office location
      if (location == LocationContext.office) {
        if (goal == WellnessGoal.physicalFitness) {
          return [
            'Take the stairs for 5 minutes or do desk exercises like chair squats',
            'Walk around your office building for 10 minutes at a brisk pace',
          ];
        }
        if (goal == WellnessGoal.stressReduction) {
          return [
            'Step outside for fresh air and practice mindful breathing for 5 minutes',
            'Do a 5-minute guided meditation at your desk with headphones',
          ];
        }
        if (goal == WellnessGoal.socialConnection) {
          return [
            'Take a walking break with a colleague and catch up',
            'Invite a coworker for a coffee chat during your break',
          ];
        }
      }
      
      // Medium energy + Home location
      if (location == LocationContext.home) {
        if (goal == WellnessGoal.healthyEating) {
          return [
            'Prepare a healthy snack with fruits, nuts, and yogurt',
            'Make a nutritious smoothie with greens and protein',
          ];
        }
        if (goal == WellnessGoal.physicalFitness) {
          return [
            'Do a 15-minute home workout with bodyweight exercises',
            'Follow a 20-minute yoga or stretching routine',
          ];
        }
        if (goal == WellnessGoal.stressReduction) {
          return [
            'Practice 10 minutes of mindfulness meditation in a quiet space',
            'Do gentle yoga stretches for 15 minutes to release tension',
          ];
        }
      }
      
      // Medium energy + Gym location
      if (location == LocationContext.gym) {
        if (goal == WellnessGoal.physicalFitness) {
          return [
            'Complete a 25-minute moderate intensity cardio session',
            'Do a balanced strength training circuit for 30 minutes',
          ];
        }
        if (goal == WellnessGoal.increasedEnergy) {
          return [
            'Do a 20-minute energizing workout with intervals',
            'Complete a dynamic warm-up and 15-minute cardio session',
          ];
        }
      }
      
      // Medium energy + Outdoor location
      if (location == LocationContext.outdoor) {
        if (goal == WellnessGoal.physicalFitness) {
          return [
            'Go for a 20-minute brisk walk or light jog in nature',
            'Do a 15-minute outdoor bodyweight workout routine',
          ];
        }
        if (goal == WellnessGoal.stressReduction) {
          return [
            'Take a mindful 15-minute nature walk, focusing on your surroundings',
            'Find a peaceful spot and practice breathing exercises for 10 minutes',
          ];
        }
      }
      
      // Medium energy + Increased Energy (general)
      if (goal == WellnessGoal.increasedEnergy) {
        return [
          'Do 15 minutes of moderate exercise and stay well hydrated',
          'Take a brisk 10-minute walk and do some dynamic stretches',
        ];
      }
      
      // Medium energy + Better Sleep (general)
      if (goal == WellnessGoal.betterSleep) {
        return [
          'Practice 15 minutes of gentle evening yoga or stretching',
          'Do a calming meditation session for 10 minutes',
        ];
      }
    }

    // ========================================================================
    // HIGH ENERGY CHALLENGES
    // ========================================================================
    // When energy is high, engage in more vigorous activities
    
    if (energy == EnergyLevel.high) {
      // High energy + Gym location
      if (location == LocationContext.gym) {
        if (goal == WellnessGoal.physicalFitness) {
          return [
            'Complete a 30-minute high-intensity interval training (HIIT) session',
            'Do a full-body strength training circuit for 40 minutes',
          ];
        }
        if (goal == WellnessGoal.increasedEnergy) {
          return [
            'Complete a 25-minute cardio workout with challenging intervals',
            'Do an energizing 30-minute workout combining cardio and strength',
          ];
        }
        return [
          'Complete a 20-minute cardio workout with intervals',
          'Do a full-body strength training circuit for 30 minutes',
        ];
      }
      
      // High energy + Outdoor location
      if (location == LocationContext.outdoor) {
        if (goal == WellnessGoal.physicalFitness) {
          return [
            'Go for a 30-minute run or intense hike in nature',
            'Do a 25-minute outdoor HIIT workout with bodyweight exercises',
          ];
        }
        if (goal == WellnessGoal.socialConnection) {
          return [
            'Invite a friend for a 30-minute active walk or jog and catch up',
            'Join a group fitness class or outdoor sports activity',
          ];
        }
        if (goal == WellnessGoal.stressReduction) {
          return [
            'Go for an energizing 25-minute run to clear your mind',
            'Do an outdoor workout followed by 5 minutes of mindful breathing',
          ];
        }
        return [
          'Go for a 30-minute jog or brisk walk in nature',
          'Do a 20-minute outdoor workout with bodyweight exercises',
        ];
      }
      
      // High energy + Home location
      if (location == LocationContext.home) {
        if (goal == WellnessGoal.physicalFitness) {
          return [
            'Complete a 30-minute high-energy home workout routine',
            'Do a challenging 25-minute HIIT or cardio session',
          ];
        }
        if (goal == WellnessGoal.healthyEating) {
          return [
            'Prepare a nutritious post-workout meal with protein and vegetables',
            'Make a healthy, energizing meal with whole grains and lean protein',
          ];
        }
      }
      
      // High energy + Office location
      if (location == LocationContext.office) {
        if (goal == WellnessGoal.physicalFitness) {
          return [
            'Take a vigorous 15-minute stair climbing break',
            'Do a quick 10-minute high-intensity desk workout routine',
          ];
        }
        if (goal == WellnessGoal.socialConnection) {
          return [
            'Organize a walking meeting with colleagues',
            'Invite coworkers for an active lunch break activity',
          ];
        }
      }
      
      // High energy + Increased Energy (general)
      if (goal == WellnessGoal.increasedEnergy) {
        return [
          'Do a 25-minute high-intensity workout to boost endorphins',
          'Complete an energizing 20-minute cardio and strength session',
        ];
      }
    }

    // ========================================================================
    // DEFAULT CHALLENGES BY GOAL
    // ========================================================================
    // Fallback challenges when no specific context match is found
    
    switch (goal) {
      case WellnessGoal.stressReduction:
        return [
          'Practice 10 minutes of mindful breathing and relaxation',
          'Do gentle stretching exercises for 10 minutes to release tension',
        ];
      
      case WellnessGoal.increasedEnergy:
        return [
          'Take a 15-minute energizing walk and stay hydrated',
          'Do 10 minutes of dynamic movement to boost your energy',
        ];
      
      case WellnessGoal.betterSleep:
        return [
          'Do 10 minutes of gentle stretching and relaxation exercises',
          'Practice calming breathing techniques for 10 minutes',
        ];
      
      case WellnessGoal.physicalFitness:
        return [
          'Complete a 20-minute moderate intensity workout',
          'Do a balanced exercise routine for 25 minutes',
        ];
      
      case WellnessGoal.healthyEating:
        return [
          'Prepare a nutritious meal with vegetables and lean protein',
          'Make a healthy snack with fruits, nuts, and whole grains',
        ];
      
      case WellnessGoal.socialConnection:
        return [
          'Reach out to a friend or colleague for a meaningful chat',
          'Schedule a call or meetup with someone you care about',
        ];
    }
  }

  /// Get all possible challenge variations for a given goal
  /// 
  /// This method can be used for testing or to provide users with
  /// multiple challenge options to choose from.
  /// 
  /// Future: Use this for A/B testing different challenge formats
  static List<String> getAllChallengesForGoal(WellnessGoal goal) {
    final allChallenges = <String>[];
    
    for (final energy in EnergyLevel.values) {
      for (final location in LocationContext.values) {
        final challenges = _getChallengeVariations(energy, location, goal);
        allChallenges.addAll(challenges);
      }
    }
    
    return allChallenges.toSet().toList(); // Remove duplicates
  }

  /// Get a random challenge variation for the given context
  /// 
  /// This method can be used to provide variety when users regenerate challenges
  /// 
  /// Future: Implement smart randomization that avoids recently shown challenges
  static String getRandomChallenge({
    required EnergyLevel energy,
    required LocationContext location,
    required WellnessGoal goal,
  }) {
    final challenges = _getChallengeVariations(energy, location, goal);
    
    // For now, return the first challenge
    // Future: Implement proper randomization with seeding
    return challenges.first;
  }
}
