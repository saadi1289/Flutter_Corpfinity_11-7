# Caching Strategy Documentation

This document outlines the comprehensive caching strategy implemented for the Corpfinity Employee Wellness App to optimize performance, reduce network usage, and provide offline-first functionality.

## Overview

The app implements a multi-layered caching strategy:
1. **Image Caching** - Using CachedNetworkImage with optimized cache durations
2. **Data Caching** - Using Hive for offline-first data storage
3. **Memory Management** - Automatic cache cleanup and size enforcement

## Requirements

- **Requirement 10.4**: Cache frequently accessed assets in device memory
- **Requirement 11.5**: Limit initial data payload to under 500KB

## Image Caching Strategy

### Cache Managers

The app uses `CachedNetworkImage` with custom cache configurations for different image types:

#### Profile Images
- **Cache Duration**: 7 days
- **Max Objects**: 100 images
- **Rationale**: Profile images change infrequently, so longer cache is acceptable
- **Usage**: User avatars, profile pictures

```dart
// Configuration
CacheManagerService.profileImageCacheDuration = Duration(days: 7);
CacheManagerService.maxProfileImageCache = 100;
```

#### Carousel Images
- **Cache Duration**: 3 days
- **Max Objects**: 50 images
- **Rationale**: Featured content updates regularly but not daily
- **Usage**: Featured carousel, promotional banners

```dart
// Configuration
CacheManagerService.carouselImageCacheDuration = Duration(days: 3);
CacheManagerService.maxCarouselImageCache = 50;
```

#### Content Images
- **Cache Duration**: 1 day
- **Max Objects**: 200 images
- **Rationale**: Dynamic content that may change frequently
- **Usage**: Activity thumbnails, card images, general content

```dart
// Configuration
CacheManagerService.contentImageCacheDuration = Duration(days: 1);
CacheManagerService.maxContentImageCache = 200;
```

### Image Optimization

All images are optimized using the `ImageOptimizer` utility:

```dart
// Get optimal cache dimensions
final cacheDimensions = ImageOptimizer.getAvatarCacheDimensions(avatarSize);

CachedNetworkImage(
  imageUrl: url,
  memCacheWidth: cacheDimensions['width'],
  memCacheHeight: cacheDimensions['height'],
  maxWidthDiskCache: cacheDimensions['width'],
  maxHeightDiskCache: cacheDimensions['height'],
)
```

**Benefits**:
- Reduces memory usage by caching at appropriate resolution
- Keeps images under 200KB target
- Supports device pixel ratios (1x, 2x, 3x)
- Reduces bandwidth usage

## Data Caching Strategy

### Offline-First Approach

The app implements an offline-first strategy using Hive for local data storage:

1. **Check Cache First**: Always try to load from cache before network
2. **Background Refresh**: Fetch fresh data in background while showing cached data
3. **Graceful Degradation**: Use stale cache if network fails
4. **Automatic Expiration**: Cache expires based on data type

### Cache Types and Durations

#### Activities Cache
- **Duration**: 24 hours
- **Storage**: Hive box (`activities_box`)
- **Size**: ~1KB per activity
- **Usage**: Activity library, search, filtering

```dart
LocalCacheService.isCacheValid() // Check if cache is valid
LocalCacheService.getCachedActivities() // Get cached activities
LocalCacheService.cacheActivities(activities) // Update cache
```

#### Home Screen Data Cache
- **Duration**: 6 hours
- **Storage**: Hive metadata box
- **Size**: ~2KB
- **Usage**: Home screen initial load

```dart
LocalCacheService.isHomeDataCacheValid()
LocalCacheService.getCachedHomeData()
LocalCacheService.cacheHomeData(data)
```

#### Quick Stats Cache
- **Duration**: 1 hour
- **Storage**: Hive metadata box
- **Size**: ~1KB
- **Usage**: User stats, progress indicators

```dart
LocalCacheService.isQuickStatsCacheValid()
LocalCacheService.getCachedQuickStats()
LocalCacheService.cacheQuickStats(stats)
```

### Implementation Example

```dart
// Offline-first data fetching
Future<bool> fetchQuickStats() async {
  // 1. Try cache first
  if (_cacheService.isQuickStatsCacheValid()) {
    final cachedStats = _cacheService.getCachedQuickStats();
    if (cachedStats != null) {
      _updateStateFromQuickStats(cachedStats);
      
      // 2. Fetch fresh data in background
      _fetchQuickStatsInBackground();
      return true;
    }
  }
  
  // 3. No valid cache, fetch from network
  try {
    final stats = await repository.fetchQuickStats();
    await _cacheService.cacheQuickStats(stats);
    _updateStateFromQuickStats(stats);
    return true;
  } catch (e) {
    // 4. On error, use stale cache if available
    final cachedStats = _cacheService.getCachedQuickStats();
    if (cachedStats != null) {
      _updateStateFromQuickStats(cachedStats);
    }
    return false;
  }
}
```

## Memory Management

### Payload Size Enforcement

The app enforces a 500KB limit on initial data payload:

```dart
// Check cache size
final isAcceptable = await _cacheService.isCacheSizeAcceptable();

// Enforce limit by clearing least critical caches
await _cacheService.enforcePayloadLimit();
```

**Cleanup Priority** (least to most critical):
1. Quick stats cache (1KB)
2. Home data cache (2KB)
3. Activities cache (varies)

### Automatic Cache Cleanup

Cache cleanup is triggered:
- When payload size exceeds 500KB
- On user logout
- When storage is low
- Periodically (based on cache duration)

```dart
// Clear all caches
await _cacheService.clearAllCaches();

// Clear specific cache
await CacheManagerService.clearAllImageCaches();
```

## Performance Optimization

### Cache Hit Metrics

Monitor cache effectiveness:
- **Cache Hit Rate**: Percentage of requests served from cache
- **Average Load Time**: Time to load data (cache vs network)
- **Cache Size**: Total size of cached data

### Best Practices

1. **Preload Critical Data**: Cache essential data during splash screen
2. **Lazy Load Images**: Only load images when they become visible
3. **Compress Data**: Use efficient serialization (Hive adapters)
4. **Monitor Size**: Regularly check cache size and cleanup
5. **Test Offline**: Verify app works without network

## Cache Invalidation

### Manual Invalidation

Users can manually clear caches:
- Pull-to-refresh on home screen
- Settings > Clear Cache option
- Logout (clears all user-specific caches)

### Automatic Invalidation

Caches are automatically invalidated:
- After expiration duration
- When payload size limit is exceeded
- On app version update
- When data is modified (write-through cache)

## Testing

### Cache Testing Checklist

- [ ] Verify cache hit on second load
- [ ] Test offline functionality
- [ ] Verify cache expiration
- [ ] Test cache size enforcement
- [ ] Verify graceful degradation on network error
- [ ] Test cache cleanup on logout
- [ ] Verify background refresh works
- [ ] Test with slow network
- [ ] Verify images load from cache
- [ ] Test cache invalidation

### Performance Targets

- **Initial Load**: < 1 second (with cache)
- **Cache Hit Rate**: > 80%
- **Payload Size**: < 500KB
- **Image Load Time**: < 200ms (from cache)

## Monitoring and Analytics

Track cache performance:
```dart
// Log cache metrics
final cacheSize = await _cacheService.getTotalCacheSize();
final isValid = _cacheService.isQuickStatsCacheValid();

analytics.logEvent('cache_metrics', {
  'size': cacheSize,
  'is_valid': isValid,
  'hit_rate': calculateHitRate(),
});
```

## Future Enhancements

1. **Smart Prefetching**: Predict and preload likely-needed data
2. **Adaptive Cache Duration**: Adjust based on usage patterns
3. **Compression**: Compress cached data to save space
4. **Selective Sync**: Only sync changed data
5. **Cache Warming**: Preload cache during idle time

## References

- [CachedNetworkImage Documentation](https://pub.dev/packages/cached_network_image)
- [Hive Documentation](https://docs.hivedb.dev/)
- [Flutter Caching Best Practices](https://docs.flutter.dev/cookbook/networking/background-parsing)
- [Offline-First Architecture](https://offlinefirst.org/)
