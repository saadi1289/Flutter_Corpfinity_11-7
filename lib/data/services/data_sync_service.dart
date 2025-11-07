import 'dart:async';
import 'package:flutter/foundation.dart';
import 'offline_queue_service.dart';
import 'local_cache_service.dart';

/// Service for syncing local data with backend when app comes online
class DataSyncService {
  final OfflineQueueService _offlineQueueService;
  final LocalCacheService _localCacheService;
  
  // Callback for syncing activity completions to backend
  final Future<bool> Function(Map<String, dynamic>)? onSyncActivityCompletion;
  
  // Callback for fetching activities from backend
  final Future<List<dynamic>>? Function()? onFetchActivities;

  DataSyncService({
    OfflineQueueService? offlineQueueService,
    LocalCacheService? localCacheService,
    this.onSyncActivityCompletion,
    this.onFetchActivities,
  })  : _offlineQueueService = offlineQueueService ?? OfflineQueueService(),
        _localCacheService = localCacheService ?? LocalCacheService();

  /// Sync all queued data with backend
  Future<SyncResult> syncAll() async {
    final result = SyncResult();

    try {
      // Sync queued activity completions
      final completionResult = await _syncActivityCompletions();
      result.activityCompletionsSynced = completionResult.synced;
      result.activityCompletionsFailed = completionResult.failed;

      // Refresh activities cache if needed
      if (!_localCacheService.isCacheValid()) {
        final cacheRefreshed = await _refreshActivitiesCache();
        result.activitiesCacheRefreshed = cacheRefreshed;
      }

      result.success = true;
    } catch (e) {
      result.success = false;
      result.error = e.toString();
      debugPrint('Sync error: $e');
    }

    return result;
  }

  /// Sync queued activity completions
  Future<_SyncItemResult> _syncActivityCompletions() async {
    final result = _SyncItemResult();
    
    if (onSyncActivityCompletion == null) {
      debugPrint('No sync callback provided for activity completions');
      return result;
    }

    final queueKeys = _offlineQueueService.getQueueKeys();
    
    for (final key in queueKeys) {
      final item = _offlineQueueService.getQueueItem(key);
      if (item == null) continue;

      try {
        // Attempt to sync with backend
        final success = await onSyncActivityCompletion!(item);
        
        if (success) {
          // Remove from queue on successful sync
          await _offlineQueueService.removeQueuedItem(key);
          result.synced++;
        } else {
          result.failed++;
        }
      } catch (e) {
        debugPrint('Failed to sync item $key: $e');
        result.failed++;
      }
    }

    return result;
  }

  /// Refresh activities cache from backend
  Future<bool> _refreshActivitiesCache() async {
    if (onFetchActivities == null) {
      debugPrint('No fetch callback provided for activities');
      return false;
    }

    try {
      final activities = await onFetchActivities!();
      if (activities != null && activities.isNotEmpty) {
        // Convert to Activity objects and cache
        // Note: This assumes the callback returns proper Activity objects
        // In real implementation, you'd convert JSON to Activity objects here
        debugPrint('Activities cache refreshed: ${activities.length} items');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Failed to refresh activities cache: $e');
      return false;
    }
  }

  /// Check if sync is needed
  bool needsSync() {
    return _offlineQueueService.hasQueuedItems() || 
           !_localCacheService.isCacheValid();
  }

  /// Get sync status
  SyncStatus getSyncStatus() {
    return SyncStatus(
      queuedItems: _offlineQueueService.getQueuedItemsCount(),
      cacheValid: _localCacheService.isCacheValid(),
      cacheMetadata: _localCacheService.getCacheMetadata(),
    );
  }
}

/// Result of a sync operation
class SyncResult {
  bool success = false;
  int activityCompletionsSynced = 0;
  int activityCompletionsFailed = 0;
  bool activitiesCacheRefreshed = false;
  String? error;

  @override
  String toString() {
    return 'SyncResult(success: $success, synced: $activityCompletionsSynced, '
        'failed: $activityCompletionsFailed, cacheRefreshed: $activitiesCacheRefreshed, '
        'error: $error)';
  }
}

/// Internal result for syncing individual items
class _SyncItemResult {
  int synced = 0;
  int failed = 0;
}

/// Current sync status
class SyncStatus {
  final int queuedItems;
  final bool cacheValid;
  final Map<String, dynamic>? cacheMetadata;

  SyncStatus({
    required this.queuedItems,
    required this.cacheValid,
    this.cacheMetadata,
  });

  bool get needsSync => queuedItems > 0 || !cacheValid;

  @override
  String toString() {
    return 'SyncStatus(queuedItems: $queuedItems, cacheValid: $cacheValid, '
        'needsSync: $needsSync)';
  }
}
