import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// ResponsiveScaffold is a wrapper around Scaffold that provides
/// responsive padding and safe area handling.
class ResponsiveScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Color? backgroundColor;
  final bool useSafeArea;
  final bool applyResponsivePadding;
  final EdgeInsets? customPadding;

  const ResponsiveScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.backgroundColor,
    this.useSafeArea = true,
    this.applyResponsivePadding = false,
    this.customPadding,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    Widget content = body;

    // Apply responsive padding if requested
    if (applyResponsivePadding) {
      content = Padding(
        padding: customPadding ?? responsive.getResponsivePadding(),
        child: content,
      );
    }

    // Apply safe area if requested
    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return Scaffold(
      appBar: appBar,
      body: content,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      backgroundColor: backgroundColor,
    );
  }
}
