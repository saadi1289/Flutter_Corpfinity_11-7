import '../models/models.dart';
import '../services/hive_service.dart';
import '../../core/exceptions/app_exception.dart';

/// Repository interface for activity operations
abstract class ActivityRepository {
  /// Get recommended activities based on energy level and pillar
  Future<List<Activity>> getRecommendedActivities(
    EnergyLevel energy,
    String pillarId,
  );

  /// Get all activities
  Future<List<Activity>> getAllActivities();

  /// Search activities by query
  Future<List<Activity>> searchActivities(String query);

  /// Get activity by ID
  Future<Activity> getActivityById(String id);

  /// Record activity completion
  Future<void> completeActivity(String activityId);

  /// Cache activities locally
  Future<void> cacheActivitiesLocally(List<Activity> activities);

  /// Get cached activities
  List<Activity> getCachedActivities();
}

/// Mock implementation of ActivityRepository with sample data
class MockActivityRepository implements ActivityRepository {
  static const String _cacheTimestampKey = 'activities_cache_timestamp';
  static const Duration _cacheValidDuration = Duration(hours: 24);

  @override
  Future<List<Activity>> getRecommendedActivities(
    EnergyLevel energy,
    String pillarId,
  ) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Get all activities
      final allActivities = await getAllActivities();

      // Filter by pillar
      var filtered = allActivities
          .where((activity) => activity.pillarId == pillarId)
          .toList();

      // Filter by energy level (match difficulty to energy)
      filtered = filtered.where((activity) {
        switch (energy) {
          case EnergyLevel.low:
            return activity.difficulty == Difficulty.low;
          case EnergyLevel.medium:
            return activity.difficulty == Difficulty.medium;
          case EnergyLevel.high:
            return activity.difficulty == Difficulty.high;
        }
      }).toList();

      // Return 3-5 activities
      return filtered.take(5).toList();
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException(
        'Failed to get recommended activities: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<Activity>> getAllActivities() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));

      // Check if cache is valid
      if (_isCacheValid()) {
        return getCachedActivities();
      }

      // Generate mock activities
      final activities = _generateMockActivities();

      // Cache the activities
      await cacheActivitiesLocally(activities);

      return activities;
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException('Failed to get all activities: ${e.toString()}');
    }
  }

  @override
  Future<List<Activity>> searchActivities(String query) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      final allActivities = await getAllActivities();
      final lowerQuery = query.toLowerCase();

      return allActivities.where((activity) {
        return activity.name.toLowerCase().contains(lowerQuery) ||
            activity.description.toLowerCase().contains(lowerQuery) ||
            activity.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
      }).toList();
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException('Failed to search activities: ${e.toString()}');
    }
  }

  @override
  Future<Activity> getActivityById(String id) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 200));

      final allActivities = await getAllActivities();
      final activity = allActivities.firstWhere(
        (a) => a.id == id,
        orElse: () => throw ValidationException('Activity not found'),
      );

      return activity;
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException('Failed to get activity: ${e.toString()}');
    }
  }

  @override
  Future<void> completeActivity(String activityId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      // Verify activity exists
      await getActivityById(activityId);

      // In a real implementation, this would record completion on backend
      // For now, we just simulate success
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException('Failed to complete activity: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheActivitiesLocally(List<Activity> activities) async {
    try {
      final box = HiveService.activitiesBox;

      // Clear existing cache
      await box.clear();

      // Store activities
      for (final activity in activities) {
        await box.put(activity.id, activity);
      }

      // Store cache timestamp
      final metadataBox = HiveService.cacheMetadataBox;
      await metadataBox.put(_cacheTimestampKey, {
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw UnknownException('Failed to cache activities: ${e.toString()}');
    }
  }

  @override
  List<Activity> getCachedActivities() {
    try {
      final box = HiveService.activitiesBox;
      return box.values.toList();
    } catch (e) {
      return [];
    }
  }

  // Helper methods

  bool _isCacheValid() {
    try {
      final metadataBox = HiveService.cacheMetadataBox;
      final metadata = metadataBox.get(_cacheTimestampKey);

      if (metadata == null) return false;

      final timestamp = DateTime.parse(metadata['timestamp'] as String);
      final now = DateTime.now();

      return now.difference(timestamp) < _cacheValidDuration;
    } catch (e) {
      return false;
    }
  }

  List<Activity> _generateMockActivities() {
    return [
      // Stress Reduction activities
      _createActivity(
        id: 'sr_1',
        name: 'Deep Breathing Exercise',
        description: 'Calm your mind with focused breathing',
        pillarId: 'stress_reduction',
        duration: 2,
        difficulty: Difficulty.low,
        location: 'Anywhere',
        tags: ['breathing', 'relaxation', 'mindfulness'],
        steps: [
          _createStep(1, 'Get Comfortable', 'Sit in a comfortable position'),
          _createStep(2, 'Breathe In', 'Inhale deeply for 4 seconds', timer: 4),
          _createStep(3, 'Hold', 'Hold your breath for 4 seconds', timer: 4),
          _createStep(4, 'Breathe Out', 'Exhale slowly for 6 seconds', timer: 6),
          _createStep(5, 'Repeat', 'Repeat this cycle 5 times'),
        ],
      ),
      _createActivity(
        id: 'sr_2',
        name: 'Progressive Muscle Relaxation',
        description: 'Release tension through systematic muscle relaxation',
        pillarId: 'stress_reduction',
        duration: 5,
        difficulty: Difficulty.medium,
        location: 'Quiet space',
        tags: ['relaxation', 'tension relief', 'body awareness'],
        steps: [
          _createStep(1, 'Find a Quiet Space', 'Sit or lie down comfortably'),
          _createStep(2, 'Tense Feet', 'Curl your toes tightly', timer: 5),
          _createStep(3, 'Release Feet', 'Let go and feel the relaxation'),
          _createStep(4, 'Tense Legs', 'Tighten your leg muscles', timer: 5),
          _createStep(5, 'Continue Upward', 'Work through each muscle group'),
        ],
      ),
      _createActivity(
        id: 'sr_3',
        name: 'Mindful Observation',
        description: 'Ground yourself by observing your surroundings',
        pillarId: 'stress_reduction',
        duration: 3,
        difficulty: Difficulty.high,
        location: 'Anywhere',
        tags: ['mindfulness', 'awareness', 'grounding'],
        steps: [
          _createStep(1, 'Pause', 'Stop what you\'re doing'),
          _createStep(2, '5 Things You See', 'Notice 5 things around you'),
          _createStep(3, '4 Things You Touch', 'Feel 4 different textures'),
          _createStep(4, '3 Things You Hear', 'Listen to 3 sounds'),
          _createStep(5, 'Return', 'Return to your task feeling grounded'),
        ],
      ),

      // Increased Energy activities
      _createActivity(
        id: 'ie_1',
        name: 'Desk Stretches',
        description: 'Quick stretches to boost energy at your desk',
        pillarId: 'increased_energy',
        duration: 3,
        difficulty: Difficulty.low,
        location: 'At desk',
        tags: ['stretching', 'movement', 'circulation'],
        steps: [
          _createStep(1, 'Neck Rolls', 'Gently roll your neck in circles'),
          _createStep(2, 'Shoulder Shrugs', 'Lift shoulders to ears, release'),
          _createStep(3, 'Arm Circles', 'Make large circles with your arms'),
          _createStep(4, 'Torso Twist', 'Twist gently from side to side'),
          _createStep(5, 'Wrist Rotations', 'Rotate wrists in both directions'),
        ],
      ),
      _createActivity(
        id: 'ie_2',
        name: 'Power Pose',
        description: 'Boost confidence and energy with body language',
        pillarId: 'increased_energy',
        duration: 2,
        difficulty: Difficulty.medium,
        location: 'Private space',
        tags: ['confidence', 'posture', 'energy'],
        steps: [
          _createStep(1, 'Stand Tall', 'Stand with feet hip-width apart'),
          _createStep(2, 'Hands on Hips', 'Place hands firmly on hips'),
          _createStep(3, 'Chest Out', 'Expand your chest and stand proud'),
          _createStep(4, 'Hold Position', 'Maintain pose confidently', timer: 60),
          _createStep(5, 'Feel Energized', 'Notice your increased energy'),
        ],
      ),
      _createActivity(
        id: 'ie_3',
        name: 'Quick Walk',
        description: 'Take a brisk walk to energize body and mind',
        pillarId: 'increased_energy',
        duration: 5,
        difficulty: Difficulty.high,
        location: 'Hallway or outside',
        tags: ['walking', 'cardio', 'fresh air'],
        steps: [
          _createStep(1, 'Start Walking', 'Begin at a comfortable pace'),
          _createStep(2, 'Increase Pace', 'Walk briskly for 2 minutes', timer: 120),
          _createStep(3, 'Arm Swings', 'Swing arms naturally as you walk'),
          _createStep(4, 'Deep Breaths', 'Take deep breaths while walking'),
          _createStep(5, 'Cool Down', 'Slow your pace gradually'),
        ],
      ),

      // Better Sleep activities
      _createActivity(
        id: 'bs_1',
        name: 'Evening Wind-Down',
        description: 'Prepare your mind and body for restful sleep',
        pillarId: 'better_sleep',
        duration: 4,
        difficulty: Difficulty.low,
        location: 'Quiet space',
        tags: ['relaxation', 'bedtime', 'routine'],
        steps: [
          _createStep(1, 'Dim Lights', 'Lower lighting in your space'),
          _createStep(2, 'Gentle Stretches', 'Do light stretching'),
          _createStep(3, 'Breathing', 'Practice slow, deep breathing'),
          _createStep(4, 'Gratitude', 'Think of 3 things you\'re grateful for'),
          _createStep(5, 'Relax', 'Let your body fully relax'),
        ],
      ),

      // Physical Fitness activities
      _createActivity(
        id: 'pf_1',
        name: 'Office Cardio Burst',
        description: 'Quick cardio to get your heart pumping',
        pillarId: 'physical_fitness',
        duration: 3,
        difficulty: Difficulty.medium,
        location: 'Open space',
        tags: ['cardio', 'exercise', 'energy'],
        steps: [
          _createStep(1, 'Warm Up', 'March in place for 30 seconds', timer: 30),
          _createStep(2, 'Jumping Jacks', 'Do 20 jumping jacks'),
          _createStep(3, 'High Knees', 'Run in place with high knees', timer: 30),
          _createStep(4, 'Squats', 'Do 15 squats'),
          _createStep(5, 'Cool Down', 'Walk slowly and breathe deeply'),
        ],
      ),

      // Healthy Eating activities
      _createActivity(
        id: 'he_1',
        name: 'Mindful Snacking',
        description: 'Practice mindful eating with a healthy snack',
        pillarId: 'healthy_eating',
        duration: 5,
        difficulty: Difficulty.low,
        location: 'Anywhere',
        tags: ['nutrition', 'mindfulness', 'awareness'],
        steps: [
          _createStep(1, 'Choose Snack', 'Select a healthy snack'),
          _createStep(2, 'Observe', 'Look at the food, notice colors and textures'),
          _createStep(3, 'Smell', 'Take in the aroma'),
          _createStep(4, 'Taste', 'Take small bites, chew slowly'),
          _createStep(5, 'Appreciate', 'Notice how the food nourishes you'),
        ],
      ),

      // Social Connection activities
      _createActivity(
        id: 'sc_1',
        name: 'Coffee Chat',
        description: 'Connect with a colleague over a quick chat',
        pillarId: 'social_connection',
        duration: 5,
        difficulty: Difficulty.medium,
        location: 'Break room',
        tags: ['connection', 'conversation', 'relationships'],
        steps: [
          _createStep(1, 'Invite Someone', 'Ask a colleague to chat'),
          _createStep(2, 'Find Space', 'Go to a comfortable area'),
          _createStep(3, 'Ask Questions', 'Show genuine interest in them'),
          _createStep(4, 'Share', 'Share something about yourself'),
          _createStep(5, 'Express Gratitude', 'Thank them for their time'),
        ],
      ),
      _createActivity(
        id: 'sc_2',
        name: 'Gratitude Message',
        description: 'Send a message of appreciation to someone',
        pillarId: 'social_connection',
        duration: 2,
        difficulty: Difficulty.low,
        location: 'Anywhere',
        tags: ['gratitude', 'appreciation', 'kindness'],
        steps: [
          _createStep(1, 'Think', 'Think of someone who helped you'),
          _createStep(2, 'Write', 'Compose a brief thank you message'),
          _createStep(3, 'Be Specific', 'Mention what you appreciate'),
          _createStep(4, 'Send', 'Send the message'),
          _createStep(5, 'Feel Good', 'Notice how expressing gratitude feels'),
        ],
      ),
    ];
  }

  Activity _createActivity({
    required String id,
    required String name,
    required String description,
    required String pillarId,
    required int duration,
    required Difficulty difficulty,
    required String location,
    required List<String> tags,
    required List<ActivityStep> steps,
  }) {
    return Activity(
      id: id,
      name: name,
      description: description,
      pillarId: pillarId,
      durationMinutes: duration,
      difficulty: difficulty,
      location: location,
      thumbnailUrl: 'assets/images/activities/$id.png',
      steps: steps,
      tags: tags,
    );
  }

  ActivityStep _createStep(
    int number,
    String title,
    String instruction, {
    int? timer,
  }) {
    return ActivityStep(
      stepNumber: number,
      title: title,
      instruction: instruction,
      imageUrl: 'assets/images/steps/step_$number.png',
      timerSeconds: timer,
    );
  }
}
