import 'package:hive/hive.dart';
import 'activity_step.dart';
import 'enums.dart';

part 'activity.g.dart';

/// Wellness activity with guided steps
@HiveType(typeId: 2)
class Activity {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String pillarId;
  
  @HiveField(4)
  final int durationMinutes;
  
  @HiveField(5)
  final Difficulty difficulty;
  
  @HiveField(6)
  final String location;
  
  @HiveField(7)
  final String thumbnailUrl;
  
  @HiveField(8)
  final List<ActivityStep> steps;
  
  @HiveField(9)
  final List<String> tags;

  const Activity({
    required this.id,
    required this.name,
    required this.description,
    required this.pillarId,
    required this.durationMinutes,
    required this.difficulty,
    required this.location,
    required this.thumbnailUrl,
    required this.steps,
    required this.tags,
  });

  /// Create from JSON
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      pillarId: json['pillarId'] as String,
      durationMinutes: json['durationMinutes'] as int,
      difficulty: Difficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
        orElse: () => Difficulty.medium,
      ),
      location: json['location'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => ActivityStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pillarId': pillarId,
      'durationMinutes': durationMinutes,
      'difficulty': difficulty.name,
      'location': location,
      'thumbnailUrl': thumbnailUrl,
      'steps': steps.map((step) => step.toJson()).toList(),
      'tags': tags,
    };
  }

  /// Create a copy with updated fields
  Activity copyWith({
    String? id,
    String? name,
    String? description,
    String? pillarId,
    int? durationMinutes,
    Difficulty? difficulty,
    String? location,
    String? thumbnailUrl,
    List<ActivityStep>? steps,
    List<String>? tags,
  }) {
    return Activity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      pillarId: pillarId ?? this.pillarId,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      difficulty: difficulty ?? this.difficulty,
      location: location ?? this.location,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      steps: steps ?? this.steps,
      tags: tags ?? this.tags,
    );
  }
}
