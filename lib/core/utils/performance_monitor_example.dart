import 'package:flutter/material.dart';
import 'performance_monitor.dart';

/// Example usage of PerformanceMonitor
/// 
/// This demonstrates how to use the PerformanceMonitor utility
/// to track FPS and automatically adjust animation complexity.
class PerformanceMonitorExample extends StatefulWidget {
  const PerformanceMonitorExample({super.key});

  @override
  State<PerformanceMonitorExample> createState() => _PerformanceMonitorExampleState();
}

class _PerformanceMonitorExampleState extends State<PerformanceMonitorExample> {
  late PerformanceMonitor _monitor;
  int _currentFps = 60;
  bool _shouldReduceAnimations = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize performance monitor
    _monitor = PerformanceMonitor();
    
    // Set up callback for animation complexity changes
    _monitor.onAnimationComplexityChanged = (shouldReduce) {
      setState(() {
        _shouldReduceAnimations = shouldReduce;
      });
      debugPrint('Animation complexity changed: shouldReduce=$shouldReduce');
    };
    
    // Listen to FPS stream
    _monitor.currentFpsStream.listen((fps) {
      setState(() {
        _currentFps = fps;
      });
    });
    
    // Start monitoring
    _monitor.startMonitoring();
  }

  @override
  void dispose() {
    _monitor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Monitor Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current FPS: $_currentFps',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Should Reduce Animations: $_shouldReduceAnimations',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Simulate low FPS
                _monitor.adjustAnimationComplexity(50);
              },
              child: const Text('Simulate Low FPS (50)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Simulate normal FPS
                _monitor.adjustAnimationComplexity(60);
              },
              child: const Text('Simulate Normal FPS (60)'),
            ),
          ],
        ),
      ),
    );
  }
}
