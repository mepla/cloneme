import 'package:flutter/material.dart';
import '../../core/adaptive/breakpoints.dart';

/// Philosophy: Web-first fluid design that progressively enhances for mobile
class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    required this.child,
    this.contentType = ContentType.general,
    this.centerContent = true,
    super.key,
  });
  
  final Widget child;
  final ContentType contentType;
  final bool centerContent;

  @override
  Widget build(BuildContext context) {
    final breakpoint = ScreenInfo.getBreakpoint(context);
    final maxWidth = ScreenInfo.getMaxContentWidth(breakpoint, type: contentType);
    final horizontalPadding = ScreenInfo.getHorizontalPadding(breakpoint);
    
    Widget content = Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: child,
    );
    
    // Apply max width constraints only when beneficial
    if (maxWidth != double.infinity) {
      content = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: content,
      );
    }
    
    // Center content on larger screens for visual balance
    if (centerContent && breakpoint.index >= 1) {
      content = Center(child: content);
    }
    
    return content;
  }
}

// For authentication screens - optimal form UX
class FormContainer extends StatelessWidget {
  const FormContainer({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      contentType: ContentType.form,
      child: child,
    );
  }
}

// For home/admin screens - utilize full screen width
class DashboardContainer extends StatelessWidget {
  const DashboardContainer({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      contentType: ContentType.dashboard,
      centerContent: false, // Dashboards should use full width
      child: child,
    );
  }
}