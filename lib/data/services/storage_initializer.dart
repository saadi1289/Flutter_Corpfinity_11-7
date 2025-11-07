import 'package:flutter/foundation.dart';
import 'hive_service.dart';

/// Helper class to initialize storage services
class StorageInitializer {
  static bool _initialized = false;

  /// Initialize all storage services
  /// Should be called once at app startup before runApp()
  static Future<void> initialize() async {
    if (_initialized) {
      debugPrint('Storage already initialized');
      return;
    }

    try {
      // Initialize Hive
      await HiveService.initialize();
      
      _initialized = true;
      debugPrint('Storage initialization completed successfully');
    } catch (e) {
      debugPrint('Storage initialization failed: $e');
      rethrow;
    }
  }

  /// Check if storage is initialized
  static bool get isInitialized => _initialized;

  /// Close all storage services
  /// Should be called when app is closing
  static Future<void> close() async {
    if (!_initialized) return;

    try {
      await HiveService.closeAll();
      _initialized = false;
      debugPrint('Storage closed successfully');
    } catch (e) {
      debugPrint('Error closing storage: $e');
      rethrow;
    }
  }
}
