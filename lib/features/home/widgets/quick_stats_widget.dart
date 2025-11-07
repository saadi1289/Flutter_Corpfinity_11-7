import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';

/// QuickStatsWidget displays user's streak, weekly progress, and total activities
class QuickStatsWidget extends StatelessWidget {
  final int currentStreak;
  final double weeklyProgress;
  final int totalActivities;

  const QuickStatsWidget({
    super.key,
    required this.currentStreak,
    required this.weeklyProgress,
    required this.totalActivities,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: AppDimensions.shadowBlurRadius,
            spreadRadius: AppDimensions.shadowSpreadRadius,
            offset: const Offset(0, AppDimensions.shadowOffsetY),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Progress',
            style: AppTypography.headingMedium,
          ),
          const SizedBox(height: AppDimensions.spacing16),
          
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Icons.local_fire_department_rounded,
                iconColor: AppColors.warmOrange,
                value: currentStreak.toString(),
                label: 'Day Streak',
              ),
              _StatItem(
                icon: Icons.check_circle_rounded,
                iconColor: AppColors.softGreen,
                value: totalActivities.toString(),
                label: 'Activities',
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing20),
          
          // Weekly Progress Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weekly Goal',
                    style: AppTypography.bodyMedium,
                  ),
                  Text(
                    '${(weeklyProgress * 100).toInt()}%',
                    style: AppTypography.headingSmall.copyWith(
                      color: AppColors.calmBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing8),
              _AnimatedProgressBar(progress: weeklyProgress),
            ],
          ),
        ],
      ),
    );
  }
}

/// Individual stat item with icon, value, and label
class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacing12),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: AppDimensions.iconSizeMedium,
            color: iconColor,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        Text(
          value,
          style: AppTypography.displaySmall.copyWith(
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing4),
        Text(
          label,
          style: AppTypography.bodySmall,
        ),
      ],
    );
  }
}

/// Animated progress bar with gradient fill
class _AnimatedProgressBar extends StatefulWidget {
  final double progress;

  const _AnimatedProgressBar({required this.progress});

  @override
  State<_AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<_AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: widget.progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(_AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: AppDimensions.progressBarHeight,
          decoration: BoxDecoration(
            color: AppColors.neutralGray,
            borderRadius: BorderRadius.circular(AppDimensions.progressBarBorderRadius),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _animation.value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.progressBarBorderRadius),
              ),
            ),
          ),
        );
      },
    );
  }
}
