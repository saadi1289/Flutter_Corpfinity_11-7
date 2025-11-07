import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';

/// ProfileHeader displays user photo, name, and total points
class ProfileHeader extends StatelessWidget {
  final String name;
  final String? photoUrl;
  final int totalPoints;

  const ProfileHeader({
    super.key,
    required this.name,
    this.photoUrl,
    required this.totalPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacing32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.calmBlue,
            AppColors.calmBlue.withBlue(255),
            AppColors.softGreen,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppDimensions.radiusXLarge + 8),
          bottomRight: Radius.circular(AppDimensions.radiusXLarge + 8),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.calmBlue.withOpacity(0.3),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          // Enhanced Profile Photo with gradient border
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.white.withOpacity(0.8),
                  AppColors.white.withOpacity(0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
              child: photoUrl != null && photoUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        photoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildDefaultAvatar();
                        },
                      ),
                    )
                  : _buildDefaultAvatar(),
            ),
          ),

          const SizedBox(height: AppDimensions.spacing20),

          // User Name with shadow
          Text(
            name,
            style: AppTypography.headingLarge.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimensions.spacing16),

          // Enhanced Total Points badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing24,
              vertical: AppDimensions.spacing12,
            ),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
              border: Border.all(
                color: AppColors.white.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Text(
                  '$totalPoints Points',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build default avatar with user initials
  Widget _buildDefaultAvatar() {
    final initials = _getInitials(name);
    return Container(
      color: AppColors.calmBlue,
      child: Center(
        child: Text(
          initials,
          style: AppTypography.displayLarge.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Get user initials from name
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return '${parts[0].substring(0, 1)}${parts[parts.length - 1].substring(0, 1)}'
        .toUpperCase();
  }
}
