# Flutter Multiplatform Development Guide

## Core Philosophy: Web-First, Fluid Design

**CRITICAL PRINCIPLE**: Design for the web first, then progressively enhance for smaller screens. This is the opposite of mobile-first design and is essential for preventing cramped, overflow-prone layouts on larger screens.

### The Fundamental Mistake: Mobile-First Constraints

❌ **NEVER DO THIS:**
```dart
// This creates cramped web experiences
final maxWidth = switch (breakpoint) {
  ScreenBreakpoint.mobile => double.infinity,
  ScreenBreakpoint.tablet => 400.0,  // Too narrow!
  ScreenBreakpoint.desktop => 450.0, // Still too narrow!
  ScreenBreakpoint.largeDesktop => 500.0, // Web feels cramped
};
```

✅ **DO THIS INSTEAD:**
```dart
// Content-based sizing that feels natural
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
      ScreenBreakpoint.desktop => 1200.0,            // Wide dashboard layout
      ScreenBreakpoint.largeDesktop => 1400.0,       // Full dashboard experience
    },
    // ... more content types
  };
}
```

### Why Web-First Works Better

1. **Natural Sizing**: Web layouts feel spacious and professional, not cramped
2. **No Overflow Issues**: Content has room to breathe and expand naturally
3. **Better UX**: Users expect web applications to use available space effectively
4. **Progressive Enhancement**: Smaller screens get enhanced constraints, not artificial limitations
5. **Content-Aware**: Different types of content get appropriate sizing (forms vs dashboards)

## Modern Breakpoint System

Use modern, sensible breakpoints that align with contemporary web standards:

```dart
class ScreenInfo {
  static ScreenBreakpoint getBreakpoint(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    
    if (width < 640) return ScreenBreakpoint.mobile;    // Mobile phones
    if (width < 768) return ScreenBreakpoint.tablet;    // Large phones, small tablets  
    if (width < 1024) return ScreenBreakpoint.desktop;  // Tablets, small laptops
    return ScreenBreakpoint.largeDesktop;               // Laptops, desktops, large screens
  }
}

enum ScreenBreakpoint {
  mobile,         // < 640px  - Optimized for touch, compact layouts
  tablet,         // 640-768px - Mixed touch/mouse, moderate spacing
  desktop,        // 768-1024px - Mouse-primary, comfortable spacing  
  largeDesktop,   // > 1024px - Full desktop experience, generous spacing
}
```

**Why these breakpoints:**
- **640px**: True mobile boundary, aligns with modern CSS frameworks
- **768px**: Tablet portrait mode, where layouts start expanding
- **1024px**: Desktop boundary where full layouts become possible
- Above 1024px: Large desktop experience with maximum spacing

## Content-Based Layout Strategy

Different types of content need different sizing approaches:

### Content Types

```dart
enum ContentType {
  form,      // Login, signup, settings forms - focused, narrow
  reading,   // Articles, documentation - optimal reading width
  dashboard, // Home screens, admin panels - utilize full width
  general,   // Mixed content - balanced approach
}

enum GridType {
  card,      // Card-based layouts - moderate density
  dense,     // Data tables, lists - high information density
}
```

### Responsive Container Architecture

```dart
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
```

### Specialized Containers

```dart
// For authentication screens - optimal form UX
class FormContainer extends StatelessWidget {
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
  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      contentType: ContentType.dashboard,
      centerContent: false, // Dashboards should use full width
      child: child,
    );
  }
}
```

## Fluid Spacing System

Spacing should scale naturally with screen size, not jump between arbitrary values:

```dart
class ScreenInfo {
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
}
```

## Typography Scaling: Subtle and Natural

Text should scale subtly across screen sizes - dramatic differences feel jarring:

```dart
/// Subtle text scaling - text should be readable but not dramatically different
static double getTextScaleFactor(ScreenBreakpoint breakpoint) {
  return switch (breakpoint) {
    ScreenBreakpoint.mobile => 1.0,       // Base size
    ScreenBreakpoint.tablet => 1.05,      // Slightly larger  
    ScreenBreakpoint.desktop => 1.1,      // Comfortable increase
    ScreenBreakpoint.largeDesktop => 1.15, // Generous but not excessive
  };
}
```

## Responsive Text Component

```dart
class ResponsiveText extends StatelessWidget {
  const ResponsiveText(
    this.text, {
    this.style,
    this.maxLines,
    this.textAlign,
    super.key,
  });
  
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final breakpoint = ScreenInfo.getBreakpoint(context);
    final scaleFactor = ScreenInfo.getTextScaleFactor(breakpoint);
    
    return AutoSizeText(
      text,
      style: (style ?? Theme.of(context).textTheme.bodyLarge)?.copyWith(
        fontSize: (style?.fontSize ?? 16) * scaleFactor,
      ),
      maxLines: maxLines,
      minFontSize: 12,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }
}
```

## Adaptive Input Handling

Support both touch and mouse/keyboard input seamlessly:

```dart
class AdaptiveButton extends StatefulWidget {
  const AdaptiveButton({
    required this.onPressed,
    required this.child,
    this.style,
    this.tooltip,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;
  final String? tooltip;

  @override
  State<AdaptiveButton> createState() => _AdaptiveButtonState();
}

class _AdaptiveButtonState extends State<AdaptiveButton> {
  bool _isHovered = false;
  
  @override
  Widget build(BuildContext context) {
    final isTouchPrimary = ScreenInfo.isTouchPrimary(context);
    
    Widget button = ElevatedButton(
      onPressed: widget.onPressed,
      style: widget.style?.copyWith(
        visualDensity: MaterialStateProperty.all(
          isTouchPrimary ? VisualDensity.comfortable : VisualDensity.compact,
        ),
      ),
      child: widget.child,
    );
    
    // Enhanced mouse support for non-touch devices
    if (!isTouchPrimary) {
      button = MouseRegion(
        cursor: widget.onPressed != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: _isHovered && widget.onPressed != null ? [
              BoxShadow(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ] : null,
          ),
          child: button,
        ),
      );
      
      if (widget.tooltip != null) {
        button = Tooltip(
          message: widget.tooltip!,
          child: button,
        );
      }
    }
    
    return button;
  }
}
```

## Layout Patterns

### Dashboard Layouts

For home screens and admin panels, use full width effectively:

```dart
Widget _buildDashboardContent(BuildContext context) {
  final breakpoint = ScreenInfo.getBreakpoint(context);
  final isLargeScreen = breakpoint.index >= 2; // desktop or larger
  final gap = ScreenInfo.getLayoutGap(breakpoint);
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch, // Use full width
    children: [
      SizedBox(height: gap * 2),
      
      // Hero Section - centers itself
      _buildHeroSection(context),
      
      SizedBox(height: gap * 3),
      
      // Content utilizes available space
      if (isLargeScreen)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildUserInfoCard(context)),
            SizedBox(width: gap),
            Expanded(child: _buildActionsCard(context)),
          ],
        )
      else
        Column(
          children: [
            _buildUserInfoCard(context),
            SizedBox(height: gap),
            _buildActionsCard(context),
          ],
        ),
        
      SizedBox(height: gap * 2),
    ],
  );
}
```

### Form Layouts

For authentication and settings forms, use focused widths:

```dart
class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FormContainer( // Automatically handles appropriate form widths
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Form content naturally fits within appropriate constraints
                _buildLogo(),
                _buildEmailField(),
                _buildPasswordField(),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## State Management Integration

Use BLoC for managing layout state:

```dart
class LayoutBloc extends Bloc<LayoutEvent, LayoutState> {
  LayoutBloc() : super(const LayoutState.initial()) {
    on<ScreenSizeChanged>(_onScreenSizeChanged);
  }

  void _onScreenSizeChanged(ScreenSizeChanged event, Emitter<LayoutState> emit) {
    final breakpoint = _getBreakpoint(event.size);
    final config = AdaptiveLayoutConfig(
      breakpoint: breakpoint,
      isTouchPrimary: event.size.shortestSide < 640,
      showSidebar: breakpoint.index >= 2, // desktop and up
      useBottomNavigation: breakpoint == ScreenBreakpoint.mobile,
    );
    
    emit(LayoutState.configured(config));
  }

  ScreenBreakpoint _getBreakpoint(Size size) {
    final width = size.width;
    if (width < 640) return ScreenBreakpoint.mobile;
    if (width < 768) return ScreenBreakpoint.tablet;
    if (width < 1024) return ScreenBreakpoint.desktop;
    return ScreenBreakpoint.largeDesktop;
  }
}
```

## App Initialization

Set up the responsive foundation:

```dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LayoutBloc>(
          create: (context) => LayoutBloc(),
        ),
        // Other BLoCs...
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // Base mobile design reference
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Responsive App',
            theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              useMaterial3: true,
            ),
            home: LayoutBuilder(
              builder: (context, constraints) {
                // Trigger layout changes
                final size = Size(constraints.maxWidth, constraints.maxHeight);
                context.read<LayoutBloc>().add(ScreenSizeChanged(size));
                
                return MyHomePage();
              },
            ),
          );
        },
      ),
    );
  }
}
```

## Essential Dependencies

```yaml
dependencies:
  # Responsive utilities
  flutter_screenutil: ^5.9.3      # For consistent sizing
  auto_size_text: ^3.0.0          # For responsive text
  adaptive_breakpoints: ^0.1.7     # Additional breakpoint utilities
  
  # State management
  flutter_bloc: ^8.1.3            # For layout and app state
  equatable: ^2.0.5               # For state comparison
  
  # Optional enhancements  
  responsive_framework: ^1.5.1     # Additional responsive utilities
```

## Key Principles to Remember

### ✅ DO:
1. **Design web-first**: Start with generous spacing and sizing
2. **Use content-based constraints**: Forms, dashboards, reading content have different needs
3. **Scale spacing fluidly**: Don't jump between drastically different values
4. **Support all input methods**: Touch, mouse, keyboard seamlessly
5. **Test across breakpoints**: Ensure layouts feel natural at every size
6. **Use semantic containers**: FormContainer, DashboardContainer, etc.
7. **Progressive enhancement**: Enhance smaller screens, don't constrain larger ones

### ❌ NEVER:
1. **Start with mobile constraints**: This creates cramped web experiences
2. **Use arbitrary small max-widths**: 400px desktop forms feel cramped
3. **Ignore content type**: All content is not the same
4. **Create dramatic text scaling**: 1.0 → 1.4 feels jarring  
5. **Forget overflow prevention**: Use Wrap instead of Row where appropriate
6. **Assume touch-only input**: Support mouse and keyboard
7. **Test only on mobile**: Web users have different expectations

### The Web-First Mindset:

- **Web users expect**: Spacious layouts, full utilization of screen space, mouse/keyboard support
- **Mobile users expect**: Touch-optimized UI, appropriate sizing for thumbs
- **Solution**: Start with excellent web experience, progressively enhance for mobile constraints

## File Structure

```
lib/
├── core/
│   └── adaptive/
│       ├── breakpoints.dart          # ScreenInfo class with ContentType enum
│       └── content_types.dart        # ContentType and GridType definitions
├── widgets/
│   └── adaptive/
│       ├── responsive_container.dart  # Base responsive container
│       ├── form_container.dart       # Specialized form container  
│       ├── dashboard_container.dart  # Specialized dashboard container
│       ├── adaptive_button.dart      # Touch/mouse aware button
│       └── responsive_text.dart      # Responsive text component
├── blocs/
│   └── layout/
│       ├── layout_bloc.dart          # Layout state management
│       ├── layout_event.dart         # Layout events
│       └── layout_state.dart         # Layout states
└── screens/
    ├── auth/                         # Uses FormContainer
    └── home/                         # Uses DashboardContainer
```

## Testing Strategy

Test all breakpoints to ensure natural feel:

```dart
class ResponsiveTestHelper {
  static const Size mobileSize = Size(375, 667);     // iPhone SE
  static const Size tabletSize = Size(768, 1024);    // iPad
  static const Size desktopSize = Size(1200, 800);   // Desktop
  static const Size largeSize = Size(1920, 1080);    // Large desktop

  static Widget wrapWithMediaQuery(Widget widget, Size size) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: size),
        child: widget,
      ),
    );
  }
}

testWidgets('dashboard should utilize full width on large screens', (tester) async {
  await tester.pumpWidget(
    ResponsiveTestHelper.wrapWithMediaQuery(
      DashboardContainer(child: TestWidget()),
      ResponsiveTestHelper.largeSize,
    ),
  );
  
  // Verify layout uses available space effectively
  expect(find.text('Should not be cramped'), findsOneWidget);
});
```

---

**Remember**: This web-first approach prevents the cramped, overflow-prone layouts that occur when mobile-first constraints are applied to web interfaces. Content should feel natural and spacious on large screens while remaining functional and touch-friendly on mobile devices.