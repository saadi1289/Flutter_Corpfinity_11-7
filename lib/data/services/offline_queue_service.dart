import 'hive_service.dart';

/// Service for managing offline queue of activity completions
class OfflineQueueService {
  /// Queue item types
  static const String _typeActivityCompletion = 'activity_completion';

  /// Add activity completion to offline queue
  Future<void> queueActivityCompletion({
    required String activityId,
    required String activityName,
    required DateTime completedAt,
    required int pointsEarned,
  }) async {
    final queueItem = {
      'type': _typeActivityCompletion,
      'activityId': activityId,
      'activityName': activityName,
      'completedAt': completedAt.toIso8601String(),
      'pointsEarned': pointsEarned,
      'queuedAt': DateTime.now().toIso8601String(),
    };

    // Use timestamp as key to maintain order
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    await HiveService.offlineQueueBox.put(key, queueItem);
  }

  /// Get all queued items
  List<Map<String, dynamic>> getQueuedItems() {
    return HiveService.offlineQueueBox.values
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  /// Get count of queued items
  int getQueuedItemsCount() {
    return HiveService.offlineQueueBox.length;
  }

  /// Check if queue has items
  bool hasQueuedItems() {
    return HiveService.offlineQueueBox.isNotEmpty;
  }

  /// Remove a specific queued item by key
  Future<void> removeQueuedItem(String key) async {
    await HiveService.offlineQueueBox.delete(key);
  }

  /// Clear all queued items
  Future<void> clearQueue() async {
    await HiveService.offlineQueueBox.clear();
  }

  /// Get all queued activity completions
  List<Map<String, dynamic>> getQueuedActivityCompletions() {
    return HiveService.offlineQueueBox.values
        .map((item) => Map<String, dynamic>.from(item))
        .where((item) => item['type'] == _typeActivityCompletion)
        .toList();
  }

  /// Get queue keys (for removal after sync)
  List<String> getQueueKeys() {
    return HiveService.offlineQueueBox.keys.cast<String>().toList();
  }

  /// Get queue item by key
  Map<String, dynamic>? getQueueItem(String key) {
    final item = HiveService.offlineQueueBox.get(key);
    if (item == null) return null;
    return Map<String, dynamic>.from(item);
  }
}
