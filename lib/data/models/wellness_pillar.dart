/// Wellness pillar category for activities
class WellnessPillar {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final int availableActivities;

  const WellnessPillar({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.availableActivities,
  });

  /// Create from JSON
  factory WellnessPillar.fromJson(Map<String, dynamic> json) {
    return WellnessPillar(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconPath: json['iconPath'] as String,
      availableActivities: json['availableActivities'] as int? ?? 0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconPath': iconPath,
      'availableActivities': availableActivities,
    };
  }

  /// Create a copy with updated fields
  WellnessPillar copyWith({
    String? id,
    String? name,
    String? description,
    String? iconPath,
    int? availableActivities,
  }) {
    return WellnessPillar(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      availableActivities: availableActivities ?? this.availableActivities,
    );
  }
}
