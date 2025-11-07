/// User profile model for home screen hero card
class UserProfile {
  final String name;
  final String? imageUrl;
  final int level;
  final double levelProgress;

  const UserProfile({
    required this.name,
    this.imageUrl,
    required this.level,
    required this.levelProgress,
  });

  /// Create from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      level: json['level'] as int,
      levelProgress: (json['levelProgress'] as num).toDouble(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'level': level,
      'levelProgress': levelProgress,
    };
  }

  /// Create a copy with updated fields
  UserProfile copyWith({
    String? name,
    String? imageUrl,
    int? level,
    double? levelProgress,
  }) {
    return UserProfile(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      level: level ?? this.level,
      levelProgress: levelProgress ?? this.levelProgress,
    );
  }
}
