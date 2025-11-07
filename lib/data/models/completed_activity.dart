import 'package:hive/hive.dart';

part 'completed_activity.g.dart';

/// Record of a completed activity
@HiveType(typeId: 6)
class CompletedActivity {
  @HiveField(0)
  final String activityId;
  
  @HiveField(1)
  final String activityName;
  
  @HiveField(2)
  final DateTime completedAt;
  
  @HiveField(3)
  final int pointsEarned;

  const CompletedActivity({
    required this.activityId,
    required this.activityName,
    required this.completedAt,
    required this.pointsEarned,
  });

  /// Create from JSON
  factory CompletedActivity.fromJson(Map<String, dynamic> json) {
    return CompletedActivity(
      activityId: json['activityId'] as String,
      activityName: json['activityName'] as String,
      completedAt: DateTime.parse(json['completedAt'] as String),
      pointsEarned: json['pointsEarned'] as int? ?? 0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'activityId': activityId,
      'activityName': activityName,
      'completedAt': completedAt.toIso8601String(),
      'pointsEarned': pointsEarned,
    };
  }

  /// Create a copy with updated fields
  CompletedActivity copyWith({
    String? activityId,
    String? activityName,
    DateTime? completedAt,
    int? pointsEarned,
  }) {
    return CompletedActivity(
      activityId: activityId ?? this.activityId,
      activityName: activityName ?? this.activityName,
      completedAt: completedAt ?? this.completedAt,
      pointsEarned: pointsEarned ?? this.pointsEarned,
    );
  }
}
