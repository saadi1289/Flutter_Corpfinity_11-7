/// Service for managing image and data caching strategies
/// 
/// Provides configuration for CachedNetworkImage with appropriate
/// cache durations and memory management strategies.
/// 
/// Requirements: 10.4, 11.5
class CacheManagerService {
  /// Singleton instance
  static final CacheManagerService _instance = CacheManagerService._internal();
  factory CacheManagerService() => _instance;
  CacheManagerService._internal();
  
  /// Cache configuration constants
  static const Duration profileImageCacheDuration = Duration(days: 7);
  static const Duration carouselImageCacheDuration = Duration(days: 3);
  static const Duration contentImageCacheDuration = Duration(days: 1);
  
  /// Maximum cache sizes (in number of objects)
  static const int maxProfileImageCache = 100;
  static const int maxCarouselImageCache = 50;
  static const int maxContentImageCache = 200;
  
  /// Get cache configuration for profile images
  /// Longer cache duration since profile images change infrequently
  static Map<String, dynamic> getProfileImageCacheConfig() {
    return {
      'stalePeriod': profileImageCacheDuration,
      'maxObjects': maxProfileImageCache,
    };
  }
  
  /// Get cache configuration for carousel images
  /// Medium cache duration for featured content
  static Map<String, dynamic> getCarouselImageCacheConfig() {
    return {
      'stalePeriod': carouselImageCacheDuration,
      'maxObjects': maxCarouselImageCache,
    };
  }
  
  /// Get cache configuration for content images
  /// Shorter cache duration for dynamic content
  static Map<String, dynamic> getContentImageCacheConfig() {
    return {
      'stalePeriod': contentImageCacheDuration,
      'maxObjects': maxContentImageCache,
    };
  }
}

/// Cache type enum for targeted cache clearing
enum CacheType {
  profile,
  carousel,
  content,
}
