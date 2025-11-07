import '../mock_data.dart';
import '../models/wellness_pillar.dart';

/// Mock implementation of WellnessPillarRepository using MockData
/// This can be used for development and testing before backend integration
class WellnessPillarRepositoryMock {
  /// Get all wellness pillars
  Future<List<WellnessPillar>> getAllPillars() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.wellnessPillars;
  }

  /// Get pillar by ID
  Future<WellnessPillar?> getPillarById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return MockData.getPillarById(id);
  }

  /// Get pillar with updated activity count
  Future<WellnessPillar?> getPillarWithActivityCount(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final pillar = MockData.getPillarById(id);
    if (pillar == null) return null;

    final activityCount = MockData.getActivitiesByPillar(id).length;
    return pillar.copyWith(availableActivities: activityCount);
  }
}
