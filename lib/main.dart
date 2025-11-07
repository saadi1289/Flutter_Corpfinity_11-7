import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'data/services/storage_initializer.dart';
import 'core/utils/performance.dart';

void main() async {
  // Track app start time for performance monitoring
  final appStartTime = DateTime.now();
  
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure app-wide error handling
  _configureErrorHandling();
  
  // Initialize local storage (Hive)
  await StorageInitializer.initialize();
  
  // Set preferred orientations (portrait only)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Enable performance monitoring in debug mode
  if (kDebugMode) {
    PerformanceUtils.logFramePerformance();
    PerformanceUtils.logMemoryUsage();
  }
  
  // Run the app with error boundary
  runApp(const CorpfinityApp());
  
  // Check launch time after first frame
  WidgetsBinding.instance.addPostFrameCallback((_) {
    PerformanceUtils.checkLaunchTime(appStartTime);
  });
}

/// Configures global error handling for the application
void _configureErrorHandling() {
  // Handle Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    
    // Log error in debug mode
    if (kDebugMode) {
      debugPrint('Flutter Error: ${details.exception}');
      debugPrint('Stack trace: ${details.stack}');
    }
    
    // In production, you would send this to a crash reporting service
    // Example: FirebaseCrashlytics.instance.recordFlutterError(details);
  };

  // Handle errors outside of Flutter framework (async errors)
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      debugPrint('Async Error: $error');
      debugPrint('Stack trace: $stack');
    }
    
    // In production, you would send this to a crash reporting service
    // Example: FirebaseCrashlytics.instance.recordError(error, stack);
    
    return true; // Indicates error was handled
  };

  // Customize error widget for release mode
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Something went wrong',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  kDebugMode
                      ? details.exception.toString()
                      : 'We\'re sorry for the inconvenience. Please restart the app.',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  };
}
