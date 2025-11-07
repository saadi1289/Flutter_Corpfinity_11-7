/// User model representing an authenticated user
class User {
  final String id;
  final String email;
  final String name;
  final String? company;
  final String? photoUrl;
  final List<String> wellnessGoals;
  final NotificationPreferences notifications;
  final int totalPoints;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.company,
    this.photoUrl,
    required this.wellnessGoals,
    required this.notifications,
    this.totalPoints = 0,
    required this.createdAt,
  });

  /// Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      company: json['company'] as String?,
      photoUrl: json['photoUrl'] as String?,
      wellnessGoals: (json['wellnessGoals'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      notifications: NotificationPreferences.fromJson(
        json['notifications'] as Map<String, dynamic>? ?? {},
      ),
      totalPoints: json['totalPoints'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'company': company,
      'photoUrl': photoUrl,
      'wellnessGoals': wellnessGoals,
      'notifications': notifications.toJson(),
      'totalPoints': totalPoints,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create a copy of User with updated fields
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? company,
    String? photoUrl,
    List<String>? wellnessGoals,
    NotificationPreferences? notifications,
    int? totalPoints,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      company: company ?? this.company,
      photoUrl: photoUrl ?? this.photoUrl,
      wellnessGoals: wellnessGoals ?? this.wellnessGoals,
      notifications: notifications ?? this.notifications,
      totalPoints: totalPoints ?? this.totalPoints,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Notification preferences for a user
class NotificationPreferences {
  final bool enabled;
  final bool dailyReminders;
  final bool achievementAlerts;

  NotificationPreferences({
    this.enabled = true,
    this.dailyReminders = true,
    this.achievementAlerts = true,
  });

  /// Create NotificationPreferences from JSON
  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      enabled: json['enabled'] as bool? ?? true,
      dailyReminders: json['dailyReminders'] as bool? ?? true,
      achievementAlerts: json['achievementAlerts'] as bool? ?? true,
    );
  }

  /// Convert NotificationPreferences to JSON
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

/// SSO Provider enum
enum SSOProvider {
  google,
  microsoft,
}
