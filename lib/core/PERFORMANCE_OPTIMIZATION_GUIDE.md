# Performance Optimization Guide

This document outlines the performance optimizations implemented in the Corpfinity Employee App.

## Implemented Optimizations

### 1. Image Loading Optimization

**Package**: `cached_network_image: ^3.3.1`

**Implementation**:
- Replaced `Image.network()` with `CachedNetworkImage` in `ActivityCard` widget
- Added memory cache width limits (400px for grid, 800px for list)
- Added disk cache limits to reduce storage usage
- Implemented loading placeholders and error widgets

**Benefits**:
- Images are cached in memory and disk
- Reduces network requests for repeated image loads
- Improves scroll performance in activity lists
- Reduces data usage for users

**Usage Example**:
```dart
CachedNetworkImage(
  imageUrl: thumbnailUrl,
  fit: BoxFit.cover,
  placeholder: (context, url) => LoadingWidget(),
  errorWidget: (context, url, error) => ErrorWidget(),
  memCacheWidth: 400,
  maxWidthDiskCache: 400,
)
```

### 2. Const Constructors

**Implementation**:
- Added `const` constructors to all stateless widgets where possible
- Added `super.key` to widget constructors
- Used `const` for widget instantiation where values are compile-time constants

**Benefits**:
- Reduces widget rebuilds
- Improves memory efficiency
- Faster widget tree construction

**Examples**:
- `CustomButton` - const constructor
- `CustomCard` - const constructor
- `_NavBarItem` - const constructor with keys

### 3. Performance Monitoring Utilities

**File**: `lib/core/utils/performance.dart`

**Features**:
- App launch time tracking (target: <2 seconds)
- Frame performance monitoring (60 FPS target)
- Build time measurement for widgets
- Memory usage logging
- Debounce and throttle utilities

**Usage**:
```dart
// Measure async operations
await PerformanceUtils.measureAsync('Fetch Activities', () async {
  return await repository.getActivities();
});

// Monitor widget builds
class MyWidget extends StatefulWidget {
  // ...
}

class _MyWidgetState extends State<MyWidget> with PerformanceMonitorMixin {
  @override
  Widget buildWithMonitoring(BuildContext context) {
    // Your build logic
  }
}
```

### 4. State Management Optimization

**Implementation**:
- Added equality operators (`==` and `hashCode`) to state classes
- Prevents unnecessary rebuilds when state hasn't actually changed
- Implemented in `HomeState` and should be added to other state classes

**Benefits**:
- Reduces unnecessary widget rebuilds
- Improves UI responsiveness
- Better battery life

**Example**:
```dart
class HomeState {
  // ... fields

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeState &&
        other.userName == userName &&
        other.currentStreak == currentStreak;
        // ... other fields
  }

  @override
  int get hashCode => Object.hash(userName, currentStreak, ...);
}
```

### 5. Build Method Optimization

**Best Practices Implemented**:
- Use `const` widgets wherever possible
- Extract complex widgets into separate classes
- Use `RepaintBoundary` for expensive widgets
- Minimize widget tree depth
- Use `ListView.builder` instead of `ListView` for long lists

**Example**:
```dart
// Good: Extracted widget with const constructor
class _NavBarItem extends StatelessWidget {
  const _NavBarItem({super.key, ...});
  
  @override
  Widget build(BuildContext context) {
    return const Icon(...); // const where possible
  }
}
```

### 6. Animation Optimization

**Implementation**:
- Respect system animation settings
- Use `AnimationController` with proper disposal
- Implement `SingleTickerProviderStateMixin` for single animations
- Use `TickerProviderStateMixin` for multiple animations

**Utilities**:
```dart
// Check if animations should be reduced
if (PerformanceUtils.shouldReduceAnimations(context)) {
  // Skip or simplify animation
}

// Get optimized duration
final duration = PerformanceUtils.getAnimationDuration(
  context,
  const Duration(milliseconds: 300),
);
```

### 7. Launch Time Optimization

**Target**: < 2 seconds from app start to first frame

**Optimizations**:
- Lazy initialization of services
- Deferred loading of non-critical resources
- Optimized splash screen
- Minimal work in `main()` function

**Monitoring**:
```dart
// Automatically tracked in main.dart
PerformanceUtils.checkLaunchTime(appStartTime);
```

## Performance Targets

### Frame Rate
- **Target**: 60 FPS (16ms per frame)
- **Monitoring**: Automatic in debug mode
- **Action**: Optimize widgets that take >16ms to build

### Memory Usage
- **Target**: < 150MB average
- **Monitoring**: Manual profiling with Flutter DevTools
- **Action**: Review image caching, dispose controllers properly

### App Launch Time
- **Target**: < 2 seconds
- **Monitoring**: Automatic in debug mode
- **Action**: Defer non-critical initialization

### Network Performance
- **Target**: < 500ms for cached data
- **Monitoring**: Use `PerformanceUtils.measureAsync()`
- **Action**: Implement proper caching strategies

## Testing Performance

### Using Flutter DevTools

1. **Performance Overlay**:
   ```dart
   MaterialApp(
     showPerformanceOverlay: true,
     // ...
   );
   ```

2. **Timeline View**:
   - Open Flutter DevTools
   - Navigate to Performance tab
   - Record timeline during interactions
   - Look for jank (frames > 16ms)

3. **Memory View**:
   - Monitor memory allocation
   - Check for memory leaks
   - Verify proper disposal of resources

### Manual Testing

1. **Scroll Performance**:
   - Test activity lists with many items
   - Verify smooth 60 FPS scrolling
   - Check image loading performance

2. **Navigation Performance**:
   - Test screen transitions
   - Verify animation smoothness
   - Check for stuttering

3. **Launch Time**:
   - Cold start: App not in memory
   - Warm start: App in background
   - Hot reload: Development only

## Common Performance Issues

### Issue: Slow Scrolling

**Causes**:
- Heavy build methods
- Synchronous image loading
- Too many widgets in tree

**Solutions**:
- Use `ListView.builder` with `itemExtent`
- Implement `CachedNetworkImage`
- Add `RepaintBoundary` to list items
- Use `const` constructors

### Issue: Jank During Animations

**Causes**:
- Expensive operations during animation
- Too many simultaneous animations
- Heavy widget rebuilds

**Solutions**:
- Use `AnimationController` properly
- Implement `RepaintBoundary`
- Reduce widget tree complexity
- Use `Opacity` widget sparingly

### Issue: High Memory Usage

**Causes**:
- Image cache too large
- Memory leaks (undisposed controllers)
- Too many cached widgets

**Solutions**:
- Set `memCacheWidth` and `maxWidthDiskCache`
- Dispose controllers in `dispose()`
- Clear caches when appropriate
- Use `AutomaticKeepAliveClientMixin` selectively

### Issue: Slow App Launch

**Causes**:
- Too much work in `main()`
- Synchronous initialization
- Large asset loading

**Solutions**:
- Defer non-critical initialization
- Use async initialization
- Lazy load resources
- Optimize splash screen

## Best Practices

1. **Always use const constructors** when widget properties are compile-time constants
2. **Dispose resources** properly (controllers, streams, listeners)
3. **Use builders** for long lists (`ListView.builder`, `GridView.builder`)
4. **Cache expensive computations** using memoization
5. **Profile regularly** using Flutter DevTools
6. **Test on real devices** especially low-end devices
7. **Monitor frame rate** during development
8. **Optimize images** before adding to assets
9. **Use RepaintBoundary** for complex, static widgets
10. **Implement proper state management** to minimize rebuilds

## Future Optimizations

### Planned Improvements

1. **Code Splitting**: Implement deferred loading for features
2. **Image Optimization**: Implement WebP format support
3. **Background Processing**: Move heavy computations to isolates
4. **Predictive Caching**: Preload likely-to-be-viewed content
5. **Network Optimization**: Implement request batching and compression

### Monitoring and Analytics

1. **Performance Metrics**: Track real-world performance data
2. **Crash Reporting**: Implement Firebase Crashlytics
3. **User Experience Metrics**: Track time-to-interactive
4. **Network Metrics**: Monitor API response times

## Resources

- [Flutter Performance Best Practices](https://flutter.dev/docs/perf/best-practices)
- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools/overview)
- [Optimizing Performance](https://flutter.dev/docs/perf/rendering-performance)
- [Memory Management](https://flutter.dev/docs/perf/memory)

## Conclusion

Performance optimization is an ongoing process. Regular profiling and testing on real devices is essential to maintain a smooth user experience. Use the tools and utilities provided in this guide to identify and fix performance issues as they arise.
