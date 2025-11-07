import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'performance.dart';

/// Performance testing utilities for development and debugging
class PerformanceTest {
  /// Tests widget build performance
  static Future<void> testWidgetBuildPerformance(
    String widgetName,
    Widget Function() builder, {
    int iterations = 100,
  }) async {
    if (!kDebugMode) return;

    final buildTimes = <int>[];
    
    for (int i = 0; i < iterations; i++) {
      final stopwatch = Stopwatch()..start();
      builder();
      stopwatch.stop();
      buildTimes.add(stopwatch.elapsedMicroseconds);
    }

    final avgTime = buildTimes.reduce((a, b) => a + b) / buildTimes.length;
    final maxTime = buildTimes.reduce((a, b) => a > b ? a : b);
    final minTime = buildTimes.reduce((a, b) => a < b ? a : b);

    debugPrint('📊 $widgetName Build Performance:');
    debugPrint('   Average: ${avgTime.toStringAsFixed(2)}μs');
    debugPrint('   Min: $minTimeμs');
    debugPrint('   Max: $maxTimeμs');
    debugPrint('   Iterations: $iterations');
  }

  /// Tests list scroll performance
  static void testScrollPerformance(ScrollController controller) {
    if (!kDebugMode) return;

    int frameCount = 0;
    final stopwatch = Stopwatch()..start();

    controller.addListener(() {
      frameCount++;
      if (stopwatch.elapsedMilliseconds > 1000) {
        final fps = frameCount / (stopwatch.elapsedMilliseconds / 1000);
        debugPrint('📊 Scroll FPS: ${fps.toStringAsFixed(1)}');
        frameCount = 0;
        stopwatch.reset();
        stopwatch.start();
      }
    });
  }

  /// Tests image loading performance
  static Future<void> testImageLoadPerformance(
    List<String> imageUrls,
    BuildContext context,
  ) async {
    if (!kDebugMode) return;

    debugPrint('📊 Testing image load performance for ${imageUrls.length} images');
    
    final stopwatch = Stopwatch()..start();
    await PerformanceUtils.precacheImages(context, imageUrls);
    stopwatch.stop();

    final avgTime = stopwatch.elapsedMilliseconds / imageUrls.length;
    debugPrint('📊 Image Loading:');
    debugPrint('   Total: ${stopwatch.elapsedMilliseconds}ms');
    debugPrint('   Average per image: ${avgTime.toStringAsFixed(2)}ms');
  }

  /// Tests state update performance
  static void testStateUpdatePerformance(
    String stateName,
    VoidCallback updateState, {
    int iterations = 1000,
  }) {
    if (!kDebugMode) return;

    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < iterations; i++) {
      updateState();
    }
    stopwatch.stop();

    final avgTime = stopwatch.elapsedMicroseconds / iterations;
    debugPrint('📊 $stateName State Update Performance:');
    debugPrint('   Average: ${avgTime.toStringAsFixed(2)}μs');
    debugPrint('   Total: ${stopwatch.elapsedMilliseconds}ms');
    debugPrint('   Iterations: $iterations');
  }

  /// Generates a performance report
  static String generatePerformanceReport({
    required int launchTimeMs,
    required double avgFps,
    required int memoryUsageMb,
    required int cachedImagesCount,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('📊 Performance Report');
    buffer.writeln('═══════════════════════════════════');
    buffer.writeln('Launch Time: ${launchTimeMs}ms ${launchTimeMs < 2000 ? "✅" : "⚠️"}');
    buffer.writeln('Average FPS: ${avgFps.toStringAsFixed(1)} ${avgFps >= 55 ? "✅" : "⚠️"}');
    buffer.writeln('Memory Usage: ${memoryUsageMb}MB ${memoryUsageMb < 150 ? "✅" : "⚠️"}');
    buffer.writeln('Cached Images: $cachedImagesCount');
    buffer.writeln('═══════════════════════════════════');
    
    return buffer.toString();
  }

  /// Checks if performance targets are met
  static Map<String, bool> checkPerformanceTargets({
    required int launchTimeMs,
    required double avgFps,
    required int memoryUsageMb,
  }) {
    return {
      'launchTime': launchTimeMs < 2000,
      'fps': avgFps >= 55,
      'memory': memoryUsageMb < 150,
    };
  }

  /// Simulates heavy load to test performance under stress
  static Future<void> stressTest({
    required VoidCallback operation,
    int iterations = 100,
    Duration delay = const Duration(milliseconds: 10),
  }) async {
    if (!kDebugMode) return;

    debugPrint('🔥 Starting stress test with $iterations iterations');
    final stopwatch = Stopwatch()..start();
    
    for (int i = 0; i < iterations; i++) {
      operation();
      await Future.delayed(delay);
    }
    
    stopwatch.stop();
    debugPrint('🔥 Stress test completed in ${stopwatch.elapsedMilliseconds}ms');
  }

  // Track object counts for memory leak detection
  static final Map<String, List<int>> _objectCounts = {};

  /// Monitors memory leaks by tracking object counts
  static void monitorMemoryLeaks(String objectName, int currentCount) {
    if (!kDebugMode) return;

    // Simple leak detection: warn if count keeps growing
    _objectCounts.putIfAbsent(objectName, () => []);
    _objectCounts[objectName]!.add(currentCount);

    if (_objectCounts[objectName]!.length > 10) {
      final recent = _objectCounts[objectName]!.sublist(
        _objectCounts[objectName]!.length - 10,
      );
      final isGrowing = recent.last > recent.first * 1.5;
      
      if (isGrowing) {
        debugPrint('⚠️ Potential memory leak detected: $objectName');
        debugPrint('   Count growing: ${recent.first} → ${recent.last}');
      }
    }
  }
}

/// Widget for displaying performance overlay in debug mode
class PerformanceOverlay extends StatelessWidget {
  final Widget child;
  final bool showFps;
  final bool showMemory;

  const PerformanceOverlay({
    super.key,
    required this.child,
    this.showFps = true,
    this.showMemory = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return child;
    }

    return Stack(
      children: [
        child,
        if (showFps || showMemory)
          Positioned(
            top: 50,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showFps)
                    const Text(
                      'FPS: Monitoring...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  if (showMemory)
                    const Text(
                      'Memory: Monitoring...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
