# Local Storage Implementation with Hive

This directory contains the implementation of local data storage using Hive for the Corpfinity Employee App.

## Overview

The local storage system provides:
- **Persistent data storage** for user data, activities, and progress
- **24-hour activity caching** to reduce API calls and improve performance
- **Offline queue** for activity completions when the device is offline
- **Data synchronization** when the app comes back online

## Architecture

```
┌─────────────────────────────────────────┐
│   LocalStorageRepository                │
│   (Main interface for storage ops)      │
└─────────────────────────────────────────┘
              │
              ├──────────────────────────────┐
              │                              │
┌─────────────▼──────────┐    ┌─────────────▼──────────┐
│  LocalCacheService     │    │  OfflineQueueService   │
│  (24-hour caching)     │    │  (Queue completions)   │
└────────────────────────┘    └────────────────────────┘
              │                              │
              └──────────────┬───────────────┘
                             │
                  ┌──────────▼──────────┐
                  │  DataSyncService    │
                  │  (Sync when online) │
                  └─────────────────────┘
                             │
                  ┌──────────▼──────────┐
                  │    HiveService      │
                  │  (Core Hive setup)  │
                  └─────────────────────┘
```

## Components

### 1. HiveService
**File:** `hive_service.dart`

Core service for Hive initialization and box management.

**Responsibilities:**
- Initialize Hive with Flutter
- Register all type adapters
- Open and manage Hive boxes
- Provide access to boxes

**Boxes:**
- `user_box` - Stores current user data
- `activities_box` - Caches activities
- `progress_box` - Stores user progress
- `offline_queue_box` - Queues offline operations
- `cache_metadata_box` - Stores cache timestamps

### 2. LocalCacheService
**File:** `local_cache_service.dart`

Manages activity caching with 24-hour expiration.

**Key Features:**
- Cache validation (24-hour TTL)
- Activity storage and retrieval
- Search and filter capabilities
- Cache metadata tracking

**Methods:**
- `isCacheValid()` - Check if cache is less than 24 hours old
- `cacheActivities(activities)` - Store activities with timestamp
- `getCachedActivities()` - Retrieve all cached activities
- `getCachedActivity(id)` - Get specific activity by ID
- `searchCachedActivities(query)` - Search activities by name/tags

### 3. OfflineQueueService
**File:** `offline_queue_service.dart`

Manages queue of operations to sync when online.

**Key Features:**
- Queue activity completions
- Maintain order with timestamps
- Retrieve and remove queued items

**Methods:**
- `queueActivityCompletion(...)` - Add completion to queue
- `getQueuedItems()` - Get all queued items
- `hasQueuedItems()` - Check if queue has items
- `removeQueuedItem(key)` - Remove item after successful sync

### 4. DataSyncService
**File:** `data_sync_service.dart`

Handles synchronization of local data with backend.

**Key Features:**
- Sync queued activity completions
- Refresh activities cache
- Configurable sync callbacks
- Sync status reporting

**Methods:**
- `syncAll()` - Sync all pending data
- `needsSync()` - Check if sync is needed
- `getSyncStatus()` - Get current sync status

**Callbacks:**
- `onSyncActivityCompletion` - Called to sync each queued completion
- `onFetchActivities` - Called to fetch fresh activities

### 5. LocalStorageRepository
**File:** `local_storage_repository.dart`

Main interface for all storage operations.

**Key Features:**
- Unified API for all storage operations
- User data management
- Activity caching
- Progress tracking
- Offline queue management
- Data synchronization

**Usage Example:**
```dart
final repository = LocalStorageRepository();

// Save user
await repository.saveUser(user);

// Cache activities
await repository.cacheActivities(activities);

// Queue offline completion
await repository.queueActivityCompletion(
  activityId: 'act1',
  activityName: 'Deep Breathing',
  completedAt: DateTime.now(),
  pointsEarned: 10,
);

// Sync when online
final result = await repository.syncAll();
```

## Type Adapters

All models have Hive type adapters for serialization:

| Model | Type ID | File |
|-------|---------|------|
| User | 0 | user.g.dart |
| NotificationPreferences | 1 | notification_preferences.g.dart |
| Activity | 2 | activity.g.dart |
| ActivityStep | 3 | activity_step.g.dart |
| UserProgress | 4 | user_progress.g.dart |
| Badge | 5 | badge.g.dart |
| CompletedActivity | 6 | completed_activity.g.dart |
| EnergyLevel | 7 | enums.g.dart |
| Difficulty | 8 | enums.g.dart |
| SSOProvider | 9 | enums.g.dart |

## Initialization

The storage system is initialized in `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local storage
  await StorageInitializer.initialize();
  
  runApp(const CorpfinityApp());
}
```

## Usage Patterns

### Pattern 1: Activity Completion with Offline Support

```dart
// When user completes an activity
final repository = LocalStorageRepository();

try {
  // Try to sync immediately
  await apiService.completeActivity(activityId);
} catch (e) {
  // If offline, queue for later
  await repository.queueActivityCompletion(
    activityId: activityId,
    activityName: activityName,
    completedAt: DateTime.now(),
    pointsEarned: 10,
  );
}

// Update local progress immediately
await repository.addCompletedDay(userId, DateTime.now());
```

### Pattern 2: Smart Activity Loading

```dart
final repository = LocalStorageRepository();

List<Activity> activities;

if (repository.isActivitiesCacheValid()) {
  // Use cache if valid
  activities = repository.getCachedActivities();
} else {
  // Fetch from API and cache
  activities = await apiService.getActivities();
  await repository.cacheActivities(activities);
}
```

### Pattern 3: Background Sync

```dart
// When app comes online
final repository = LocalStorageRepository();

if (repository.needsSync()) {
  final result = await repository.syncAll();
  
  if (result.success) {
    print('Synced ${result.activityCompletionsSynced} completions');
  }
}
```

## Testing

See `storage_usage_example.dart` for comprehensive usage examples.

## Performance Considerations

1. **Cache Duration**: 24-hour cache reduces API calls by ~96% for daily users
2. **Offline Queue**: Unlimited queue size, but items are removed after successful sync
3. **Memory Usage**: Hive uses lazy loading, so only accessed data is loaded into memory
4. **Disk Space**: Typical storage < 5MB for 100 activities + user data

## Future Enhancements

- [ ] Add encryption for sensitive user data
- [ ] Implement cache size limits
- [ ] Add cache preloading on app start
- [ ] Implement partial sync for large datasets
- [ ] Add conflict resolution for concurrent updates
- [ ] Implement data compression for large objects

## Requirements Satisfied

This implementation satisfies the following requirements:

- **Requirement 8.5**: Activity completion recording and progress tracking
- **Requirement 9.1**: Progress data persistence and retrieval

## Related Files

- Models: `lib/data/models/*.dart`
- Repositories: `lib/data/repositories/local_storage_repository.dart`
- Services: `lib/data/services/*.dart`
- Initialization: `lib/main.dart`
