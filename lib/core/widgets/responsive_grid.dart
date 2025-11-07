import 'package:flutter/material.dart';
import '../constants/dimensions.dart';
import '../utils/responsive.dart';

/// ResponsiveGrid is a grid widget that automatically adjusts column count
/// based on screen size for optimal layout on different devices.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int defaultColumns;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final EdgeInsets? padding;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.defaultColumns = 2,
    this.crossAxisSpacing = AppDimensions.gridCrossAxisSpacing,
    this.mainAxisSpacing = AppDimensions.gridMainAxisSpacing,
    this.childAspectRatio = 1.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final columns = responsive.getGridColumns(defaultColumns: defaultColumns);

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          padding: padding ?? responsive.getResponsivePadding(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: responsive.getResponsiveSpacing(crossAxisSpacing),
            mainAxisSpacing: responsive.getResponsiveSpacing(mainAxisSpacing),
            childAspectRatio: childAspectRatio,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}

/// ResponsiveSliverGrid is a sliver version of ResponsiveGrid for use in CustomScrollView
class ResponsiveSliverGrid extends StatelessWidget {
  final List<Widget> children;
  final int defaultColumns;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;

  const ResponsiveSliverGrid({
    super.key,
    required this.children,
    this.defaultColumns = 2,
    this.crossAxisSpacing = AppDimensions.gridCrossAxisSpacing,
    this.mainAxisSpacing = AppDimensions.gridMainAxisSpacing,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final columns = responsive.getGridColumns(defaultColumns: defaultColumns);

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: responsive.getResponsiveSpacing(crossAxisSpacing),
        mainAxisSpacing: responsive.getResponsiveSpacing(mainAxisSpacing),
        childAspectRatio: childAspectRatio,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => children[index],
        childCount: children.length,
      ),
    );
  }
}
