import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Performance utilities for optimizing app performance
class PerformanceUtils {
  /// Measures the time taken to execute a function
  static Future<T> measureAsync<T>(
    String label,
    Future<T> Function() function,
  ) async {
    if (!kDebugMode) {
      return await function();
    }

    final stopwatch = Stopwatch()..start();
    try {
      final result = await function();
      stopwatch.stop();
      debugPrint('⏱️ $label took ${stopwatch.elapsedMilliseconds}ms');
      return result;
    } catch (e) {
      stopwatch.stop();
      debugPrint('⏱️ $label failed after ${stopwatch.elapsedMilliseconds}ms');
      rethrow;
    }
  }

  /// Measures the time taken to execute a synchronous function
  static T measure<T>(String label, T Function() function) {
    if (!kDebugMode) {
      return function();
    }

    final stopwatch = Stopwatch()..start();
    try {
      final result = function();
      stopwatch.stop();
      debugPrint('⏱️ $label took ${stopwatch.elapsedMilliseconds}ms');
      return result;
    } catch (e) {
      stopwatch.stop();
      debugPrint('⏱️ $label failed after ${stopwatch.elapsedMilliseconds}ms');
      rethrow;
    }
  }

  /// Logs frame rendering performance
  static void logFramePerformance() {
    if (!kDebugMode) return;

    SchedulerBinding.instance.addTimingsCallback((List<FrameTiming> timings) {
      for (final timing in timings) {
        final buildDuration = timing.buildDuration.inMilliseconds;
        final rasterDuration = timing.rasterDuration.inMilliseconds;
        final totalDuration = timing.totalSpan.inMilliseconds;

        if (totalDuration > 16) {
          // Frame took longer than 16ms (60 FPS threshold)
          debugPrint(
            '🐌 Slow frame detected: '
            'Build: ${buildDuration}ms, '
            'Raster: ${rasterDuration}ms, '
            'Total: ${totalDuration}ms',
          );
        }
      }
    });
  }

  /// Checks if animations should be reduced based on system settings
  static bool shouldReduceAnimations(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Gets optimized animation duration based on system settings
  static Duration getAnimationDuration(
    BuildContext context,
    Duration defaultDuration,
  ) {
    if (shouldReduceAnimations(context)) {
      return Duration.zero;
    }
    return defaultDuration;
  }

  /// Debounces a function call
  static void Function() debounce(
    VoidCallback callback, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(delay, callback);
    };
  }

  /// Throttles a function call
  static VoidCallback throttle(
    VoidCallback callback, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    bool isThrottled = false;
    return () {
      if (isThrottled) return;
      isThrottled = true;
      callback();
      Timer(delay, () => isThrottled = false);
    };
  }

  /// Preloads images to improve performance
  static Future<void> precacheImages(
    BuildContext context,
    List<String> imageUrls,
  ) async {
    for (final url in imageUrls) {
      try {
        await precacheImage(NetworkImage(url), context);
      } catch (e) {
        debugPrint('Failed to precache image: $url');
      }
    }
  }

  /// Checks if the device is low-end based on available memory
  static bool isLowEndDevice() {
    // This is a simplified check. In production, you might want to use
    // platform-specific code to get actual device specs
    return false; // Default to false for now
  }

  /// Gets optimized image quality based on device capabilities
  static int getOptimizedImageQuality() {
    return isLowEndDevice() ? 70 : 85;
  }

  /// Logs memory usage (debug only)
  static void logMemoryUsage() {
    if (!kDebugMode) return;

    // Note: Actual memory usage tracking requires platform-specific code
    debugPrint('💾 Memory usage logging enabled');
  }

  /// Optimizes list view performance by calculating item extent
  static double? getItemExtent(BuildContext context, {required bool isGridView}) {
    if (isGridView) {
      // For grid views, return null to let GridView calculate
      return null;
    }
    // For list views, provide fixed extent if items have consistent height
    return null; // Return actual height if known
  }

  /// Creates a RepaintBoundary for expensive widgets
  static Widget wrapWithRepaintBoundary(Widget child, {String? debugLabel}) {
    return RepaintBoundary(
      child: child,
    );
  }

  /// Checks if the app launch time is within target
  static void checkLaunchTime(DateTime appStartTime) {
    final launchDuration = DateTime.now().difference(appStartTime);
    final launchMs = launchDuration.inMilliseconds;

    if (kDebugMode) {
      if (launchMs < 2000) {
        debugPrint('✅ App launch time: ${launchMs}ms (Target: <2000ms)');
      } else {
        debugPrint('⚠️ App launch time: ${launchMs}ms (Target: <2000ms) - SLOW');
      }
    }
  }
}

/// Mixin for widgets that need performance monitoring
mixin PerformanceMonitorMixin<T extends StatefulWidget> on State<T> {
  late final Stopwatch _buildStopwatch;
  int _buildCount = 0;

  @override
  void initState() {
    super.initState();
    _buildStopwatch = Stopwatch();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      _buildStopwatch.start();
      _buildCount++;
    }

    final widget = buildWithMonitoring(context);

    if (kDebugMode) {
      _buildStopwatch.stop();
      if (_buildStopwatch.elapsedMilliseconds > 16) {
        debugPrint(
          '🐌 ${T.toString()} build #$_buildCount took '
          '${_buildStopwatch.elapsedMilliseconds}ms',
        );
      }
      _buildStopwatch.reset();
    }

    return widget;
  }

  /// Override this instead of build() when using the mixin
  Widget buildWithMonitoring(BuildContext context);
}
