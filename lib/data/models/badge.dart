import 'package:hive/hive.dart';

part 'badge.g.dart';

/// Achievement badge earned by completing milestones
@HiveType(typeId: 5)
class Badge {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String iconUrl;
  
  @HiveField(4)
  final bool isUnlocked;
  
  @HiveField(5)
  final DateTime? unlockedAt;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.isUnlocked,
    this.unlockedAt,
  });

  /// Create from JSON
  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconUrl: json['iconUrl'] as String,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconUrl': iconUrl,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  Badge copyWith({
    String? id,
    String? name,
    String? description,
    String? iconUrl,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Badge(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}
