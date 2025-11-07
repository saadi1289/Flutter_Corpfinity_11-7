# Responsive Design and Accessibility Guide

This guide documents the responsive design and accessibility features implemented in the Corpfinity Employee App.

## Overview

The app implements comprehensive responsive design and accessibility features to ensure:
- Optimal layout on all screen sizes (320px to tablets)
- WCAG AA compliance (4.5:1 contrast ratio minimum)
- Screen reader support with semantic labels
- Minimum touch target sizes (44x44 logical pixels)
- Support for user text scale preferences
- Proper keyboard navigation and focus management

## Responsive Design

### Screen Breakpoints

The app uses the following breakpoints defined in `AppDimensions`:

- **Small**: 320px - 375px (iPhone SE, small phones)
- **Medium**: 376px - 414px (iPhone 12, standard phones)
- **Large**: 415px - 768px (iPhone Pro Max, large phones)
- **Tablet**: 768px+ (iPads, tablets)

### Responsive Utilities

#### `Responsive` Class (`lib/core/utils/responsive.dart`)

Provides methods for responsive sizing and layout adjustments:

```dart
final responsive = context.responsive;

// Check screen size
if (responsive.isSmallScreen) { ... }
if (responsive.isTablet) { ... }

// Get responsive values
final spacing = responsive.getResponsiveSpacing(16.0);
final fontSize = responsive.getResponsiveFontSize(14.0);
final columns = responsive.getGridColumns(defaultColumns: 2);

// Get responsive padding
final padding = responsive.getResponsivePadding();
```

#### `ResponsiveGrid` Widget

Automatically adjusts grid columns based on screen size:

```dart
ResponsiveGrid(
  defaultColumns: 2, // 1 on small, 2 on medium, 3 on tablet
  children: [
    // Grid items
  ],
)
```

#### `ResponsiveScaffold` Widget

Provides responsive padding and safe area handling:

```dart
ResponsiveScaffold(
  appBar: AppBar(title: Text('Title')),
  body: YourContent(),
  applyResponsivePadding: true,
  useSafeArea: true,
)
```

#### `ResponsiveText` Widget

Handles text scaling with user preferences:

```dart
ResponsiveText(
  'Hello World',
  style: AppTypography.bodyLarge,
  maxLines: 2,
)
```

### Layout Adjustments

The app automatically adjusts layouts based on screen size:

1. **Grid Columns**: 
   - Small screens: 1 column (for 2-column grids)
   - Medium/Large screens: 2 columns
   - Tablets: 3 columns

2. **Spacing**:
   - Small screens: 85% of base spacing
   - Medium/Large screens: 100% of base spacing
   - Tablets: 120% of base spacing

3. **Font Sizes**:
   - Small screens: 95% of base size
   - Medium/Large screens: 100% of base size
   - Tablets: 110% of base size

## Accessibility Features

### Semantic Labels

All interactive widgets include semantic labels for screen readers:

#### Energy Level Cards
```dart
EnergyLevelCard(
  energyLevel: EnergyLevel.medium,
  isSelected: true,
  onTap: () {},
)
// Announces: "Medium energy level, selected. Double tap to select."
```

#### Wellness Pillar Cards
```dart
WellnessPillarCard(
  name: 'Stress Reduction',
  description: 'Calm your mind',
  availableActivities: 5,
  onTap: () {},
)
// Announces: "Stress Reduction. Calm your mind. 5 activities available. Double tap to view activities."
```

#### Activity Cards
```dart
ActivityCard(
  name: 'Deep Breathing',
  durationMinutes: 3,
  difficulty: ActivityDifficulty.low,
  location: 'Anywhere',
  onTap: () {},
)
// Announces: "Deep Breathing. Duration: 3 minutes. Difficulty: Easy. Location: Anywhere. Double tap to start activity."
```

#### Buttons
```dart
CustomButton(
  text: 'Get Started',
  onPressed: () {},
  semanticLabel: 'Get started with wellness activities',
)
```

#### Progress Bars
```dart
AnimatedProgressBar(
  progress: 0.75,
  semanticLabel: 'Weekly goal progress',
)
// Announces: "Weekly goal progress: 75 percent complete"
```

### Minimum Touch Targets

All interactive elements meet the minimum 44x44 logical pixel requirement:

- Buttons automatically enforce minimum height
- Cards use `ConstrainedBox` with `minHeight: 44.0`
- Interactive elements wrapped with `AccessibilityUtils.withMinTouchTarget()`

### Color Contrast

All color combinations meet WCAG AA standards (4.5:1 minimum):

#### Validated Combinations

| Foreground | Background | Ratio | Status |
|------------|------------|-------|--------|
| Dark Text | White | 12.6:1 | ✓ Pass |
| Dark Text | Light Gray | 11.2:1 | ✓ Pass |
| Medium Gray | White | 4.7:1 | ✓ Pass |
| White | Calm Blue | 4.8:1 | ✓ Pass |
| White | Soft Green | 5.2:1 | ✓ Pass |
| White | Warm Orange | 4.6:1 | ✓ Pass |
| White | Gentle Red | 5.1:1 | ✓ Pass |

#### Testing Color Contrast

Use `ColorContrastValidator` to validate colors:

```dart
// Validate all app colors
final results = ColorContrastValidator.validateAppColors();

// Get specific contrast ratio
final ratio = ColorContrastValidator.getContrastRatio(
  AppColors.darkText,
  AppColors.white,
);

// Print validation results (development only)
ColorContrastValidator.printValidationResults();
```

### Text Scaling

The app supports user text scale preferences (0.8x to 2.0x):

- Text scale factor is clamped for optimal readability
- Layouts adjust to accommodate larger text
- All text widgets respect `MediaQuery.textScaleFactor`

### Screen Reader Support

All widgets include proper semantic information:

- Interactive elements marked with `Semantics(button: true)`
- Selected states announced: `Semantics(selected: true)`
- Decorative elements excluded: `ExcludeSemantics(child: ...)`
- Custom labels provided where needed

### Keyboard Navigation

- All interactive elements are focusable
- Tab order follows logical flow
- Focus indicators visible on all platforms

## Accessibility Utilities

### `AccessibilityUtils` Class

Provides helper methods for accessibility features:

```dart
// Create semantic labels
final label = AccessibilityUtils.getEnergyLevelSemanticLabel('Low', true);
final activityLabel = AccessibilityUtils.getActivitySemanticLabel(
  'Deep Breathing', 3, 'Easy', 'Anywhere'
);

// Check contrast ratios
final meetsStandard = AccessibilityUtils.meetsContrastRatio(
  AppColors.darkText,
  AppColors.white,
);

// Calculate contrast ratio
final ratio = AccessibilityUtils.calculateContrastRatio(color1, color2);

// Ensure minimum touch target
final widget = AccessibilityUtils.withMinTouchTarget(child);

// Announce to screen reader
AccessibilityUtils.announceToScreenReader(context, 'Activity completed!');

// Check if screen reader is enabled
if (AccessibilityUtils.isScreenReaderEnabled(context)) {
  // Provide additional context
}
```

### `AccessibilityTester` Class

Testing utilities for development:

```dart
// Generate accessibility report
final report = AccessibilityTester.generateReport(context);
print(report);

// Test color contrasts
final results = AccessibilityTester.testCommonContrasts();

// Check touch target size
final meetsSize = AccessibilityTester.meetsMinTouchTarget(Size(48, 48));
```

## Best Practices

### When Creating New Widgets

1. **Add Semantic Labels**: Always provide meaningful semantic labels for interactive elements
2. **Ensure Touch Targets**: Use `ConstrainedBox` or `AccessibilityUtils.withMinTouchTarget()`
3. **Exclude Decorative Elements**: Wrap decorative icons/images with `ExcludeSemantics`
4. **Test Contrast**: Verify color combinations meet 4.5:1 ratio
5. **Support Text Scaling**: Use `ResponsiveText` or test with different scale factors

### Example: Creating an Accessible Button

```dart
Semantics(
  label: 'Start activity',
  button: true,
  enabled: true,
  child: ConstrainedBox(
    constraints: BoxConstraints(minHeight: 44, minWidth: 44),
    child: ElevatedButton(
      onPressed: () {},
      child: Row(
        children: [
          ExcludeSemantics(child: Icon(Icons.play_arrow)),
          SizedBox(width: 8),
          Text('Start'),
        ],
      ),
    ),
  ),
)
```

### Example: Creating a Responsive Grid

```dart
ResponsiveGrid(
  defaultColumns: 2,
  children: items.map((item) => 
    WellnessPillarCard(
      name: item.name,
      description: item.description,
      availableActivities: item.count,
      onTap: () => handleTap(item),
    ),
  ).toList(),
)
```

## Testing

### Manual Testing Checklist

- [ ] Test on small screen (320px width)
- [ ] Test on medium screen (375px width)
- [ ] Test on large screen (414px width)
- [ ] Test on tablet (768px+ width)
- [ ] Test with text scale 1.0x, 1.5x, 2.0x
- [ ] Test with screen reader enabled (TalkBack/VoiceOver)
- [ ] Test with high contrast mode
- [ ] Test with reduce motion enabled
- [ ] Verify all interactive elements are 44x44 minimum
- [ ] Verify all text is readable at different scales
- [ ] Verify color contrast ratios

### Automated Testing

Run color contrast validation:

```dart
void main() {
  test('Color contrast validation', () {
    final results = ColorContrastValidator.validateAppColors();
    expect(results.values.every((passes) => passes), true);
  });
}
```

## Platform-Specific Considerations

### iOS
- Respects Dynamic Type settings
- VoiceOver support enabled
- Haptic feedback on interactions

### Android
- Respects font scale settings
- TalkBack support enabled
- Material Design touch targets

### Web
- Keyboard navigation support
- ARIA labels generated from Semantics
- Focus management

## Resources

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Flutter Accessibility](https://docs.flutter.dev/development/accessibility-and-localization/accessibility)
- [Material Design Accessibility](https://material.io/design/usability/accessibility.html)
- [iOS Human Interface Guidelines - Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)
