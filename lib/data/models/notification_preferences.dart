import 'package:hive/hive.dart';

part 'notification_preferences.g.dart';

/// User notification preferences
@HiveType(typeId: 1)
class NotificationPreferences {
  @HiveField(0)
  final bool enabled;
  
  @HiveField(1)
  final bool dailyReminders;
  
  @HiveField(2)
  final bool achievementAlerts;

  const NotificationPreferences({
    required this.enabled,
    required this.dailyReminders,
    required this.achievementAlerts,
  });

  /// Create from JSON
  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      enabled: json['enabled'] as bool? ?? true,
      dailyReminders: json['dailyReminders'] as bool? ?? true,
      achievementAlerts: json['achievementAlerts'] as bool? ?? true,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'dailyReminders': dailyReminders,
      'achievementAlerts': achievementAlerts,
    };
  }

  /// Create a copy with updated fields
  NotificationPreferences copyWith({
    bool? enabled,
    bool? dailyReminders,
    bool? achievementAlerts,
  }) {
    return NotificationPreferences(
      enabled: enabled ?? this.enabled,
      dailyReminders: dailyReminders ?? this.dailyReminders,
      achievementAlerts: achievementAlerts ?? this.achievementAlerts,
    );
  }
}
