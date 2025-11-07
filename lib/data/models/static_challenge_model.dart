import 'package:flutter/material.dart';
import 'enums.dart';

/// Static challenge model for pre-defined wellness challenges
/// These challenges are displayed immediately when a user selects a wellness area
class StaticChallengeModel {
  final String id;
  final WellnessGoal wellnessArea;
  final String title;
  final String goalDescription;
  final String duration;
  final IconData icon;
  final String motivationalText;
  final Color accentColor;

  const StaticChallengeModel({
    required this.id,
    required this.wellnessArea,
    required this.title,
    required this.goalDescription,
    required this.duration,
    required this.icon,
    required this.motivationalText,
    required this.accentColor,
  });

  /// Create from JSON
  factory StaticChallengeModel.fromJson(Map<String, dynamic> json) {
    return StaticChallengeModel(
      id: json['id'] as String,
      wellnessArea: WellnessGoal.values.firstWhere(
        (e) => e.name == json['wellnessArea'],
        orElse: () => WellnessGoal.stressReduction,
      ),
      title: json['title'] as String,
      goalDescription: json['goalDescription'] as String,
      duration: json['duration'] as String,
      icon: IconData(
        json['iconCodePoint'] as int,
        fontFamily: 'MaterialIcons',
      ),
      motivationalText: json['motivationalText'] as String,
      accentColor: Color(json['accentColor'] as int),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wellnessArea': wellnessArea.name,
      'title': title,
      'goalDescription': goalDescription,
      'duration': duration,
      'iconCodePoint': icon.codePoint,
      'motivationalText': motivationalText,
      'accentColor': accentColor.toARGB32(),
    };
  }

  /// Create a copy with updated fields
  StaticChallengeModel copyWith({
    String? id,
    WellnessGoal? wellnessArea,
    String? title,
    String? goalDescription,
    String? duration,
    IconData? icon,
    String? motivationalText,
    Color? accentColor,
  }) {
    return StaticChallengeModel(
      id: id ?? this.id,
      wellnessArea: wellnessArea ?? this.wellnessArea,
      title: title ?? this.title,
      goalDescription: goalDescription ?? this.goalDescription,
      duration: duration ?? this.duration,
      icon: icon ?? this.icon,
      motivationalText: motivationalText ?? this.motivationalText,
      accentColor: accentColor ?? this.accentColor,
    );
  }
}
