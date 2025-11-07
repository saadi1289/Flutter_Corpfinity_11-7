import 'package:flutter/foundation.dart';
import '../../../data/models/user_progress.dart';
import '../../../data/models/badge.dart';
import '../../../data/models/completed_activity.dart';

/// Provider for managing progress data including streaks, history, and badges
class ProgressProvider with ChangeNotifier {
  UserProgress? _userProgress;
  bool _isLoading = false;
  String? _error;
  Badge? _recentlyUnlockedBadge;

  UserProgress? get userProgress => _userProgress;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Badge? get recentlyUnlockedBadge => _recentlyUnlockedBadge;

  int get currentStreak => _userProgress?.currentStreak ?? 0;
  int get longestStreak => _userProgress?.longestStreak ?? 0;
  int get totalActivitiesCompleted => _userProgress?.totalActivitiesCompleted ?? 0;
  double get weeklyGoalProgress => _userProgress?.weeklyGoalProgress ?? 0.0;
  List<DateTime> get completedDays => _userProgress?.completedDays ?? [];
  List<Badge> get earnedBadges => _userProgress?.earnedBadges.where((b) => b.isUnlocked).toList() ?? [];
  List<Badge> get lockedBadges => _allBadges.where((b) => !b.isUnlocked).toList();
  List<CompletedActivity> get activityHistory => _userProgress?.recentHistory ?? [];

  // All available badges (earned + locked)
  List<Badge> get _allBadges => [
        ..._userProgress?.earnedBadges ?? [],
        ..._getMockLockedBadges(),
      ];

  /// Fetch user progress data
  Future<void> fetchUserProgress(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call with mock data
      await Future.delayed(const Duration(milliseconds: 500));
      _userProgress = _getMockUserProgress(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load progress data';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Record activity completion and update progress
  Future<void> recordActivityCompletion(String activityId, String activityName) async {
    if (_userProgress == null) return;

    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Create completed activity record
      final completedActivity = CompletedActivity(
        activityId: activityId,
        activityName: activityName,
        completedAt: now,
        pointsEarned: 10,
      );

      // Update completed days
      final updatedCompletedDays = List<DateTime>.from(_userProgress!.completedDays);
      if (!updatedCompletedDays.any((date) => 
          date.year == today.year && 
          date.month == today.month && 
          date.day == today.day)) {
        updatedCompletedDays.add(today);
      }

      // Update streak
      final newStreak = _calculateStreak(updatedCompletedDays);
      final newLongestStreak = newStreak > _userProgress!.longestStreak 
          ? newStreak 
          : _userProgress!.longestStreak;

      // Update total activities
      final newTotalActivities = _userProgress!.totalActivitiesCompleted + 1;

      // Update weekly progress (assuming goal is 7 activities per week)
      final weeklyActivities = _getActivitiesThisWeek(
        [..._userProgress!.recentHistory, completedActivity]
      );
      final newWeeklyProgress = (weeklyActivities / 7.0).clamp(0.0, 1.0);

      // Update history
      final updatedHistory = [completedActivity, ..._userProgress!.recentHistory];

      // Check for badge unlocks
      final previousBadges = _userProgress!.earnedBadges;
      final updatedBadges = _checkBadgeUnlocks(
        previousBadges,
        newTotalActivities,
        newStreak,
      );

      // Find newly unlocked badge
      _recentlyUnlockedBadge = updatedBadges.firstWhere(
        (badge) => badge.isUnlocked && 
            !previousBadges.any((prev) => prev.id == badge.id && prev.isUnlocked),
        orElse: () => updatedBadges.first,
      );
      if (_recentlyUnlockedBadge?.id == updatedBadges.first.id && 
          previousBadges.any((prev) => prev.id == _recentlyUnlockedBadge!.id && prev.isUnlocked)) {
        _recentlyUnlockedBadge = null;
      }

      // Update user progress
      _userProgress = _userProgress!.copyWith(
        currentStreak: newStreak,
        longestStreak: newLongestStreak,
        totalActivitiesCompleted: newTotalActivities,
        weeklyGoalProgress: newWeeklyProgress,
        completedDays: updatedCompletedDays,
        earnedBadges: updatedBadges,
        recentHistory: updatedHistory,
      );

      notifyListeners();
    } catch (e) {
      _error = 'Failed to record activity completion';
      notifyListeners();
    }
  }

  /// Calculate current streak from completed days
  int _calculateStreak(List<DateTime> completedDays) {
    if (completedDays.isEmpty) return 0;

    final sortedDays = List<DateTime>.from(completedDays)
      ..sort((a, b) => b.compareTo(a));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    // Check if streak is still active (completed today or yesterday)
    final lastCompleted = sortedDays.first;
    if (lastCompleted != today && lastCompleted != yesterday) {
      return 0;
    }

    int streak = 0;
    DateTime expectedDate = today;

    for (final date in sortedDays) {
      if (date == expectedDate) {
        streak++;
        expectedDate = expectedDate.subtract(const Duration(days: 1));
      } else if (date == expectedDate.add(const Duration(days: 1))) {
        // Skip if already counted
        continue;
      } else {
        break;
      }
    }

    return streak;
  }

  /// Get number of activities completed this week
  int _getActivitiesThisWeek(List<CompletedActivity> history) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    return history.where((activity) => 
      activity.completedAt.isAfter(startOfWeekDate)
    ).length;
  }

  /// Check and unlock badges based on achievements
  List<Badge> _checkBadgeUnlocks(
    List<Badge> currentBadges,
    int totalActivities,
    int currentStreak,
  ) {
    final updatedBadges = List<Badge>.from(currentBadges);

    // First Activity Badge
    if (totalActivities >= 1) {
      _unlockBadge(updatedBadges, 'first_activity');
    }

    // 10 Activities Badge
    if (totalActivities >= 10) {
      _unlockBadge(updatedBadges, '10_activities');
    }

    // 50 Activities Badge
    if (totalActivities >= 50) {
      _unlockBadge(updatedBadges, '50_activities');
    }

    // 3 Day Streak Badge
    if (currentStreak >= 3) {
      _unlockBadge(updatedBadges, '3_day_streak');
    }

    // 7 Day Streak Badge
    if (currentStreak >= 7) {
      _unlockBadge(updatedBadges, '7_day_streak');
    }

    // 30 Day Streak Badge
    if (currentStreak >= 30) {
      _unlockBadge(updatedBadges, '30_day_streak');
    }

    return updatedBadges;
  }

  /// Unlock a specific badge
  void _unlockBadge(List<Badge> badges, String badgeId) {
    final index = badges.indexWhere((b) => b.id == badgeId);
    if (index != -1 && !badges[index].isUnlocked) {
      badges[index] = badges[index].copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
    }
  }

  /// Clear recently unlocked badge notification
  void clearRecentlyUnlockedBadge() {
    _recentlyUnlockedBadge = null;
    notifyListeners();
  }

  /// Get mock user progress for development
  UserProgress _getMockUserProgress(String userId) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return UserProgress(
      userId: userId,
      currentStreak: 5,
      longestStreak: 12,
      totalActivitiesCompleted: 23,
      weeklyGoalProgress: 0.71, // 5 out of 7
      completedDays: [
        today,
        today.subtract(const Duration(days: 1)),
        today.subtract(const Duration(days: 2)),
        today.subtract(const Duration(days: 3)),
        today.subtract(const Duration(days: 4)),
        today.subtract(const Duration(days: 7)),
        today.subtract(const Duration(days: 8)),
      ],
      earnedBadges: [
        Badge(
          id: 'first_activity',
          name: 'First Step',
          description: 'Complete your first activity',
          iconUrl: '🎯',
          isUnlocked: true,
          unlockedAt: DateTime.now().subtract(const Duration(days: 20)),
        ),
        Badge(
          id: '10_activities',
          name: 'Getting Started',
          description: 'Complete 10 activities',
          iconUrl: '⭐',
          isUnlocked: true,
          unlockedAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
        Badge(
          id: '3_day_streak',
          name: 'Consistent',
          description: 'Maintain a 3-day streak',
          iconUrl: '🔥',
          isUnlocked: true,
          unlockedAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Badge(
          id: '50_activities',
          name: 'Wellness Champion',
          description: 'Complete 50 activities',
          iconUrl: '🏆',
          isUnlocked: false,
        ),
        Badge(
          id: '7_day_streak',
          name: 'Week Warrior',
          description: 'Maintain a 7-day streak',
          iconUrl: '💪',
          isUnlocked: false,
        ),
        Badge(
          id: '30_day_streak',
          name: 'Dedication Master',
          description: 'Maintain a 30-day streak',
          iconUrl: '👑',
          isUnlocked: false,
        ),
      ],
      recentHistory: [
        CompletedActivity(
          activityId: 'breathing_1',
          activityName: 'Deep Breathing Exercise',
          completedAt: today,
          pointsEarned: 10,
        ),
        CompletedActivity(
          activityId: 'stretch_2',
          activityName: 'Desk Stretches',
          completedAt: today.subtract(const Duration(days: 1)),
          pointsEarned: 10,
        ),
        CompletedActivity(
          activityId: 'walk_1',
          activityName: 'Quick Walk',
          completedAt: today.subtract(const Duration(days: 2)),
          pointsEarned: 10,
        ),
      ],
    );
  }

  /// Get mock locked badges
  List<Badge> _getMockLockedBadges() {
    return [];
  }
}
