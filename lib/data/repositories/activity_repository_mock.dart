import '../mock_data.dart';
import '../models/activity.dart';
import '../models/enums.dart';

/// Mock implementation of ActivityRepository using MockData
/// This can be used for development and testing before backend integration
class ActivityRepositoryMock {
  /// Get recommended activities based on energy level and pillar
  Future<List<Activity>> getRecommendedActivities({
    required EnergyLevel energy,
    required String pillarId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    return MockData.getRecommendedActivities(
      energy: energy,
      pillarId: pillarId,
    );
  }

  /// Get all activities
  Future<List<Activity>> getAllActivities() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.activities;
  }

  /// Search activities by query
  Future<List<Activity>> searchActivities(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.searchActivities(query);
  }

  /// Get activity by ID
  Future<Activity?> getActivityById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return MockData.getActivityById(id);
  }

  /// Get activities by pillar
  Future<List<Activity>> getActivitiesByPillar(String pillarId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.getActivitiesByPillar(pillarId);
  }

  /// Simulate completing an activity
  Future<void> completeActivity(String activityId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real implementation, this would update the backend
    // For now, just simulate the delay
  }
}
