import 'dart:async';
import 'package:flutter/scheduler.dart';

/// PerformanceMonitor tracks FPS and automatically adjusts animation complexity
/// to maintain smooth 60fps performance across all devices.
/// 
/// Usage:
/// ```dart
/// final monitor = PerformanceMonitor();
/// monitor.startMonitoring();
/// 
/// // Listen to FPS changes
/// monitor.currentFpsStream.listen((fps) {
///   print('Current FPS: $fps');
/// });
/// 
/// // Check if animations should be reduced
/// if (monitor.shouldReduceAnimations) {
///   // Disable parallax, reduce concurrent animations
/// }
/// ```
class PerformanceMonitor {
  static const int targetFps = 60;
  static const int minAcceptableFps = 55;
  static const int maxConcurrentAnimations = 3;
  
  // Exponential moving average factor for smoothing FPS calculations
  static const double _smoothingFactor = 0.2;
  
  final StreamController<int> _fpsController = StreamController<int>.broadcast();
  final StreamController<bool> _animationComplexityController = 
      StreamController<bool>.broadcast();
  
  double _currentFps = 60.0;
  bool _shouldReduceAnimations = false;
  bool _isMonitoring = false;
  
  // Callback for animation complexity changes
  void Function(bool shouldReduce)? onAnimationComplexityChanged;
  
  /// Stream of current FPS values
  Stream<int> get currentFpsStream => _fpsController.stream;
  
  /// Stream of animation complexity changes
  Stream<bool> get animationComplexityStream => _animationComplexityController.stream;
  
  /// Current FPS value (smoothed using exponential moving average)
  int get currentFps => _currentFps.round();
  
  /// Whether animations should be reduced to maintain performance
  bool get shouldReduceAnimations => _shouldReduceAnimations;
  
  /// Whether the monitor is currently active
  bool get isMonitoring => _isMonitoring;
  
  /// Start monitoring frame performance
  void startMonitoring() {
    if (_isMonitoring) return;
    
    _isMonitoring = true;
    SchedulerBinding.instance.addTimingsCallback(_onFrameTiming);
  }
  
  /// Stop monitoring frame performance
  void stopMonitoring() {
    if (!_isMonitoring) return;
    
    _isMonitoring = false;
    // Note: There's no removeTimingsCallback, so we just set the flag
  }
  
  /// Handle frame timing data from Flutter's scheduler
  void _onFrameTiming(List<FrameTiming> timings) {
    if (!_isMonitoring || timings.isEmpty) return;
    
    // Calculate FPS from frame timings
    for (final timing in timings) {
      final frameDuration = timing.totalSpan.inMicroseconds;
      if (frameDuration > 0) {
        // Calculate instantaneous FPS
        final instantFps = 1000000.0 / frameDuration;
        
        // Apply exponential moving average for smoothing
        _currentFps = (_smoothingFactor * instantFps) + 
                     ((1 - _smoothingFactor) * _currentFps);
        
        // Emit current FPS
        _fpsController.add(_currentFps.round());
        
        // Check if we need to adjust animation complexity
        _checkAndAdjustComplexity();
      }
    }
  }
  
  /// Check current FPS and adjust animation complexity if needed
  void _checkAndAdjustComplexity() {
    final shouldReduce = _currentFps < minAcceptableFps;
    
    if (shouldReduce != _shouldReduceAnimations) {
      _shouldReduceAnimations = shouldReduce;
      _animationComplexityController.add(shouldReduce);
      onAnimationComplexityChanged?.call(shouldReduce);
    }
  }
  
  /// Manually adjust animation complexity based on current FPS
  /// This can be called from external sources if needed
  void adjustAnimationComplexity(int fps) {
    _currentFps = fps.toDouble();
    _checkAndAdjustComplexity();
  }
  
  /// Dispose of resources
  void dispose() {
    stopMonitoring();
    _fpsController.close();
    _animationComplexityController.close();
  }
}
