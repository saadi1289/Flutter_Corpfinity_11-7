import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'animated_bottom_navigation.dart';

/// MainScaffold wraps screens with persistent bottom navigation
/// Use this for all main app screens to ensure navbar is always visible
class MainScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final Widget? floatingActionButton;

  const MainScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.backgroundColor,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    // Define navigation items
    final navigationItems = [
      const NavigationItem(
        icon: Icons.home_rounded,
        label: 'Home',
        route: '/home',
      ),
      const NavigationItem(
        icon: Icons.library_books_rounded,
        label: 'Library',
        route: '/library',
      ),
      const NavigationItem(
        icon: Icons.trending_up_rounded,
        label: 'Progress',
        route: '/progress',
      ),
      const NavigationItem(
        icon: Icons.person_rounded,
        label: 'Profile',
        route: '/profile',
      ),
    ];

    // Determine current index based on current route
    final currentRoute = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    for (int i = 0; i < navigationItems.length; i++) {
      if (currentRoute == navigationItems[i].route) {
        currentIndex = i;
        break;
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: child,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: AnimatedBottomNavigation(
        currentIndex: currentIndex,
        items: navigationItems,
        onTap: (index) {
          final route = navigationItems[index].route;
          if (currentRoute != route) {
            context.go(route);
          }
        },
      ),
    );
  }
}
