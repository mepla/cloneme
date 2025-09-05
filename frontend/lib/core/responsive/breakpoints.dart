import 'package:flutter/material.dart';

enum ScreenBreakpoint {
  mobile,         // < 640px  - Optimized for touch, compact layouts
  tablet,         // 640-768px - Mixed touch/mouse, moderate spacing
  desktop,        // 768-1024px - Mouse-primary, comfortable spacing  
  largeDesktop,   // > 1024px - Full desktop experience, generous spacing
}

enum ContentType {
  form,      // Login, signup, settings forms - focused, narrow
  reading,   // Articles, documentation - optimal reading width
  dashboard, // Home screens, admin panels - utilize full width
  general,   // Mixed content - balanced approach
}

class ScreenInfo {
  static ScreenBreakpoint getBreakpoint(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    
    if (width < 640) return ScreenBreakpoint.mobile;    // Mobile phones
    if (width < 768) return ScreenBreakpoint.tablet;    // Large phones, small tablets  
    if (width < 1024) return ScreenBreakpoint.desktop;  // Tablets, small laptops
    return ScreenBreakpoint.largeDesktop;               // Laptops, desktops, large screens
  }

  /// Content-based sizing that feels natural
  static double getMaxContentWidth(ScreenBreakpoint breakpoint, {ContentType type = ContentType.general}) {
    return switch (type) {
      ContentType.form => switch (breakpoint) {
        ScreenBreakpoint.mobile => double.infinity,     // Use full width
        ScreenBreakpoint.tablet => 480.0,              // Comfortable form width
        ScreenBreakpoint.desktop => 520.0,             // Slightly wider for better UX
        ScreenBreakpoint.largeDesktop => 560.0,        // Generous but focused
      },
      ContentType.dashboard => switch (breakpoint) {
        ScreenBreakpoint.mobile => double.infinity,     // Use full width
        ScreenBreakpoint.tablet => double.infinity,     // Let content flow naturally
        ScreenBreakpoint.desktop => double.infinity,    // Full dashboard experience
        ScreenBreakpoint.largeDesktop => double.infinity, // Full dashboard experience
      },
      ContentType.reading => switch (breakpoint) {
        ScreenBreakpoint.mobile => double.infinity,
        ScreenBreakpoint.tablet => 600.0,
        ScreenBreakpoint.desktop => 680.0,
        ScreenBreakpoint.largeDesktop => 720.0,
      },
      ContentType.general => switch (breakpoint) {
        ScreenBreakpoint.mobile => double.infinity,
        ScreenBreakpoint.tablet => 700.0,
        ScreenBreakpoint.desktop => 800.0,
        ScreenBreakpoint.largeDesktop => 900.0,
      },
    };
  }

  /// Fluid spacing that scales naturally across screen sizes
  static double getHorizontalPadding(ScreenBreakpoint breakpoint) {
    return switch (breakpoint) {
      ScreenBreakpoint.mobile => 16.0,      // Compact but readable
      ScreenBreakpoint.tablet => 24.0,      // More breathing room
      ScreenBreakpoint.desktop => 32.0,     // Comfortable spacing
      ScreenBreakpoint.largeDesktop => 40.0, // Generous spacing
    };
  }
  
  /// Adaptive spacing for component internals
  static EdgeInsetsGeometry getContentPadding(ScreenBreakpoint breakpoint) {
    return switch (breakpoint) {
      ScreenBreakpoint.mobile => const EdgeInsets.all(16.0),
      ScreenBreakpoint.tablet => const EdgeInsets.all(20.0),
      ScreenBreakpoint.desktop => const EdgeInsets.all(24.0),
      ScreenBreakpoint.largeDesktop => const EdgeInsets.all(32.0),
    };
  }
  
  /// Gap sizes for layouts (margins, spacing between elements)
  static double getLayoutGap(ScreenBreakpoint breakpoint) {
    return switch (breakpoint) {
      ScreenBreakpoint.mobile => 16.0,
      ScreenBreakpoint.tablet => 20.0,
      ScreenBreakpoint.desktop => 24.0,
      ScreenBreakpoint.largeDesktop => 32.0,
    };
  }

  /// Subtle text scaling - text should be readable but not dramatically different
  static double getTextScaleFactor(ScreenBreakpoint breakpoint) {
    return switch (breakpoint) {
      ScreenBreakpoint.mobile => 1.0,       // Base size
      ScreenBreakpoint.tablet => 1.05,      // Slightly larger  
      ScreenBreakpoint.desktop => 1.1,      // Comfortable increase
      ScreenBreakpoint.largeDesktop => 1.15, // Generous but not excessive
    };
  }

  /// Check if device primarily uses touch input
  static bool isTouchPrimary(BuildContext context) {
    final breakpoint = getBreakpoint(context);
    return breakpoint == ScreenBreakpoint.mobile;
  }

  /// Check if sidebar should be shown (desktop and up)
  static bool shouldShowSidebar(BuildContext context) {
    final breakpoint = getBreakpoint(context);
    return breakpoint.index >= 2; // desktop and largeDesktop
  }

  /// Check if hamburger menu should be shown (mobile and tablet)
  static bool shouldShowHamburger(BuildContext context) {
    final breakpoint = getBreakpoint(context);
    return breakpoint.index < 2; // mobile and tablet
  }
}