import '../models/models.dart';
import '../services/hive_service.dart';
import '../services/local_cache_service.dart';
import '../services/offline_queue_service.dart';
import '../services/data_sync_service.dart';

/// Repository for managing local storage operations
class LocalStorageRepository {
  final LocalCacheService _cacheService;
  final OfflineQueueService _queueService;
  final DataSyncService _syncService;

  LocalStorageRepository({
    LocalCacheService? cacheService,
    OfflineQueueService? queueService,
    DataSyncService? syncService,
  })  : _cacheService = cacheService ?? LocalCacheService(),
        _queueService = queueService ?? OfflineQueueService(),
        _syncService = syncService ?? DataSyncService();

  // ==================== User Operations ====================

  /// Save user to local storage
  Future<void> saveUser(User user) async {
    await HiveService.userBox.put('current_user', user);
  }

  /// Get current user from local storage
  User? getCurrentUser() {
    return HiveService.userBox.get('current_user');
  }

  /// Delete current user
  Future<void> deleteUser() async {
    await HiveService.userBox.delete('current_user');
  }

  // ==================== Activity Operations ====================

  /// Cache activities
  Future<void> cacheActivities(List<Activity> activities) async {
    await _cacheService.cacheActivities(activities);
  }

  /// Get cached activities
  List<Activity> getCachedActivities() {
    return _cacheService.getCachedActivities();
  }

  /// Get activity by ID
  Activity? getActivityById(String activityId) {
    return _cacheService.getCachedActivity(activityId);
  }

  /// Get activities by pillar
  List<Activity> getActivitiesByPillar(String pillarId) {
    return _cacheService.getCachedActivitiesByPillar(pillarId);
  }

  /// Search activities
  List<Activity> searchActivities(String query) {
    return _cacheService.searchCachedActivities(query);
  }

  /// Check if activities cache is valid
  bool isActivitiesCacheValid() {
    return _cacheService.isCacheValid();
  }

  /// Get cache metadata
  Map<String, dynamic>? getCacheMetadata() {
    return _cacheService.getCacheMetadata();
  }

  // ==================== Progress Operations ====================

  /// Save user progress
  Future<void> saveProgress(UserProgress progress) async {
    await HiveService.progressBox.put(progress.userId, progress);
  }

  /// Get user progress
  UserProgress? getProgress(String userId) {
    return HiveService.progressBox.get(userId);
  }

  /// Update streak
  Future<void> updateStreak(String userId, int currentStreak, int longestStreak) async {
    final progress = getProgress(userId);
    if (progress != null) {
      final updated = progress.copyWith(
        currentStreak: currentStreak,
        longestStreak: longestStreak,
      );
      await saveProgress(updated);
    }
  }

  /// Add completed day
  Future<void> addCompletedDay(String userId, DateTime date) async {
    final progress = getProgress(userId);
    if (progress != null) {
      final completedDays = List<DateTime>.from(progress.completedDays);
      if (!completedDays.any((d) => 
          d.year == date.year && d.month == date.month && d.day == date.day)) {
        completedDays.add(date);
        final updated = progress.copyWith(completedDays: completedDays);
        await saveProgress(updated);
      }
    }
  }

  // ==================== Offline Queue Operations ====================

  /// Queue activity completion for offline sync
  Future<void> queueActivityCompletion({
    required String activityId,
    required String activityName,
    required DateTime completedAt,
    required int pointsEarned,
  }) async {
    await _queueService.queueActivityCompletion(
      activityId: activityId,
      activityName: activityName,
      completedAt: completedAt,
      pointsEarned: pointsEarned,
    );
  }

  /// Get queued items count
  int getQueuedItemsCount() {
    return _queueService.getQueuedItemsCount();
  }

  /// Check if has queued items
  bool hasQueuedItems() {
    return _queueService.hasQueuedItems();
  }

  /// Get all queued items
  List<Map<String, dynamic>> getQueuedItems() {
    return _queueService.getQueuedItems();
  }

  // ==================== Sync Operations ====================

  /// Sync all data with backend
  Future<SyncResult> syncAll() async {
    return await _syncService.syncAll();
  }

  /// Check if sync is needed
  bool needsSync() {
    return _syncService.needsSync();
  }

  /// Get sync status
  SyncStatus getSyncStatus() {
    return _syncService.getSyncStatus();
  }

  // ==================== Cleanup Operations ====================

  /// Clear all local data
  Future<void> clearAll() async {
    await HiveService.clearAll();
  }

  /// Clear only cache
  Future<void> clearCache() async {
    await _cacheService.clearCache();
  }

  /// Clear only queue
  Future<void> clearQueue() async {
    await _queueService.clearQueue();
  }
}
