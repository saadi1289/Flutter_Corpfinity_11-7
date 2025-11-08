import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/image_optimizer.dart';
import 'user_level_badge.dart';

/// AnimatedProfileHeader displays the user's profile information in the hero section.
/// 
/// Features:
/// - Circular avatar with CachedNetworkImage
/// - Shimmer loading placeholder
/// - Shadow effect for depth
/// - User name and level badge
/// - Optimized image caching with memCacheWidth (<200KB)
/// 
/// Requirements: 3.2, 3.5, 10.1, 10.5
class AnimatedProfileHeader extends StatelessWidget {
  /// User's display name
  final String userName;
  
  /// URL for user's profile image (optional)
  final String? profileImageUrl;
  
  /// User's current level
  final int currentLevel;

  const AnimatedProfileHeader({
    super.key,
    required this.userName,
    this.profileImageUrl,
    required this.currentLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile avatar
        _buildAvatar(context),
        const SizedBox(width: AppDimensions.spacing16),
        // User info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // User name with shadow for better visibility
              Text(
                userName,
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: AppDimensions.spacing8),
              // Level badge
              UserLevelBadge(level: currentLevel),
            ],
          ),
        ),
      ],
    );
  }

  /// Build the circular avatar with shadow and loading states
  Widget _buildAvatar(BuildContext context) {
    final avatarSize = ResponsiveHelper.getAvatarSize(context);
    
    // Get optimal cache dimensions using ImageOptimizer
    // Requirement 3.5, 10.1, 10.5: Optimize images to <200KB with proper caching
    final cacheDimensions = ImageOptimizer.getAvatarCacheDimensions(avatarSize);
    
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(avatarSize / 2),
        child: profileImageUrl != null && profileImageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: profileImageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildShimmerPlaceholder(avatarSize),
                errorWidget: (context, url, error) => _buildAvatarPlaceholder(avatarSize),
                fadeInDuration: const Duration(milliseconds: 300),
                fadeOutDuration: const Duration(milliseconds: 100),
                // Optimize memory usage - cache at 2x resolution for retina displays
                // This keeps the image under 200KB as required
                memCacheWidth: cacheDimensions['width'],
                memCacheHeight: cacheDimensions['height'],
                // Set max width/height for network download to reduce bandwidth
                maxWidthDiskCache: cacheDimensions['width'],
                maxHeightDiskCache: cacheDimensions['height'],
              )
            : _buildAvatarPlaceholder(avatarSize),
      ),
    );
  }

  /// Build shimmer loading placeholder for avatar
  Widget _buildShimmerPlaceholder(double size) {
    return Shimmer.fromColors(
      baseColor: AppColors.white.withOpacity(0.3),
      highlightColor: AppColors.white.withOpacity(0.5),
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// Build default avatar placeholder when no image is available
  Widget _buildAvatarPlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: size * 0.5,
        color: AppColors.white,
      ),
    );
  }
}
