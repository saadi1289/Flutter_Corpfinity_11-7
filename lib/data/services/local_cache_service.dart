import '../models/activity.dart';
import 'hive_service.dart';

/// Service for managing local caching of activities and home screen data
/// with configurable refresh durations for offline-first strategy.
/// 
/// Requirements: 10.4, 11.5
class LocalCacheService {
  static const String _activitiesCacheKey = 'activities_cache_timestamp';
  static const String _homeDataCacheKey = 'home_data_cache_timestamp';
  static const String _quickStatsCacheKey = 'quick_stats_cache_timestamp';
  
  static const Duration _cacheValidDuration = Duration(hours: 24);
  static const Duration _homeDataCacheDuration = Duration(hours: 6);
  static const Duration _quickStatsCacheDuration = Duration(hours: 1);

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
  
  // ========== Home Screen Data Caching ==========
  
  /// Check if home screen data cache is valid
  bool isHomeDataCacheValid() {
    return _isCacheValid(_homeDataCacheKey, _homeDataCacheDuration);
  }
  
  /// Cache home screen data
  Future<void> cacheHomeData(Map<String, dynamic> data) async {
    await HiveService.cacheMetadataBox.put(_homeDataCacheKey, {
      'timestamp': DateTime.now().toIso8601String(),
      'data': data,
    });
  }
  
  /// Get cached home screen data
  Map<String, dynamic>? getCachedHomeData() {
    final metadata = HiveService.cacheMetadataBox.get(_homeDataCacheKey);
    if (metadata == null) return null;
    return metadata['data'] as Map<String, dynamic>?;
  }
  
  // ========== Quick Stats Caching ==========
  
  /// Check if quick stats cache is valid
  bool isQuickStatsCacheValid() {
    return _isCacheValid(_quickStatsCacheKey, _quickStatsCacheDuration);
  }
  
  /// Cache quick stats data
  Future<void> cacheQuickStats(Map<String, dynamic> stats) async {
    await HiveService.cacheMetadataBox.put(_quickStatsCacheKey, {
      'timestamp': DateTime.now().toIso8601String(),
      'data': stats,
    });
  }
  
  /// Get cached quick stats
  Map<String, dynamic>? getCachedQuickStats() {
    final metadata = HiveService.cacheMetadataBox.get(_quickStatsCacheKey);
    if (metadata == null) return null;
    return metadata['data'] as Map<String, dynamic>?;
  }
  
  // ========== Generic Cache Validation ==========
  
  /// Generic cache validation helper
  bool _isCacheValid(String key, Duration validDuration) {
    final metadata = HiveService.cacheMetadataBox.get(key);
    if (metadata == null) return false;

    final cachedAt = DateTime.parse(metadata['timestamp'] as String);
    final now = DateTime.now();
    final difference = now.difference(cachedAt);

    return difference < validDuration;
  }
  
  // ========== Cache Management ==========
  
  /// Clear all caches (activities, home data, quick stats)
  Future<void> clearAllCaches() async {
    await clearCache();
    await HiveService.cacheMetadataBox.delete(_homeDataCacheKey);
    await HiveService.cacheMetadataBox.delete(_quickStatsCacheKey);
  }
  
  /// Get total cache size estimate
  Future<int> getTotalCacheSize() async {
    int totalSize = 0;
    
    // Estimate activities cache size
    final activities = getCachedActivities();
    totalSize += activities.length * 1024; // Rough estimate: 1KB per activity
    
    // Estimate home data cache size
    final homeData = getCachedHomeData();
    if (homeData != null) {
      totalSize += 2048; // Rough estimate: 2KB for home data
    }
    
    // Estimate quick stats cache size
    final quickStats = getCachedQuickStats();
    if (quickStats != null) {
      totalSize += 1024; // Rough estimate: 1KB for quick stats
    }
    
    return totalSize;
  }
  
  /// Check if total cache size is within acceptable limits
  /// Target: Keep initial payload under 500KB (Requirement 11.5)
  Future<bool> isCacheSizeAcceptable() async {
    final size = await getTotalCacheSize();
    return size < 500 * 1024; // 500KB limit
  }
  
  /// Cleanup strategy: Remove oldest cached data if size exceeds limit
  Future<void> enforcePayloadLimit() async {
    final isAcceptable = await isCacheSizeAcceptable();
    
    if (!isAcceptable) {
      // Clear least critical caches first
      await HiveService.cacheMetadataBox.delete(_quickStatsCacheKey);
      
      // Check again
      final stillTooLarge = !(await isCacheSizeAcceptable());
      if (stillTooLarge) {
        await HiveService.cacheMetadataBox.delete(_homeDataCacheKey);
      }
    }
  }
}
