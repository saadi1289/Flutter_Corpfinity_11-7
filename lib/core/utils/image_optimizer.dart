import 'package:flutter/material.dart';

/// Utility class for optimizing image loading and caching
/// 
/// Provides methods to calculate optimal cache dimensions and
/// determine appropriate image resolutions based on device pixel ratio.
/// 
/// Requirements: 3.5, 10.1, 10.5
class ImageOptimizer {
  /// Maximum file size target for images (200KB)
  static const int maxImageSizeKB = 200;
  
  /// Calculate optimal memory cache dimensions for an image
  /// 
  /// Takes into account device pixel ratio to provide appropriate
  /// resolution while keeping memory usage under control.
  /// 
  /// [displayWidth] - The width the image will be displayed at in logical pixels
  /// [displayHeight] - The height the image will be displayed at in logical pixels
  /// [context] - BuildContext to access device pixel ratio
  /// 
  /// Returns a map with 'width' and 'height' keys for cache dimensions
  static Map<String, int> getOptimalCacheDimensions({
    required double displayWidth,
    required double displayHeight,
    required BuildContext context,
  }) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    
    // Use 2x resolution for retina displays, capped at 3x for very high DPI
    final multiplier = devicePixelRatio.clamp(1.0, 3.0);
    
    return {
      'width': (displayWidth * multiplier).toInt(),
      'height': (displayHeight * multiplier).toInt(),
    };
  }
  
  /// Get the appropriate image resolution variant based on device pixel ratio
  /// 
  /// Returns '1x', '2x', or '3x' based on device capabilities
  static String getImageResolutionVariant(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    
    if (devicePixelRatio >= 3.0) {
      return '3x';
    } else if (devicePixelRatio >= 2.0) {
      return '2x';
    } else {
      return '1x';
    }
  }
  
  /// Build the path to a resolution-specific image asset
  /// 
  /// Follows Flutter's convention for resolution-aware images:
  /// - assets/images/image.png (1x)
  /// - assets/images/2.0x/image.png (2x)
  /// - assets/images/3.0x/image.png (3x)
  /// 
  /// [basePath] - Base path to the image (e.g., 'assets/images/avatar.png')
  /// [context] - BuildContext to determine appropriate resolution
  static String getResolutionAwarePath(String basePath, BuildContext context) {
    final variant = getImageResolutionVariant(context);
    
    if (variant == '1x') {
      return basePath;
    }
    
    // Extract directory and filename
    final lastSlash = basePath.lastIndexOf('/');
    if (lastSlash == -1) return basePath;
    
    final directory = basePath.substring(0, lastSlash);
    final filename = basePath.substring(lastSlash + 1);
    
    // Build resolution-specific path
    final multiplier = variant == '2x' ? '2.0x' : '3.0x';
    return '$directory/$multiplier/$filename';
  }
  
  /// Calculate optimal avatar cache dimensions
  /// 
  /// Avatars are typically displayed at 64-80px, so we cache at 2x
  /// resolution to support retina displays while staying under 200KB
  static Map<String, int> getAvatarCacheDimensions(double avatarSize) {
    // Cache at 2x resolution for avatars
    final cacheSize = (avatarSize * 2).toInt();
    
    return {
      'width': cacheSize,
      'height': cacheSize,
    };
  }
  
  /// Calculate optimal carousel image cache dimensions
  /// 
  /// Carousel images are larger, so we use device-aware caching
  static Map<String, int> getCarouselImageCacheDimensions({
    required double displayWidth,
    required double displayHeight,
    required BuildContext context,
  }) {
    return getOptimalCacheDimensions(
      displayWidth: displayWidth,
      displayHeight: displayHeight,
      context: context,
    );
  }
  
  /// Calculate optimal card image cache dimensions
  /// 
  /// Card images are medium-sized, cached at appropriate resolution
  static Map<String, int> getCardImageCacheDimensions({
    required double displayWidth,
    required double displayHeight,
    required BuildContext context,
  }) {
    return getOptimalCacheDimensions(
      displayWidth: displayWidth,
      displayHeight: displayHeight,
      context: context,
    );
  }
}
