import 'package:hive/hive.dart';
import 'badge.dart';
import 'completed_activity.dart';

part 'user_progress.g.dart';

/// User progress tracking including streaks and badges
@HiveType(typeId: 4)
class UserProgress {
  @HiveField(0)
  final String userId;
  
  @HiveField(1)
  final int currentStreak;
  
  @HiveField(2)
  final int longestStreak;
  
  @HiveField(3)
  final int totalActivitiesCompleted;
  
  @HiveField(4)
  final double weeklyGoalProgress;
  
  @HiveField(5)
  final List<DateTime> completedDays;
  
  @HiveField(6)
  final List<Badge> earnedBadges;
  
  @HiveField(7)
  final List<CompletedActivity> recentHistory;

  const UserProgress({
    required this.userId,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalActivitiesCompleted,
    required this.weeklyGoalProgress,
    required this.completedDays,
    required this.earnedBadges,
    required this.recentHistory,
  });

  /// Create from JSON
  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['userId'] as String,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      totalActivitiesCompleted: json['totalActivitiesCompleted'] as int? ?? 0,
      weeklyGoalProgress: (json['weeklyGoalProgress'] as num?)?.toDouble() ?? 0.0,
      completedDays: (json['completedDays'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          [],
      earnedBadges: (json['earnedBadges'] as List<dynamic>?)
              ?.map((e) => Badge.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recentHistory: (json['recentHistory'] as List<dynamic>?)
              ?.map((e) => CompletedActivity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'totalActivitiesCompleted': totalActivitiesCompleted,
      'weeklyGoalProgress': weeklyGoalProgress,
      'completedDays': completedDays.map((date) => date.toIso8601String()).toList(),
      'earnedBadges': earnedBadges.map((badge) => badge.toJson()).toList(),
      'recentHistory': recentHistory.map((activity) => activity.toJson()).toList(),
    };
  }

  /// Create a copy with updated fields
  UserProgress copyWith({
    String? userId,
    int? currentStreak,
    int? longestStreak,
    int? totalActivitiesCompleted,
    double? weeklyGoalProgress,
    List<DateTime>? completedDays,
    List<Badge>? earnedBadges,
    List<CompletedActivity>? recentHistory,
  }) {
    return UserProgress(
      userId: userId ?? this.userId,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalActivitiesCompleted: totalActivitiesCompleted ?? this.totalActivitiesCompleted,
      weeklyGoalProgress: weeklyGoalProgress ?? this.weeklyGoalProgress,
      completedDays: completedDays ?? this.completedDays,
      earnedBadges: earnedBadges ?? this.earnedBadges,
      recentHistory: recentHistory ?? this.recentHistory,
    );
  }
}
