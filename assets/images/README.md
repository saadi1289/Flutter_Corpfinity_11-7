# Image Assets Optimization Guide

This directory contains optimized image assets for the Corpfinity Employee Wellness App.

## Image Optimization Requirements

All images must meet the following criteria:
- **File size**: < 200KB per image
- **Format**: WebP (preferred) with PNG fallback
- **Resolution variants**: 1x, 2x, 3x for different device pixel ratios

## Directory Structure

```
assets/images/
├── image.png          # 1x resolution (baseline)
├── 2.0x/
│   └── image.png      # 2x resolution (retina displays)
└── 3.0x/
    └── image.png      # 3x resolution (high DPI displays)
```

## Image Types and Specifications

### Profile Avatars
- **Display size**: 64-80px
- **Cache size**: 128-160px (2x resolution)
- **Format**: WebP or PNG
- **Compression**: 80-90% quality
- **Max file size**: 50KB per variant

### Carousel Images
- **Display size**: ~350x200px (90% viewport width)
- **Cache size**: Device-dependent (up to 3x)
- **Format**: WebP or JPEG
- **Compression**: 80-85% quality
- **Max file size**: 150KB per variant

### Card Images
- **Display size**: Varies by card type
- **Cache size**: Device-dependent (up to 3x)
- **Format**: WebP or PNG
- **Compression**: 80-90% quality
- **Max file size**: 100KB per variant

## Optimization Tools

### Recommended Tools
1. **WebP Conversion**:
   ```bash
   # Convert PNG to WebP
   cwebp -q 85 input.png -o output.webp
   
   # Batch convert
   for file in *.png; do cwebp -q 85 "$file" -o "${file%.png}.webp"; done
   ```

2. **Image Resizing**:
   ```bash
   # Using ImageMagick
   convert input.png -resize 50% output.png
   
   # Create 2x variant
   convert input.png -resize 200% 2.0x/input.png
   
   # Create 3x variant
   convert input.png -resize 300% 3.0x/input.png
   ```

3. **Compression**:
   ```bash
   # PNG compression with pngquant
   pngquant --quality=80-90 input.png -o output.png
   
   # JPEG compression with mozjpeg
   cjpeg -quality 85 input.jpg > output.jpg
   ```

### Online Tools
- [Squoosh](https://squoosh.app/) - Google's image compression tool
- [TinyPNG](https://tinypng.com/) - PNG and JPEG compression
- [Compressor.io](https://compressor.io/) - Multi-format compression

## Usage in Code

### Using ImageOptimizer Utility

```dart
import 'package:corpfinity_employee_app/core/utils/image_optimizer.dart';

// For avatars
final cacheDimensions = ImageOptimizer.getAvatarCacheDimensions(avatarSize);

CachedNetworkImage(
  imageUrl: profileImageUrl,
  memCacheWidth: cacheDimensions['width'],
  memCacheHeight: cacheDimensions['height'],
  maxWidthDiskCache: cacheDimensions['width'],
  maxHeightDiskCache: cacheDimensions['height'],
)

// For carousel images
final cacheDimensions = ImageOptimizer.getCarouselImageCacheDimensions(
  displayWidth: screenWidth * 0.9,
  displayHeight: 200.0,
  context: context,
);

// For resolution-aware local assets
final imagePath = ImageOptimizer.getResolutionAwarePath(
  'assets/images/avatar.png',
  context,
);
```

## Best Practices

1. **Always provide multiple resolutions**: Create 1x, 2x, and 3x variants for all images
2. **Use WebP when possible**: Better compression than PNG/JPEG with similar quality
3. **Provide fallbacks**: Include PNG versions for older devices
4. **Optimize before adding**: Never commit unoptimized images to the repository
5. **Test on devices**: Verify images look good on different screen densities
6. **Monitor file sizes**: Use `flutter analyze` and check asset bundle size
7. **Use vector graphics**: For icons and simple graphics, prefer SVG or Flutter's Icon widgets

## Verification Checklist

Before committing images, verify:
- [ ] File size is under 200KB
- [ ] All three resolution variants exist (1x, 2x, 3x)
- [ ] WebP format is used (with PNG fallback if needed)
- [ ] Images are properly compressed (80-90% quality)
- [ ] Images display correctly on different devices
- [ ] No visual artifacts from compression
- [ ] Proper aspect ratios maintained

## Asset Bundle Size

Monitor the total asset bundle size:
```bash
# Build release APK and check size
flutter build apk --release
flutter build apk --analyze-size

# Check asset sizes
flutter build apk --release --target-platform android-arm64 --analyze-size
```

Target: Keep initial payload under 500KB (Requirement 11.5)

## References

- [Flutter Image Documentation](https://docs.flutter.dev/development/ui/assets-and-images)
- [WebP Format](https://developers.google.com/speed/webp)
- [Image Optimization Best Practices](https://web.dev/fast/#optimize-your-images)
