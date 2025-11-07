import 'package:flutter/material.dart';
import 'animations.dart';

/// Example implementations demonstrating how to use AppAnimations utilities.
/// This file serves as documentation and reference for developers.

// Example 1: Using slide transition builder with GoRouter
// 
// GoRoute(
//   path: '/home',
//   pageBuilder: (context, state) => CustomTransitionPage(
//     child: HomeScreen(),
//     transitionsBuilder: AppAnimations.slideTransitionBuilder(),
//   ),
// )

// Example 2: Using fade transition builder
//
// GoRoute(
//   path: '/profile',
//   pageBuilder: (context, state) => CustomTransitionPage(
//     child: ProfileScreen(),
//     transitionsBuilder: AppAnimations.fadeTransitionBuilder(),
//   ),
// )

// Example 3: Using combined slide and fade transition
//
// GoRoute(
//   path: '/settings',
//   pageBuilder: (context, state) => CustomTransitionPage(
//     child: SettingsScreen(),
//     transitionsBuilder: AppAnimations.slideFadeTransitionBuilder(),
//   ),
// )

/// Example 4: Bounce animation for chips
class BounceChipExample extends StatefulWidget {
  const BounceChipExample({super.key});

  @override
  State<BounceChipExample> createState() => _BounceChipExampleState();
}

class _BounceChipExampleState extends State<BounceChipExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _controller = AppAnimations.createBounceController(this);
    _scaleAnimation = AppAnimations.createBounceAnimation(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    setState(() {
      _isSelected = !_isSelected;
    });
    AppAnimations.playBounceAnimation(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: _onTap,
        child: Chip(
          label: Text('Wellness Goal'),
          backgroundColor: _isSelected ? Colors.blue : Colors.grey[300],
        ),
      ),
    );
  }
}

/// Example 5: Progress bar animation
class ProgressBarExample extends StatefulWidget {
  const ProgressBarExample({super.key});

  @override
  State<ProgressBarExample> createState() => _ProgressBarExampleState();
}

class _ProgressBarExampleState extends State<ProgressBarExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AppAnimations.createProgressBarController(this);
    _progressAnimation = AppAnimations.createProgressAnimation(
      _controller,
      targetProgress: 0.75,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return LinearProgressIndicator(
          value: _progressAnimation.value,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        );
      },
    );
  }
}

/// Example 6: Card tap animation
class CardTapExample extends StatefulWidget {
  const CardTapExample({super.key});

  @override
  State<CardTapExample> createState() => _CardTapExampleState();
}

class _CardTapExampleState extends State<CardTapExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AppAnimations.createCardTapController(this);
    _scaleAnimation = AppAnimations.createCardTapAnimation(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    AppAnimations.playCardTapAnimation(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: _onTap,
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: const Text('Tap me!'),
          ),
        ),
      ),
    );
  }
}

/// Example 7: Badge unlock animation
class BadgeUnlockExample extends StatefulWidget {
  const BadgeUnlockExample({super.key});

  @override
  State<BadgeUnlockExample> createState() => _BadgeUnlockExampleState();
}

class _BadgeUnlockExampleState extends State<BadgeUnlockExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AppAnimations.createBadgeUnlockController(this);
    _scaleAnimation = AppAnimations.createBadgeUnlockAnimation(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _unlockBadge() {
    AppAnimations.playBadgeUnlockAnimation(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScaleTransition(
          scale: _scaleAnimation,
          child: const Icon(
            Icons.emoji_events,
            size: 64,
            color: Colors.amber,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _unlockBadge,
          child: const Text('Unlock Badge'),
        ),
      ],
    );
  }
}

/// Example 8: Fade animation
class FadeExample extends StatefulWidget {
  const FadeExample({super.key});

  @override
  State<FadeExample> createState() => _FadeExampleState();
}

class _FadeExampleState extends State<FadeExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AppAnimations.createFadeController(this);
    _fadeAnimation = AppAnimations.createFadeAnimation(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
    if (_isVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
            child: const Center(
              child: Text(
                'Hello!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _toggleVisibility,
          child: Text(_isVisible ? 'Hide' : 'Show'),
        ),
      ],
    );
  }
}
