# Activity Widgets

## ConfettiAnimation

The `ConfettiAnimation` widget uses Lottie animations to display a celebratory confetti effect when users complete activities.

### Implementation Details

- **Animation Source**: `assets/animations/confetti.json`
- **Duration**: Configurable (default: 1000ms)
- **Performance**: Lottie animations are hardware-accelerated and optimized for mobile devices
- **Callback**: Supports `onComplete` callback when animation finishes

### Usage

```dart
ConfettiAnimation(
  duration: const Duration(milliseconds: 1000),
  onComplete: () {
    // Handle animation completion
  },
)
```

### Performance Considerations

1. **Hardware Acceleration**: Lottie uses native rendering which is GPU-accelerated
2. **Memory Efficient**: The JSON animation file is small (~3KB) and loaded once
3. **Non-blocking**: Animation runs on a separate thread, doesn't block UI
4. **Optimized for Mobile**: Tested on various devices including low-end Android phones

### Testing

The animation has been tested on:
- iOS devices (iPhone SE and newer)
- Android devices (API 21+)
- Different screen sizes and densities

### Customization

To customize the confetti animation:
1. Edit `assets/animations/confetti.json` using a Lottie editor
2. Adjust colors in the JSON file to match brand colors
3. Modify particle count and animation paths as needed

### Alternative Animations

You can replace the confetti animation by:
1. Creating or downloading a new Lottie JSON file
2. Placing it in `assets/animations/`
3. Updating the asset path in the widget
