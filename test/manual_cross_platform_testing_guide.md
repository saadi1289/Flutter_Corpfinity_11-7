# Manual Cross-Platform Testing Guide

## Overview
This guide provides step-by-step instructions for manually testing cross-platform compatibility of the UI flow update on iOS and Android devices/simulators.

## Prerequisites

### iOS Testing
- macOS with Xcode installed
- iOS Simulator (iPhone SE, iPhone 14)
- Run: `open -a Simulator`

### Android Testing
- Android Studio with Android SDK
- Android Emulator (Pixel 5 or similar)
- Run: `flutter emulators` to list available emulators
- Run: `flutter emulators --launch <emulator_id>` to start

## Test Checklist

### 1. Icon Rendering Tests

#### iOS
- [ ] Launch app on iPhone SE simulator
- [ ] Navigate to Challenge Flow screen
- [ ] Verify all icons render correctly (energy, location, wellness goal icons)
- [ ] Check HeroCard profile icon displays correctly
- [ ] Verify icons are crisp and not pixelated

#### Android
- [ ] Launch app on Pixel 5 emulator
- [ ] Navigate to Challenge Flow screen
- [ ] Verify all icons render correctly
- [ ] Check HeroCard profile icon displays correctly
- [ ] Verify icons match iOS appearance

**Expected Result:** All icons should render clearly on both platforms with consistent appearance.

### 2. Animation and Transition Tests

#### iOS
- [ ] Open Challenge Flow screen
- [ ] Tap energy level card - verify scale animation (1.0 → 1.05)
- [ ] Verify glow effect appears on selection
- [ ] Check step transitions are smooth (300ms)
- [ ] Verify HeroCard progress bar animates on home screen load
- [ ] Check challenge display fade-in animation (400ms)

#### Android
- [ ] Repeat all animation tests from iOS
- [ ] Verify animations are smooth (60 FPS)
- [ ] Check for any frame drops or stuttering

**Expected Result:** All animations should be smooth and consistent across platforms.

### 3. Safe Area Handling Tests

#### iOS (iPhone with Notch)
- [ ] Test on iPhone 14 simulator (has notch)
- [ ] Verify home screen content doesn't overlap with notch
- [ ] Check Challenge Flow screen respects safe areas
- [ ] Verify login screen content is properly positioned
- [ ] Test in landscape orientation (if supported)

#### Android (Punch-hole Display)
- [ ] Test on device with punch-hole camera
- [ ] Verify content doesn't overlap with punch-hole
- [ ] Check status bar area is properly handled
- [ ] Test navigation bar area (bottom)

**Expected Result:** All content should respect safe areas and not overlap with system UI.

### 4. Touch Interaction Tests

#### iOS
- [ ] Verify all SelectionCards are easily tappable
- [ ] Check minimum touch target size (44x44px)
- [ ] Test button interactions (Generate Challenge, Start Challenge)
- [ ] Verify tap feedback is immediate

#### Android
- [ ] Verify all SelectionCards are easily tappable
- [ ] Check ripple effects appear on tap
- [ ] Test button interactions
- [ ] Verify Material Design ripple animations work

**Expected Result:** All interactive elements should be easily tappable with appropriate feedback.

### 5. Responsive Design Tests

#### iPhone SE (320x568 - Small Screen)
- [ ] Launch app on iPhone SE simulator
- [ ] Verify HeroCard adapts to smaller size
- [ ] Check avatar size is appropriate (56px)
- [ ] Verify Challenge Flow cards are scrollable
- [ ] Check text doesn't overflow
- [ ] Verify all content is accessible

#### iPhone 14 (390x844 - Large Screen)
- [ ] Launch app on iPhone 14 simulator
- [ ] Verify HeroCard uses larger size
- [ ] Check avatar size is appropriate (72px)
- [ ] Verify layout uses available space well
- [ ] Check spacing is appropriate

#### Pixel 5 (Android - Medium Screen)
- [ ] Launch app on Pixel 5 emulator
- [ ] Verify responsive sizing works correctly
- [ ] Check grid layouts adapt properly
- [ ] Verify scrolling works smoothly

**Expected Result:** UI should adapt gracefully to different screen sizes.

### 6. Navigation Tests

#### iOS
- [ ] Test swipe-back gesture from Challenge Flow screen
- [ ] Verify back button in AppBar works
- [ ] Check navigation to home screen works
- [ ] Test deep linking (if applicable)

#### Android
- [ ] Test hardware back button from Challenge Flow screen
- [ ] Verify back button in AppBar works
- [ ] Check navigation to home screen works
- [ ] Test app switching and return

**Expected Result:** Navigation should work consistently on both platforms.

### 7. Color Contrast Tests

#### Both Platforms
- [ ] Verify unselected SelectionCard text is readable
- [ ] Check selected SelectionCard text has good contrast (white on color)
- [ ] Verify HeroCard text is readable on gradient background
- [ ] Check all buttons have sufficient contrast
- [ ] Test in different lighting conditions (if on physical device)

**Expected Result:** All text should meet WCAG 4.5:1 contrast ratio minimum.

### 8. Performance Tests

#### iOS
- [ ] Monitor frame rate during animations (use Xcode Instruments)
- [ ] Check app launch time (< 500ms target for home screen)
- [ ] Verify smooth scrolling in Challenge Flow
- [ ] Test memory usage during navigation

#### Android
- [ ] Monitor frame rate using Android Profiler
- [ ] Check app launch time
- [ ] Verify smooth scrolling
- [ ] Test on lower-end device if available

**Expected Result:** App should maintain 60 FPS during animations and transitions.

## Testing Commands

### Run on iOS Simulator
```bash
# List available simulators
xcrun simctl list devices

# Run on specific simulator
flutter run -d <simulator_id>

# Run on iPhone SE
flutter run -d "iPhone SE (3rd generation)"

# Run on iPhone 14
flutter run -d "iPhone 14"
```

### Run on Android Emulator
```bash
# List available emulators
flutter emulators

# Launch emulator
flutter emulators --launch <emulator_id>

# Run on emulator
flutter run -d <emulator_id>

# Run on Pixel 5
flutter run -d emulator-5554
```

### Performance Profiling
```bash
# Run with performance overlay
flutter run --profile

# Run with timeline trace
flutter run --trace-startup
```

## Known Issues to Verify

Based on automated tests, verify these specific issues:

### 1. Layout Overflow on Small Screens
- **Location:** SelectionCard widget
- **Issue:** Column overflows by 42 pixels on bottom when constrained
- **Test:** Use iPhone SE simulator and check for yellow/black overflow indicators
- **Status:** Needs verification

### 2. HeroCard Layout on Large Screens
- **Location:** HeroCard widget
- **Issue:** Row overflows by 29 pixels on right
- **Test:** Use iPhone 14 simulator and check HeroCard rendering
- **Status:** Needs verification

### 3. Progress Bar Animation
- **Location:** HeroCard widget
- **Implementation:** Uses AnimatedProgressBar (not LinearProgressIndicator)
- **Test:** Verify progress bar animates smoothly on home screen load
- **Status:** Needs verification

## Reporting Issues

When reporting issues, include:
1. Platform (iOS/Android)
2. Device/Simulator model
3. Screen size
4. Steps to reproduce
5. Screenshot or screen recording
6. Expected vs actual behavior

## Sign-off Checklist

- [ ] All iOS tests completed
- [ ] All Android tests completed
- [ ] No critical issues found
- [ ] Performance meets requirements (60 FPS)
- [ ] Responsive design works on all tested screen sizes
- [ ] Navigation works correctly on both platforms
- [ ] Accessibility features verified
- [ ] Documentation updated with any findings

## Next Steps

After completing manual testing:
1. Document any issues found
2. Create bug reports for critical issues
3. Update automated tests based on findings
4. Verify fixes on both platforms
5. Get stakeholder approval for cross-platform compatibility
