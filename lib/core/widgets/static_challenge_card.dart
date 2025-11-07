import 'package:flutter/material.dart';
import '../../data/models/static_challenge_model.dart';
import '../constants/colors.dart';
import '../constants/typography.dart';
import '../constants/dimensions.dart';

/// StaticChallengeCard displays a pre-defined challenge with elegant animations
/// 
/// Features:
/// - Gradient background based on wellness area accent color
/// - Border styling with wellness area color at 60% opacity
/// - Soft shadow with wellness area accent color
/// - Fade-in animation (0 to 1 opacity) over 300ms
/// - Slide-up animation (20px offset) over 300ms
/// - Cross-fade transition when wellness area selection changes
/// - Smooth animations using Curves.easeOutCubic
class StaticChallengeCard extends StatefulWidget {
  final StaticChallengeModel challenge;
  final VoidCallback? onTap;

  const StaticChallengeCard({
    super.key,
    required this.challenge,
    this.onTap,
  });

  @override
  State<StaticChallengeCard> createState() => _StaticChallengeCardState();
}

class _StaticChallengeCardState extends State<StaticChallengeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _animationController.forward();
  }

  @override
  void didUpdateWidget(StaticChallengeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger animation when challenge changes (wellness area selection changes)
    if (oldWidget.challenge.id != widget.challenge.id) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05), // 20px offset (relative to card height)
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _buildCard(),
        ),
      ),
    );
  }

  Widget _buildCard() {
    final accentColor = widget.challenge.accentColor;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 200,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.white,
              accentColor.withOpacity(0.08),
            ],
          ),
          border: Border.all(
            color: accentColor.withOpacity(0.6),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.15),
              blurRadius: 16,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppDimensions.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Icon(
              widget.challenge.icon,
              size: AppDimensions.iconSizeXLarge,
              color: accentColor,
            ),
            const SizedBox(height: AppDimensions.spacing16),
            
            // Title
            Text(
              widget.challenge.title,
              style: AppTypography.displaySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            
            // Goal Description
            Text(
              widget.challenge.goalDescription,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.darkText,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.spacing16),
            
            // Duration and Category Chips
            Row(
              children: [
                _buildChip(
                  label: widget.challenge.duration,
                  icon: Icons.calendar_today_outlined,
                  color: accentColor,
                ),
                const SizedBox(width: AppDimensions.spacing8),
                _buildChip(
                  label: widget.challenge.wellnessArea.displayName,
                  icon: Icons.category_outlined,
                  color: accentColor,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing16),
            
            // Motivational Text
            Text(
              widget.challenge.motivationalText,
              style: AppTypography.bodyMedium.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.mediumGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing12,
        vertical: AppDimensions.spacing8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppDimensions.iconSizeSmall,
            color: color,
          ),
          const SizedBox(width: AppDimensions.spacing4),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
