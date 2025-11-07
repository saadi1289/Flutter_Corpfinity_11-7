/// Daily progress model for home screen
class DailyProgress {
  final int completedActivities;
  final int goalActivities;

  const DailyProgress({
    required this.completedActivities,
    required this.goalActivities,
  });

  /// Calculate progress percentage (0.0 to 1.0)
  double get progressPercentage {
    if (goalActivities == 0) return 0.0;
    return (completedActivities / goalActivities).clamp(0.0, 1.0);
  }

  /// Create from JSON
  factory DailyProgress.fromJson(Map<String, dynamic> json) {
    return DailyProgress(
      completedActivities: json['completedActivities'] as int,
      goalActivities: json['goalActivities'] as int,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'completedActivities': completedActivities,
      'goalActivities': goalActivities,
    };
  }

  /// Create a copy with updated fields
  DailyProgress copyWith({
    int? completedActivities,
    int? goalActivities,
  }) {
    return DailyProgress(
      completedActivities: completedActivities ?? this.completedActivities,
      goalActivities: goalActivities ?? this.goalActivities,
    );
  }
}
