import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/colors.dart';
import '../constants/dimensions.dart';
import '../constants/typography.dart';
import '../utils/responsive_helper.dart';
import 'animated_progress_bar.dart';

/// HeroCard displays user profile information with progress indicator.
/// 
/// Features:
/// - Circular avatar with responsive sizing (56px/64px/72px for small/medium/large)
/// - Gradient background (calmBlue to softGreen)
/// - Animated progress bar with gradient fill (800ms animation on mount)
/// - Level display text
/// - Responsive card height: 160px/180px/200px for small/medium/large screens
/// - Elevation 4 shadow
/// 
/// Includes accessibility features: semantic labels for screen readers.
class HeroCard extends StatelessWidget {
  final String userName;
  final String? profileImageUrl;
  final double progressValue; // 0.0 to 1.0
  final int currentLevel;

  const HeroCard({
    super.key,
    required this.userName,
    this.profileImageUrl,
    required this.progressValue,
    required this.currentLevel,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercent = (progressValue * 100).toInt();
    final semanticLabel = 'User profile card. $userName, Level $currentLevel, $progressPercent% progress';
    
    // Responsive sizing
    final cardHeight = ResponsiveHelper.getHeroCardHeight(context);
    final padding = ResponsiveHelper.getScreenPadding(context);

    return Semantics(
      label: semanticLabel,
      child: Container(
        height: cardHeight,
        decoration: BoxDecoration(
          gradient: _gradientDecoration.gradient,
          borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar and user info row
              Row(
                children: [
                  // Circular avatar
                  _buildAvatar(),
                  const SizedBox(width: AppDimensions.spacing16),
                  // User name and level
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: AppTypography.headingLarge.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppDimensions.spacing4),
                        Text(
                          'Level $currentLevel',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Progress bar section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$progressPercent%',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  AnimatedProgressBar(
                    progress: progressValue,
                    height: 10,
                    gradientColors: const [
                      AppColors.white,
                      AppColors.softGreen,
                    ],
                    backgroundColor: AppColors.white.withOpacity(0.3),
                    semanticLabel: 'Level progress: $progressPercent percent',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Builder(
      builder: (context) {
        final avatarSize = ResponsiveHelper.getAvatarSize(context);
        return Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            border: Border.all(
              color: AppColors.white.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: profileImageUrl != null && profileImageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: profileImageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.calmBlue.withOpacity(0.2),
                      child: Icon(
                        Icons.person,
                        size: avatarSize * 0.5,
                        color: AppColors.calmBlue.withOpacity(0.5),
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      return _buildAvatarPlaceholder(avatarSize);
                    },
                    fadeInDuration: const Duration(milliseconds: 200),
                    fadeOutDuration: const Duration(milliseconds: 100),
                    memCacheWidth: (avatarSize * 2).toInt(), // Cache at 2x resolution for retina displays
                    memCacheHeight: (avatarSize * 2).toInt(),
                  )
                : _buildAvatarPlaceholder(avatarSize),
          ),
        );
      },
    );
  }

  Widget _buildAvatarPlaceholder(double avatarSize) {
    return Container(
      color: AppColors.calmBlue.withOpacity(0.2),
      child: Icon(
        Icons.person,
        size: avatarSize * 0.5, // Icon size is 50% of avatar size
        color: AppColors.calmBlue,
      ),
    );
  }
  
  // Optimized gradient decoration - reused to avoid recreation
  static const BoxDecoration _gradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [AppColors.calmBlue, AppColors.softGreen],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}
