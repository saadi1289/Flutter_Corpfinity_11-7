import '../models/activity.dart';
import 'hive_service.dart';

/// Service for managing local caching of activities with 24-hour refresh
class LocalCacheService {
  static const String _activitiesCacheKey = 'activities_cache_timestamp';
  static const Duration _cacheValidDuration = Duration(hours: 24);

  /// Check if activities cache is valid (less than 24 hours old)
  bool isCacheValid() {
    final metadata = HiveService.cacheMetadataBox.get(_activitiesCacheKey);
    if (metadata == null) return false;

    final cachedAt = DateTime.parse(metadata['timestamp'] as String);
    final now = DateTime.now();
    final difference = now.difference(cachedAt);

    return difference < _cacheValidDuration;
  }

  /// Get cached activities
  List<Activity> getCachedActivities() {
    return HiveService.activitiesBox.values.toList();
  }

  /// Cache activities with timestamp
  Future<void> cacheActivities(List<Activity> activities) async {
    final box = HiveService.activitiesBox;
    
    // Clear existing cache
    await box.clear();

    // Store activities with their IDs as keys
    for (final activity in activities) {
      await box.put(activity.id, activity);
    }

    // Update cache metadata
    await HiveService.cacheMetadataBox.put(_activitiesCacheKey, {
      'timestamp': DateTime.now().toIso8601String(),
      'count': activities.length,
    });
  }

  /// Get a specific activity by ID from cache
  Activity? getCachedActivity(String activityId) {
    return HiveService.activitiesBox.get(activityId);
  }

  /// Get activities filtered by pillar from cache
  List<Activity> getCachedActivitiesByPillar(String pillarId) {
    return HiveService.activitiesBox.values
        .where((activity) => activity.pillarId == pillarId)
        .toList();
  }

  /// Search activities in cache
  List<Activity> searchCachedActivities(String query) {
    final lowerQuery = query.toLowerCase();
    return HiveService.activitiesBox.values
        .where((activity) =>
            activity.name.toLowerCase().contains(lowerQuery) ||
            activity.description.toLowerCase().contains(lowerQuery) ||
            activity.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)))
        .toList();
  }

  /// Clear activities cache
  Future<void> clearCache() async {
    await HiveService.activitiesBox.clear();
    await HiveService.cacheMetadataBox.delete(_activitiesCacheKey);
  }

  /// Get cache metadata
  Map<String, dynamic>? getCacheMetadata() {
    final metadata = HiveService.cacheMetadataBox.get(_activitiesCacheKey);
    if (metadata == null) return null;

    return {
      'timestamp': metadata['timestamp'],
      'count': metadata['count'],
      'isValid': isCacheValid(),
    };
  }
}
