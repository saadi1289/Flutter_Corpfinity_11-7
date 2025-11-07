import '../models/models.dart';
import '../services/hive_service.dart';
import '../../core/exceptions/app_exception.dart';

/// Repository interface for progress tracking operations
abstract class ProgressRepository {
  /// Get user progress
  Future<UserProgress> getUserProgress(String userId);

  /// Get activity history
  Future<List<CompletedActivity>> getActivityHistory(String userId);

  /// Record activity completion
  Future<void> recordActivityCompletion(
    String userId,
    String activityId,
    String activityName,
  );

  /// Update streak
  Future<void> updateStreak(String userId, int currentStreak, int longestStreak);

  /// Unlock badge
  Future<void> unlockBadge(String userId, String badgeId);

  /// Save progress locally
  Future<void> saveProgressLocally(UserProgress progress);

  /// Get progress from local storage
  UserProgress? getProgressLocally(String userId);
}

/// Implementation of ProgressRepository with local tracking
class LocalProgressRepository implements ProgressRepository {
  @override
  Future<UserProgress> getUserProgress(String userId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      // Try to get from local storage
      var progress = getProgressLocally(userId);

      // If not found, create new progress
      if (progress == null) {
        progress = UserProgress(
          userId: userId,
          currentStreak: 0,
          longestStreak: 0,
          totalActivitiesCompleted: 0,
          weeklyGoalProgress: 0.0,
          completedDays: [],
          earnedBadges: _getInitialBadges(),
          recentHistory: [],
        );
        await saveProgressLocally(progress);
      }

      return progress;
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException('Failed to get user progress: ${e.toString()}');
    }
  }

  @override
  Future<List<CompletedActivity>> getActivityHistory(String userId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 200));

      final progress = await getUserProgress(userId);
      return progress.recentHistory;
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException('Failed to get activity history: ${e.toString()}');
    }
  }

  @override
  Future<void> recordActivityCompletion(
    String userId,
    String activityId,
    String activityName,
  ) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));

      final progress = await getUserProgress(userId);
      final now = DateTime.now();

      // Create completed activity record
      final completedActivity = CompletedActivity(
        activityId: activityId,
        activityName: activityName,
        completedAt: now,
        pointsEarned: 10, // Base points per activity
      );

      // Update history
      final updatedHistory = [completedActivity, ...progress.recentHistory];
      if (updatedHistory.length > 50) {
        updatedHistory.removeRange(50, updatedHistory.length);
      }

      // Update completed days
      final today = DateTime(now.year, now.month, now.day);
      final completedDays = List<DateTime>.from(progress.completedDays);
      if (!completedDays.any((d) =>
          d.year == today.year && d.month == today.month && d.day == today.day)) {
        completedDays.add(today);
      }

      // Calculate streak
      final streakData = _calculateStreak(completedDays);

      // Calculate weekly progress (assuming goal of 5 activities per week)
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final activitiesThisWeek = updatedHistory.where((activity) {
        return activity.completedAt.isAfter(weekStart);
      }).length;
      final weeklyProgress = (activitiesThisWeek / 5.0).clamp(0.0, 1.0);

      // Check for badge unlocks
      final updatedBadges = _checkBadgeUnlocks(
        progress.earnedBadges,
        progress.totalActivitiesCompleted + 1,
        streakData['current']!,
      );

      // Update progress
      final updatedProgress = progress.copyWith(
        totalActivitiesCompleted: progress.totalActivitiesCompleted + 1,
        currentStreak: streakData['current'],
        longestStreak: streakData['longest'],
        completedDays: completedDays,
        recentHistory: updatedHistory,
        weeklyGoalProgress: weeklyProgress,
        earnedBadges: updatedBadges,
      );

      await saveProgressLocally(updatedProgress);
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException(
        'Failed to record activity completion: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> updateStreak(
    String userId,
    int currentStreak,
    int longestStreak,
  ) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 200));

      final progress = await getUserProgress(userId);
      final updatedProgress = progress.copyWith(
        currentStreak: currentStreak,
        longestStreak: longestStreak,
      );

      await saveProgressLocally(updatedProgress);
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException('Failed to update streak: ${e.toString()}');
    }
  }

  @override
  Future<void> unlockBadge(String userId, String badgeId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      final progress = await getUserProgress(userId);
      final updatedBadges = progress.earnedBadges.map((badge) {
        if (badge.id == badgeId && !badge.isUnlocked) {
          return badge.copyWith(
            isUnlocked: true,
            unlockedAt: DateTime.now(),
          );
        }
        return badge;
      }).toList();

      final updatedProgress = progress.copyWith(earnedBadges: updatedBadges);
      await saveProgressLocally(updatedProgress);
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException('Failed to unlock badge: ${e.toString()}');
    }
  }

  @override
  Future<void> saveProgressLocally(UserProgress progress) async {
    try {
      await HiveService.progressBox.put(progress.userId, progress);
    } catch (e) {
      throw UnknownException('Failed to save progress locally: ${e.toString()}');
    }
  }

  @override
  UserProgress? getProgressLocally(String userId) {
    try {
      return HiveService.progressBox.get(userId);
    } catch (e) {
      return null;
    }
  }

  // Helper methods

  Map<String, int> _calculateStreak(List<DateTime> completedDays) {
    if (completedDays.isEmpty) {
      return {'current': 0, 'longest': 0};
    }

    // Sort dates in descending order
    final sortedDays = List<DateTime>.from(completedDays)
      ..sort((a, b) => b.compareTo(a));

    int currentStreak = 1;
    int longestStreak = 1;
    int tempStreak = 1;

    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    // Check if streak is still active
    final mostRecent = sortedDays.first;
    final isToday = mostRecent.year == today.year &&
        mostRecent.month == today.month &&
        mostRecent.day == today.day;
    final isYesterday = mostRecent.year == yesterday.year &&
        mostRecent.month == yesterday.month &&
        mostRecent.day == yesterday.day;

    if (!isToday && !isYesterday) {
      currentStreak = 0;
    }

    // Calculate streaks
    for (int i = 0; i < sortedDays.length - 1; i++) {
      final current = sortedDays[i];
      final next = sortedDays[i + 1];
      final difference = current.difference(next).inDays;

      if (difference == 1) {
        tempStreak++;
        if (i == 0 && (isToday || isYesterday)) {
          currentStreak = tempStreak;
        }
      } else {
        if (tempStreak > longestStreak) {
          longestStreak = tempStreak;
        }
        tempStreak = 1;
      }
    }

    if (tempStreak > longestStreak) {
      longestStreak = tempStreak;
    }

    return {'current': currentStreak, 'longest': longestStreak};
  }

  List<Badge> _checkBadgeUnlocks(
    List<Badge> currentBadges,
    int totalActivities,
    int currentStreak,
  ) {
    return currentBadges.map((badge) {
      if (badge.isUnlocked) return badge;

      // Check unlock criteria based on badge ID
      bool shouldUnlock = false;

      switch (badge.id) {
        case 'first_activity':
          shouldUnlock = totalActivities >= 1;
          break;
        case 'five_activities':
          shouldUnlock = totalActivities >= 5;
          break;
        case 'ten_activities':
          shouldUnlock = totalActivities >= 10;
          break;
        case 'twenty_five_activities':
          shouldUnlock = totalActivities >= 25;
          break;
        case 'fifty_activities':
          shouldUnlock = totalActivities >= 50;
          break;
        case 'three_day_streak':
          shouldUnlock = currentStreak >= 3;
          break;
        case 'seven_day_streak':
          shouldUnlock = currentStreak >= 7;
          break;
        case 'thirty_day_streak':
          shouldUnlock = currentStreak >= 30;
          break;
      }

      if (shouldUnlock) {
        return badge.copyWith(
          isUnlocked: true,
          unlockedAt: DateTime.now(),
        );
      }

      return badge;
    }).toList();
  }

  List<Badge> _getInitialBadges() {
    return [
      Badge(
        id: 'first_activity',
        name: 'Getting Started',
        description: 'Complete your first activity',
        iconUrl: 'assets/icons/badges/first_activity.png',
        isUnlocked: false,
      ),
      Badge(
        id: 'five_activities',
        name: 'Wellness Explorer',
        description: 'Complete 5 activities',
        iconUrl: 'assets/icons/badges/five_activities.png',
        isUnlocked: false,
      ),
      Badge(
        id: 'ten_activities',
        name: 'Wellness Enthusiast',
        description: 'Complete 10 activities',
        iconUrl: 'assets/icons/badges/ten_activities.png',
        isUnlocked: false,
      ),
      Badge(
        id: 'twenty_five_activities',
        name: 'Wellness Champion',
        description: 'Complete 25 activities',
        iconUrl: 'assets/icons/badges/twenty_five_activities.png',
        isUnlocked: false,
      ),
      Badge(
        id: 'fifty_activities',
        name: 'Wellness Master',
        description: 'Complete 50 activities',
        iconUrl: 'assets/icons/badges/fifty_activities.png',
        isUnlocked: false,
      ),
      Badge(
        id: 'three_day_streak',
        name: 'Consistency Builder',
        description: 'Maintain a 3-day streak',
        iconUrl: 'assets/icons/badges/three_day_streak.png',
        isUnlocked: false,
      ),
      Badge(
        id: 'seven_day_streak',
        name: 'Week Warrior',
        description: 'Maintain a 7-day streak',
        iconUrl: 'assets/icons/badges/seven_day_streak.png',
        isUnlocked: false,
      ),
      Badge(
        id: 'thirty_day_streak',
        name: 'Dedication Legend',
        description: 'Maintain a 30-day streak',
        iconUrl: 'assets/icons/badges/thirty_day_streak.png',
        isUnlocked: false,
      ),
    ];
  }
}
