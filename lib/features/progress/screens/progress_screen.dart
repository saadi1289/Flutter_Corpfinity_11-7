import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../core/constants/dimensions.dart';
import '../../../data/models/badge.dart' as models;
import '../providers/progress_provider.dart';
import '../widgets/streak_calendar.dart';
import '../widgets/history_list.dart';
import '../widgets/badge_grid.dart';
import '../widgets/badge_unlock_animation.dart';

/// Progress tracking screen with tabbed interface for Streaks, History, and Badges
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Fetch progress data on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProgressProvider>().fetchUserProgress('current_user');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Listen for badge unlocks
    final progressProvider = context.watch<ProgressProvider>();
    if (progressProvider.recentlyUnlockedBadge != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showBadgeUnlockAnimation(
          context,
          progressProvider.recentlyUnlockedBadge!,
        );
        progressProvider.clearRecentlyUnlockedBadge();
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'My Progress',
          style: AppTypography.headingLarge,
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.calmBlue,
          unselectedLabelColor: AppColors.mediumGray,
          labelStyle: AppTypography.headingSmall,
          unselectedLabelStyle: AppTypography.bodyMedium,
          indicatorColor: AppColors.calmBlue,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Streaks'),
            Tab(text: 'History'),
            Tab(text: 'Badges'),
          ],
        ),
      ),
      body: Consumer<ProgressProvider>(
        builder: (context, progressProvider, child) {
          if (progressProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.calmBlue,
              ),
            );
          }

          if (progressProvider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: AppDimensions.iconSizeXLarge,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    Text(
                      progressProvider.error!,
                      style: AppTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.spacing24),
                    ElevatedButton(
                      onPressed: () {
                        progressProvider.fetchUserProgress('current_user');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.calmBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing24,
                          vertical: AppDimensions.spacing12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        ),
                      ),
                      child: Text(
                        'Retry',
                        style: AppTypography.buttonMedium,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              // Streaks Tab
              SingleChildScrollView(
                child: StreakCalendar(
                  completedDays: progressProvider.completedDays,
                  currentStreak: progressProvider.currentStreak,
                  longestStreak: progressProvider.longestStreak,
                ),
              ),
              
              // History Tab
              HistoryList(
                activities: progressProvider.activityHistory,
              ),
              
              // Badges Tab
              BadgeGrid(
                badges: [
                  ...progressProvider.earnedBadges,
                  ...progressProvider.lockedBadges,
                ],
                onBadgeTap: (badge) {
                  _showBadgeDetails(context, badge);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showBadgeDetails(BuildContext context, models.Badge badge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: badge.isUnlocked 
                    ? AppColors.softGreen.withOpacity(0.1)
                    : AppColors.neutralGray,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  badge.iconUrl,
                  style: TextStyle(
                    fontSize: 40,
                    color: badge.isUnlocked ? null : AppColors.mediumGray,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Text(
              badge.name,
              style: AppTypography.headingMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              badge.description,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
            if (badge.isUnlocked && badge.unlockedAt != null) ...[
              const SizedBox(height: AppDimensions.spacing16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing16,
                  vertical: AppDimensions.spacing8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.softGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: Text(
                  'Unlocked ${_formatDate(badge.unlockedAt!)}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.softGreen,
                  ),
                ),
              ),
            ],
            if (!badge.isUnlocked) ...[
              const SizedBox(height: AppDimensions.spacing16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock,
                    size: AppDimensions.iconSizeSmall,
                    color: AppColors.mediumGray,
                  ),
                  const SizedBox(width: AppDimensions.spacing4),
                  Text(
                    'Locked',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.mediumGray,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: AppTypography.buttonMedium.copyWith(
                color: AppColors.calmBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
