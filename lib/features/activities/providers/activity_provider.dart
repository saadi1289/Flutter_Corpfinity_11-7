import 'package:flutter/foundation.dart';
import '../../../data/models/activity.dart';
import '../../../data/models/activity_step.dart';
import '../../../data/models/enums.dart';

/// ActivityProvider manages activity data, recommendations, and selection state
class ActivityProvider extends ChangeNotifier {
  List<Activity> _activities = [];
  Activity? _selectedActivity;
  bool _isLoading = false;
  String? _error;

  List<Activity> get activities => _activities;
  Activity? get selectedActivity => _selectedActivity;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all activities (currently using mock data)
  Future<void> loadActivities() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual repository call when backend is integrated
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data - activities across all pillars
      _activities = _getMockActivities();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Get recommended activities based on energy level and pillar
  List<Activity> getRecommendedActivities({
    required EnergyLevel energyLevel,
    required String pillarId,
  }) {
    // Filter activities by pillar
    var filtered = _activities.where((activity) => activity.pillarId == pillarId).toList();

    // Further filter based on energy level
    // Low energy -> Easy activities
    // Medium energy -> Easy and Medium activities
    // High energy -> All activities, prioritize Medium and Hard
    switch (energyLevel) {
      case EnergyLevel.low:
        filtered = filtered.where((a) => a.difficulty == Difficulty.low).toList();
        break;
      case EnergyLevel.medium:
        filtered = filtered.where((a) => 
          a.difficulty == Difficulty.low || a.difficulty == Difficulty.medium
        ).toList();
        break;
      case EnergyLevel.high:
        // Include all difficulties, but sort to prioritize medium and high
        filtered.sort((a, b) {
          final aScore = a.difficulty == Difficulty.high ? 2 : (a.difficulty == Difficulty.medium ? 1 : 0);
          final bScore = b.difficulty == Difficulty.high ? 2 : (b.difficulty == Difficulty.medium ? 1 : 0);
          return bScore.compareTo(aScore);
        });
        break;
    }

    // Return 3-5 activities
    return filtered.take(5).toList();
  }

  /// Select an activity
  void selectActivity(String activityId) {
    _selectedActivity = _activities.firstWhere(
      (activity) => activity.id == activityId,
      orElse: () => _activities.first,
    );
    notifyListeners();
  }

  /// Get activity by ID
  Activity? getActivityById(String id) {
    try {
      return _activities.firstWhere((activity) => activity.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Clear activity selection
  void clearSelection() {
    _selectedActivity = null;
    notifyListeners();
  }

  /// Search activities by name
  List<Activity> searchActivities(String query) {
    if (query.isEmpty) return _activities;
    
    final lowerQuery = query.toLowerCase();
    return _activities.where((activity) {
      return activity.name.toLowerCase().contains(lowerQuery) ||
          activity.description.toLowerCase().contains(lowerQuery) ||
          activity.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  /// Filter activities by pillar
  List<Activity> getActivitiesByPillar(String pillarId) {
    return _activities.where((activity) => activity.pillarId == pillarId).toList();
  }

  /// Refresh activity data
  Future<void> refresh() async {
    await loadActivities();
  }

  /// Mock activities data
  List<Activity> _getMockActivities() {
    return [
      // Stress Reduction Activities
      Activity(
        id: 'sr-1',
        name: 'Deep Breathing Exercise',
        description: 'Calm your mind with focused breathing techniques',
        pillarId: 'stress-reduction',
        durationMinutes: 2,
        difficulty: Difficulty.low,
        location: 'Anywhere',
        thumbnailUrl: 'https://via.placeholder.com/300x200?text=Deep+Breathing',
        steps: [
          const ActivityStep(
            stepNumber: 1,
            title: 'Find a comfortable position',
            instruction: 'Sit or stand in a comfortable position with your back straight.',
            imageUrl: null,
            timerSeconds: null,
          ),
          const ActivityStep(
            stepNumber: 2,
            title: 'Breathe in deeply',
            instruction: 'Inhale slowly through your nose for 4 counts.',
            imageUrl: null,
            timerSeconds: 4,
          ),
          const ActivityStep(
            stepNumber: 3,
            title: 'Hold your breath',
            instruction: 'Hold your breath for 4 counts.',
            imageUrl: null,
            timerSeconds: 4,
          ),
          const ActivityStep(
            stepNumber: 4,
            title: 'Exhale slowly',
            instruction: 'Exhale through your mouth for 6 counts.',
            imageUrl: null,
            timerSeconds: 6,
          ),
        ],
        tags: ['breathing', 'relaxation', 'mindfulness'],
      ),
      Activity(
        id: 'sr-2',
        name: 'Progressive Muscle Relaxation',
        description: 'Release tension by systematically relaxing muscle groups',
        pillarId: 'stress-reduction',
        durationMinutes: 5,
        difficulty: Difficulty.medium,
        location: 'Desk',
        thumbnailUrl: 'https://via.placeholder.com/300x200?text=Muscle+Relaxation',
        steps: [
          const ActivityStep(
            stepNumber: 1,
            title: 'Start with your hands',
            instruction: 'Clench your fists tightly for 5 seconds, then release.',
            imageUrl: null,
            timerSeconds: 5,
          ),
          const ActivityStep(
            stepNumber: 2,
            title: 'Move to your arms',
            instruction: 'Tense your arm muscles for 5 seconds, then relax.',
            imageUrl: null,
            timerSeconds: 5,
          ),
        ],
        tags: ['relaxation', 'tension-relief'],
      ),
      Activity(
        id: 'sr-3',
        name: 'Mindful Observation',
        description: 'Practice mindfulness by observing your surroundings',
        pillarId: 'stress-reduction',
        durationMinutes: 3,
        difficulty: Difficulty.low,
        location: 'Anywhere',
        thumbnailUrl: 'https://via.placeholder.com/300x200?text=Mindful+Observation',
        steps: [
          const ActivityStep(
            stepNumber: 1,
            title: 'Choose an object',
            instruction: 'Select any object in your environment to focus on.',
            imageUrl: null,
            timerSeconds: null,
          ),
        ],
        tags: ['mindfulness', 'awareness'],
      ),

      // Increased Energy Activities
      Activity(
        id: 'ie-1',
        name: 'Desk Stretches',
        description: 'Quick stretches to boost energy and reduce stiffness',
        pillarId: 'increased-energy',
        durationMinutes: 3,
        difficulty: Difficulty.low,
        location: 'Desk',
        thumbnailUrl: 'https://via.placeholder.com/300x200?text=Desk+Stretches',
        steps: [
          const ActivityStep(
            stepNumber: 1,
            title: 'Neck rolls',
            instruction: 'Slowly roll your neck in circles, 5 times each direction.',
            imageUrl: null,
            timerSeconds: 20,
          ),
        ],
        tags: ['stretching', 'movement'],
      ),
      Activity(
        id: 'ie-2',
        name: 'Power Walk',
        description: 'A brisk walk to energize your body and mind',
        pillarId: 'increased-energy',
        durationMinutes: 5,
        difficulty: Difficulty.medium,
        location: 'Outdoor',
        thumbnailUrl: 'https://via.placeholder.com/300x200?text=Power+Walk',
        steps: [
          const ActivityStep(
            stepNumber: 1,
            title: 'Start walking',
            instruction: 'Walk at a brisk pace, swinging your arms naturally.',
            imageUrl: null,
            timerSeconds: 300,
          ),
        ],
        tags: ['walking', 'cardio'],
      ),
      Activity(
        id: 'ie-3',
        name: 'Jumping Jacks',
        description: 'Quick cardio burst to increase alertness',
        pillarId: 'increased-energy',
        durationMinutes: 2,
        difficulty: Difficulty.high,
        location: 'Anywhere',
        thumbnailUrl: 'https://via.placeholder.com/300x200?text=Jumping+Jacks',
        steps: [
          const ActivityStep(
            stepNumber: 1,
            title: 'Perform jumping jacks',
            instruction: 'Do 30 jumping jacks at a steady pace.',
            imageUrl: null,
            timerSeconds: 60,
          ),
        ],
        tags: ['cardio', 'exercise'],
      ),

      // Better Sleep Activities
      Activity(
        id: 'bs-1',
        name: 'Evening Wind-Down',
        description: 'Gentle stretches to prepare for restful sleep',
        pillarId: 'better-sleep',
        durationMinutes: 4,
        difficulty: Difficulty.low,
        location: 'Anywhere',
        thumbnailUrl: 'https://via.placeholder.com/300x200?text=Wind+Down',
        steps: [
          const ActivityStep(
            stepNumber: 1,
            title: 'Gentle stretching',
            instruction: 'Perform slow, gentle stretches focusing on relaxation.',
            imageUrl: null,
            timerSeconds: 240,
          ),
        ],
        tags: ['sleep', 'relaxation'],
      ),
      Activity(
        id: 'bs-2',
        name: 'Body Scan Meditation',
        description: 'Relax your body from head to toe',
        pillarId: 'better-sleep',
        durationMinutes: 5,
        difficulty: Difficulty.medium,
        location: 'Anywhere',
        thumbnailUrl: 'https://via.placeholder.com/300x200?text=Body+Scan',
        steps: [
          const ActivityStep(
            stepNumber: 1,
            title: 'Lie down comfortably',
            instruction: 'Find a comfortable position and close your eyes.',
            imageUrl: null,
            timerSeconds: null,
          ),
        ],
        tags: ['meditation', 'sleep'],
      ),

      // Physical Fitness Activities
      Activity(
        id: 'pf-1',
        name: 'Wall Push-Ups',
        description: 'Strengthen your upper body with wall push-ups',
        pillarId: 'physical-fitness',
        durationMinutes: 3,
        difficulty: Difficulty.low,
        location: 'Office',
        thumbnailUrl: 'https://via.placeholder.com/300x200?text=Wall+Push-Ups',
        steps: [
          const ActivityStep(
            stepNumber: 1,
            title: 'Position yourself',
            instruction: 'Stand arm\'s length from a wall, hands at shoulder height.',
            imageUrl: null,
            timerSeconds: null,
          ),
        ],
        tags: ['strength', 'upper-body'],
      ),
      Activity(
        id: 'pf-2',
        name: 'Desk Squats',
        description: 'Build leg strength with simple squats',
        pillarId: 'physical-fitness',
        durationMinutes: 2,
        difficulty: Difficulty.medium,
        location: 'Desk',
        thumbnailUrl: 'https://via.placeholder.com/300x200?text=Desk+Squats',
        steps: [
          const ActivityStep(
            stepNumber: 1,
            title: 'Perform squats',
            instruction: 'Do 15 squats with proper form.',
            imageUrl: null,
            timerSeconds: 60,
          ),
        ],
        tags: ['strength', 'legs'],
      ),
      Activity(
        id: 'pf-3',
        name: 'Plank Hold',
        description: 'Core strengthening exercise',
        pillarId: 'physical-fitness',
        durationMinutes: 2,
        difficulty: Difficulty.high,
        location: 'Anywhere',
        thumbnailUrl: 'https://via.placeholder.com/300x200?text=Plank',
        steps: [
          const ActivityStep(
            stepNumber: 1,
            title: 'Hold plank position',
            instruction: 'Hold a plank position for 30 seconds.',
            imageUrl: null,
            timerSeconds: 30,
          ),
        ],
        tags: ['core', 'strength'],
      ),

      // Healthy Eating Activities
      Activity(
        id: 'he-1',
        name: 'Hydration Check',
        description: 'Mindful water drinking practice',
        pillarId: 'healthy-eating',
        durationMinutes: 1,
        difficulty: Difficulty.low,
        location: 'Anywhere',
        thumbnailUrl: 'https://via.placeholder.com/300x200?text=Hydration',
        steps: [
          const ActivityStep(
            stepNumber: 1,
            title: 'Drink water mindfully',
            instruction: 'Slowly drink a full glass of water, focusing on the sensation.',
            imageUrl: null,
            timerSeconds: 60,
          ),
        ],
        tags: ['hydration', 'mindfulness'],
      ),
      Activity(
        id: 'he-2',
        name: 'Healthy Snack Prep',
        description: 'Prepare a nutritious snack',
        pillarId: 'healthy-eating',
        durationMinutes: 5,
        difficulty: Difficulty.medium,
        location: 'Kitchen',
        thumbnailUrl: 'https://via.placeholder.com/300x200?text=Snack+Prep',
        steps: [
          const ActivityStep(
            stepNumber: 1,
            title: 'Choose ingredients',
            instruction: 'Select fresh fruits, nuts, or vegetables.',
            imageUrl: null,
            timerSeconds: null,
          ),
        ],
        tags: ['nutrition', 'preparation'],
      ),

      // Social Connection Activities
      Activity(
        id: 'sc-1',
        name: 'Gratitude Message',
        description: 'Send a message of appreciation to someone',
        pillarId: 'social-connection',
        durationMinutes: 3,
        difficulty: Difficulty.low,
        location: 'Anywhere',
        thumbnailUrl: 'https://via.placeholder.com/300x200?text=Gratitude',
        steps: [
          const ActivityStep(
            stepNumber: 1,
            title: 'Think of someone',
            instruction: 'Choose someone you appreciate and want to thank.',
            imageUrl: null,
            timerSeconds: null,
          ),
        ],
        tags: ['gratitude', 'communication'],
      ),
      Activity(
        id: 'sc-2',
        name: 'Coffee Chat',
        description: 'Have a brief conversation with a colleague',
        pillarId: 'social-connection',
        durationMinutes: 5,
        difficulty: Difficulty.medium,
        location: 'Office',
        thumbnailUrl: 'https://via.placeholder.com/300x200?text=Coffee+Chat',
        steps: [
          const ActivityStep(
            stepNumber: 1,
            title: 'Invite a colleague',
            instruction: 'Ask a colleague for a quick coffee or tea break.',
            imageUrl: null,
            timerSeconds: null,
          ),
        ],
        tags: ['conversation', 'connection'],
      ),
    ];
  }
}
