import 'package:hive_flutter/hive_flutter.dart';
import '../models/models.dart';

/// Service for managing Hive database initialization and operations
class HiveService {
  static const String _userBox = 'user_box';
  static const String _activitiesBox = 'activities_box';
  static const String _progressBox = 'progress_box';
  static const String _offlineQueueBox = 'offline_queue_box';
  static const String _cacheMetadataBox = 'cache_metadata_box';

  /// Initialize Hive and register all type adapters
  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Register type adapters
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(NotificationPreferencesAdapter());
    Hive.registerAdapter(ActivityAdapter());
    Hive.registerAdapter(ActivityStepAdapter());
    Hive.registerAdapter(UserProgressAdapter());
    Hive.registerAdapter(BadgeAdapter());
    Hive.registerAdapter(CompletedActivityAdapter());
    Hive.registerAdapter(EnergyLevelAdapter());
    Hive.registerAdapter(DifficultyAdapter());
    Hive.registerAdapter(SSOProviderAdapter());

    // Open boxes
    await Hive.openBox<User>(_userBox);
    await Hive.openBox<Activity>(_activitiesBox);
    await Hive.openBox<UserProgress>(_progressBox);
    await Hive.openBox<Map>(_offlineQueueBox);
    await Hive.openBox<Map>(_cacheMetadataBox);
  }

  /// Get user box
  static Box<User> get userBox => Hive.box<User>(_userBox);

  /// Get activities box
  static Box<Activity> get activitiesBox => Hive.box<Activity>(_activitiesBox);

  /// Get progress box
  static Box<UserProgress> get progressBox => Hive.box<UserProgress>(_progressBox);

  /// Get offline queue box
  static Box<Map> get offlineQueueBox => Hive.box<Map>(_offlineQueueBox);

  /// Get cache metadata box
  static Box<Map> get cacheMetadataBox => Hive.box<Map>(_cacheMetadataBox);

  /// Close all boxes
  static Future<void> closeAll() async {
    await Hive.close();
  }

  /// Clear all data (for logout or reset)
  static Future<void> clearAll() async {
    await userBox.clear();
    await activitiesBox.clear();
    await progressBox.clear();
    await offlineQueueBox.clear();
    await cacheMetadataBox.clear();
  }
}
