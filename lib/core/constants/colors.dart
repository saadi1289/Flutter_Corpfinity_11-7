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

  // Gradient Colors (for splash screen only)
  static const List<Color> splashGradient = [
    Color(0xFF667eea), // Soft purple
    Color(0xFF764ba2), // Deep purple
  ];
  static const List<Color> primaryGradient = [calmBlue, softGreen];
  static const List<Color> successGradient = [softGreen, white];

  // Private constructor to prevent instantiation
  AppColors._();
}
