import 'package:flutter/material.dart';

/// AppColors defines the color palette for the Corpfinity Employee App.
/// All colors follow the design system specifications.
class AppColors {
  // Primary Colors
  static const Color calmBlue = Color(0xFF4A90E2);
  static const Color softGreen = Color(0xFF7ED321);
  static const Color warmOrange = Color(0xFFF5A623);
  static const Color gentleRed = Color(0xFFE85D75);
  static const Color neutralGray = Color(0xFFECF0F1);

  // Base Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkText = Color(0xFF2C3E50);
  static const Color mediumGray = Color(0xFF7F8C8D);
  static const Color lightGray = Color(0xFFF8F9FA);

  // Energy Level Colors
  static const Color energyLow = gentleRed;
  static const Color energyMedium = warmOrange;
  static const Color energyHigh = softGreen;

  // Location Context Colors
  static const Color professionalBlue = calmBlue;
  static const Color energeticRed = gentleRed;
  static const Color natureGreen = softGreen;

  // Wellness Goal Colors
  static const Color softPurple = Color(0xFF9B59B6);
  static const Color freshGreen = Color(0xFF27AE60);
  static const Color coralPink = Color(0xFFFF6B9D);

  // Difficulty Colors
  static const Color difficultyLow = softGreen;
  static const Color difficultyMedium = warmOrange;
  static const Color difficultyHigh = gentleRed;

  // Semantic Colors
  static const Color success = softGreen;
  static const Color warning = warmOrange;
  static const Color error = gentleRed;
  static const Color info = calmBlue;

  // Gradient Colors - Turquoise to White gradient used throughout the app
  static const List<Color> appGradient = [
    Color(0xFF64dfdf),
    Color(0xFF78e2e2),
    Color(0xFF8be6e5),
    Color(0xFF9be9e9),
    Color(0xFFabecec),
    Color(0xFFbaf0ef),
    Color(0xFFc8f3f2),
    Color(0xFFd6f6f5),
    Color(0xFFe4f9f9),
    Color(0xFFf2fcfc),
  ];
  
  // Shorter gradient variations for different use cases
  static const List<Color> primaryGradient = [
    Color(0xFF64dfdf),
    Color(0xFF9be9e9),
    Color(0xFFd6f6f5),
  ];
  
  static const List<Color> splashGradient = [
    Color(0xFF64dfdf),
    Color(0xFF8be6e5),
    Color(0xFFbaf0ef),
  ];
  
  static const List<Color> successGradient = [
    Color(0xFF78e2e2),
    Color(0xFFf2fcfc),
  ];

  // Private constructor to prevent instantiation
  AppColors._();
}
