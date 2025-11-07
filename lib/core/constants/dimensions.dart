/// AppDimensions defines spacing, border radius, and sizing constants
/// for the Corpfinity Employee App.
class AppDimensions {
  // Spacing Scale
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  static const double radiusCircular = 100.0;

  // Button Dimensions
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 40.0;
  static const double buttonHeightLarge = 56.0;
  static const double buttonBorderRadius = 12.0;

  // Card Dimensions
  static const double cardBorderRadius = 16.0;
  static const double cardElevation = 2.0;
  static const double cardPadding = 16.0;

  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // Touch Target Sizes (Accessibility)
  static const double minTouchTarget = 44.0;

  // Screen Padding
  static const double screenPaddingHorizontal = 16.0;
  static const double screenPaddingVertical = 20.0;

  // Grid Spacing
  static const double gridSpacing = 16.0;
  // Standardize both cross-axis and main-axis spacing to 16 for visual consistency
  static const double gridCrossAxisSpacing = 16.0;
  static const double gridMainAxisSpacing = 16.0;

  // Progress Bar
  static const double progressBarHeight = 8.0;
  static const double progressBarBorderRadius = 4.0;

  // Avatar Sizes
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 48.0;
  static const double avatarSizeLarge = 64.0;
  static const double avatarSizeXLarge = 96.0;

  // Divider
  static const double dividerThickness = 1.0;
  static const double dividerIndent = 16.0;

  // Shadow
  static const double shadowBlurRadius = 8.0;
  static const double shadowSpreadRadius = 0.0;
  static const double shadowOffsetY = 2.0;

  // Animation Durations (in milliseconds)
  // Subtle, purposeful motion durations
  static const int animationDurationShort = 160;
  static const int animationDurationMedium = 240;
  static const int animationDurationLong = 400;

  // Breakpoints for Responsive Design
  static const double breakpointSmall = 320.0;
  static const double breakpointMedium = 375.0;
  static const double breakpointLarge = 414.0;
  static const double breakpointTablet = 768.0;

  // Private constructor to prevent instantiation
  AppDimensions._();
}
