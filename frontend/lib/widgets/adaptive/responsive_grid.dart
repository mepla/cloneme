import 'package:flutter/material.dart';
import '../../core/adaptive/breakpoints.dart';

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    required this.children,
    this.spacing = 16.0,
    this.crossAxisCount,
    this.minItemWidth = 250.0,
    super.key,
  });
  
  final List<Widget> children;
  final double spacing;
  final int? crossAxisCount;
  final double minItemWidth;

  @override
  Widget build(BuildContext context) {
    final breakpoint = ScreenInfo.getBreakpoint(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final availableWidth = screenWidth - (ScreenInfo.getHorizontalPadding(breakpoint) * 2);
    
    // Calculate optimal column count if not specified
    int columns = crossAxisCount ?? _calculateColumns(availableWidth, breakpoint);
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: _getAspectRatio(breakpoint),
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
  
  int _calculateColumns(double availableWidth, ScreenBreakpoint breakpoint) {
    return switch (breakpoint) {
      ScreenBreakpoint.mobile => 1,
      ScreenBreakpoint.tablet => (availableWidth / minItemWidth).floor().clamp(2, 3),
      ScreenBreakpoint.desktop => (availableWidth / minItemWidth).floor().clamp(3, 4),
      ScreenBreakpoint.largeDesktop => (availableWidth / minItemWidth).floor().clamp(4, 6),
    };
  }
  
  double _getAspectRatio(ScreenBreakpoint breakpoint) {
    return switch (breakpoint) {
      ScreenBreakpoint.mobile => 1.2,      // Taller cards on mobile
      ScreenBreakpoint.tablet => 1.3,
      ScreenBreakpoint.desktop => 1.4,
      ScreenBreakpoint.largeDesktop => 1.5, // Wider cards on large screens
    };
  }
}