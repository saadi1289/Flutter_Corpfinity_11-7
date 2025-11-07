/// Example usage of the local storage system
/// 
/// This file demonstrates how to use the Hive-based local storage
/// for caching activities, managing offline queue, and syncing data.
library;

import '../models/models.dart';
import '../repositories/local_storage_repository.dart';
import 'data_sync_service.dart';

/// Example: Basic usage of LocalStorageRepository
void exampleBasicUsage() async {
  final repository = LocalStorageRepository();

  // ==================== User Operations ====================
  
  // Save user
  final user = User(
    id: 'user123',
    email: 'user@example.com',
    name: 'John Doe',
    company: 'Corpfinity',
    wellnessGoals: ['Stress Reduction', 'Better Sleep'],
    notifications: const NotificationPreferences(
      enabled: true,
      dailyReminders: true,
      achievementAlerts: true,
    ),
    totalPoints: 100,
    createdAt: DateTime.now(),
  );
  await repository.saveUser(user);

  // Get current user
  final currentUser = repository.getCurrentUser();
  print('Current user: ${currentUser?.name}');

  // ==================== Activity Caching ====================
  
  // Cache activities (typically done after fetching from API)
  final activities = <Activity>[
    Activity(
      id: 'act1',
      name: 'Deep Breathing',
      description: 'A calming breathing exercise',
      pillarId: 'stress',
      durationMinutes: 3,
      difficulty: Difficulty.low,
      location: 'Anywhere',
      thumbnailUrl: 'https://example.com/image.jpg',
      steps: [],
      tags: ['breathing', 'relaxation'],
    ),
  ];
  await repository.cacheActivities(activities);

  // Check if cache is valid (less than 24 hours old)
  final isCacheValid = repository.isActivitiesCacheValid();
  print('Cache valid: $isCacheValid');

  // Get cached activities
  final cachedActivities = repository.getCachedActivities();
  print('Cached activities: ${cachedActivities.length}');

  // Get activity by ID
  final activity = repository.getActivityById('act1');
  print('Activity: ${activity?.name}');

  // Search activities
  final searchResults = repository.searchActivities('breathing');
  print('Search results: ${searchResults.length}');

  // ==================== Offline Queue ====================
  
  // Queue activity completion when offline
  await repository.queueActivityCompletion(
    activityId: 'act1',
    activityName: 'Deep Breathing',
    completedAt: DateTime.now(),
    pointsEarned: 10,
  );

  // Check queued items
  final queuedCount = repository.getQueuedItemsCount();
  print('Queued items: $queuedCount');

  // ==================== Progress Operations ====================
  
  // Save progress
  final progress = UserProgress(
    userId: 'user123',
    currentStreak: 5,
    longestStreak: 10,
    totalActivitiesCompleted: 25,
    weeklyGoalProgress: 0.7,
    completedDays: [DateTime.now()],
    earnedBadges: [],
    recentHistory: [],
  );
  await repository.saveProgress(progress);

  // Get progress
  final userProgress = repository.getProgress('user123');
  print('Current streak: ${userProgress?.currentStreak}');

  // ==================== Sync Operations ====================
  
  // Check if sync is needed
  final needsSync = repository.needsSync();
  print('Needs sync: $needsSync');

  // Get sync status
  final syncStatus = repository.getSyncStatus();
  print('Sync status: $syncStatus');
}

/// Example: Setting up DataSyncService with callbacks
void exampleSyncServiceSetup() {
  final syncService = DataSyncService(
    // Callback for syncing activity completions to backend
    onSyncActivityCompletion: (item) async {
      // Implement your API call here
      // Example:
      // final response = await apiService.completeActivity(
      //   activityId: item['activityId'],
      //   completedAt: DateTime.parse(item['completedAt']),
      // );
      // return response.success;
      
      print('Syncing activity: ${item['activityId']}');
      return true; // Return true if sync successful
    },
    
    // Callback for fetching activities from backend
    onFetchActivities: () async {
      // Implement your API call here
      // Example:
      // final response = await apiService.getActivities();
      // return response.data;
      
      print('Fetching activities from backend');
      return []; // Return list of activities
    },
  );

  // Perform sync
  syncService.syncAll().then((result) {
    print('Sync result: $result');
  });
}

/// Example: Complete workflow - Activity completion with offline support
void exampleActivityCompletionWorkflow() async {
  final repository = LocalStorageRepository();
  
  // User completes an activity
  final activityId = 'act1';
  final activityName = 'Deep Breathing';
  final completedAt = DateTime.now();
  final pointsEarned = 10;

  // Try to sync immediately (if online)
  bool syncedImmediately = false;
  try {
    // Attempt to call backend API
    // final success = await apiService.completeActivity(...);
    // syncedImmediately = success;
  } catch (e) {
    print('Failed to sync immediately, queuing for later: $e');
  }

  // If not synced immediately, queue for offline sync
  if (!syncedImmediately) {
    await repository.queueActivityCompletion(
      activityId: activityId,
      activityName: activityName,
      completedAt: completedAt,
      pointsEarned: pointsEarned,
    );
  }

  // Update local progress immediately for better UX
  final user = repository.getCurrentUser();
  if (user != null) {
    final progress = repository.getProgress(user.id);
    if (progress != null) {
      // Update streak, add completed day, etc.
      await repository.addCompletedDay(user.id, completedAt);
    }
  }

  // Later, when app comes online, sync queued items
  if (repository.hasQueuedItems()) {
    final syncResult = await repository.syncAll();
    print('Sync completed: ${syncResult.activityCompletionsSynced} items synced');
  }
}

/// Example: Cache refresh workflow
void exampleCacheRefreshWorkflow() async {
  final repository = LocalStorageRepository();

  // Check if cache needs refresh
  if (!repository.isActivitiesCacheValid()) {
    print('Cache expired, fetching fresh data...');
    
    // Fetch from API
    // final activities = await apiService.getActivities();
    
    // Cache the fresh data
    // await repository.cacheActivities(activities);
    
    print('Cache refreshed successfully');
  } else {
    print('Using cached data');
    final activities = repository.getCachedActivities();
    print('Loaded ${activities.length} activities from cache');
  }
}

/// Example: Cleanup on logout
void exampleLogoutCleanup() async {
  final repository = LocalStorageRepository();

  // Clear all local data on logout
  await repository.clearAll();
  
  print('All local data cleared');
}
