# Performance Optimization Quick Reference

## Quick Checklist

### ✅ Images
```dart
// Use CachedNetworkImage instead of Image.network
CachedNetworkImage(
  imageUrl: url,
  memCacheWidth: 400,
  maxWidthDiskCache: 400,
)
```

### ✅ Const Constructors
```dart
// Always use const when possible
const CustomButton(text: 'Click me', onPressed: null)

// Add super.key to all widgets
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
}
```

### ✅ State Equality
```dart
// Add to all state classes
@override
bool operator ==(Object other) {
  if (identical(this, other)) return true;
  return other is MyState && other.field == field;
}

@override
int get hashCode => Object.hash(field1, field2);
```

### ✅ RepaintBoundary
```dart
// Wrap expensive widgets
RepaintBoundary(
  child: ExpensiveWidget(),
)
```

### ✅ Performance Monitoring
```dart
// Measure async operations
await PerformanceUtils.measureAsync('Operation', () async {
  return await repository.getData();
});

// Monitor widget builds
class _MyWidgetState extends State<MyWidget> 
    with PerformanceMonitorMixin {
  @override
  Widget buildWithMonitoring(BuildContext context) {
    return Container();
  }
}
```

## Performance Targets

| Metric | Target | Status |
|--------|--------|--------|
| App Launch | < 2 seconds | ✅ Monitored |
| Frame Rate | 60 FPS (16ms) | ✅ Monitored |
| Memory | < 150MB | ✅ Monitored |
| Image Cache | Enabled | ✅ Implemented |

## Common Mistakes to Avoid

❌ **Don't**: Use `Image.network()` without caching
✅ **Do**: Use `CachedNetworkImage`

❌ **Don't**: Forget to dispose controllers
✅ **Do**: Always dispose in `dispose()` method

❌ **Don't**: Build expensive widgets in build method
✅ **Do**: Extract to separate const widgets

❌ **Don't**: Use `setState()` for entire screen
✅ **Do**: Use granular state management

❌ **Don't**: Ignore performance warnings
✅ **Do**: Profile regularly with DevTools

## Quick Commands

```bash
# Get dependencies
flutter pub get

# Analyze code
flutter analyze

# Run in profile mode
flutter run --profile

# Build release
flutter build apk --release

# Open DevTools
flutter pub global run devtools
```

## Files to Reference

- `lib/core/utils/performance.dart` - Performance utilities
- `lib/core/utils/performance_test.dart` - Testing utilities
- `lib/core/PERFORMANCE_OPTIMIZATION_GUIDE.md` - Full guide
- `lib/core/TASK_24_PERFORMANCE_SUMMARY.md` - Implementation summary

## Need Help?

1. Check the full guide: `PERFORMANCE_OPTIMIZATION_GUIDE.md`
2. Review implementation: `TASK_24_PERFORMANCE_SUMMARY.md`
3. Use Flutter DevTools for profiling
4. Monitor debug console for performance logs
