import 'package:hive/hive.dart';
import 'notification_preferences.dart';

part 'user.g.dart';

/// User model representing an employee account
@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String email;
  
  @HiveField(2)
  final String name;
  
  @HiveField(3)
  final String? company;
  
  @HiveField(4)
  final String? photoUrl;
  
  @HiveField(5)
  final List<String> wellnessGoals;
  
  @HiveField(6)
  final NotificationPreferences notifications;
  
  @HiveField(7)
  final int totalPoints;
  
  @HiveField(8)
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.company,
    this.photoUrl,
    required this.wellnessGoals,
    required this.notifications,
    required this.totalPoints,
    required this.createdAt,
  });

  /// Create from JSON
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

  /// Convert to JSON
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

  /// Create a copy with updated fields
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
