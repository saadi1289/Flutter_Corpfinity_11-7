import 'package:hive/hive.dart';

part 'activity_step.g.dart';

/// Individual step within an activity guide
@HiveType(typeId: 3)
class ActivityStep {
  @HiveField(0)
  final int stepNumber;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String instruction;
  
  @HiveField(3)
  final String? imageUrl;
  
  @HiveField(4)
  final int? timerSeconds;

  const ActivityStep({
    required this.stepNumber,
    required this.title,
    required this.instruction,
    this.imageUrl,
    this.timerSeconds,
  });

  /// Create from JSON
  factory ActivityStep.fromJson(Map<String, dynamic> json) {
    return ActivityStep(
      stepNumber: json['stepNumber'] as int,
      title: json['title'] as String,
      instruction: json['instruction'] as String,
      imageUrl: json['imageUrl'] as String?,
      timerSeconds: json['timerSeconds'] as int?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'stepNumber': stepNumber,
      'title': title,
      'instruction': instruction,
      'imageUrl': imageUrl,
      'timerSeconds': timerSeconds,
    };
  }

  /// Create a copy with updated fields
  ActivityStep copyWith({
    int? stepNumber,
    String? title,
    String? instruction,
    String? imageUrl,
    int? timerSeconds,
  }) {
    return ActivityStep(
      stepNumber: stepNumber ?? this.stepNumber,
      title: title ?? this.title,
      instruction: instruction ?? this.instruction,
      imageUrl: imageUrl ?? this.imageUrl,
      timerSeconds: timerSeconds ?? this.timerSeconds,
    );
  }
}
