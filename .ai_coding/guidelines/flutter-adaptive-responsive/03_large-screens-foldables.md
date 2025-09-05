# Large Screens & Foldables

Supporting large screens and foldable devices is crucial for modern Flutter applications. As of January 2024, there are over 270 million active large screen Android devices, making this a significant user base.

## Device Categories

Large screens include:
- Tablets (iPad, Android tablets)
- Foldable phones (Galaxy Fold, Pixel Fold)
- ChromeOS devices
- Desktop computers
- Web browsers on large displays

## Why Support Large Screens?

1. **Market Reach**: Over 270 million active large screen Android devices
2. **User Engagement**: Higher engagement metrics on larger screens
3. **App Store Visibility**: Better ranking and featuring opportunities
4. **Platform Requirements**: App Store submission compliance for iPad support
5. **User Experience**: Users expect apps to utilize available screen space effectively

## Layout Guidelines

### Grid vs List Layouts

Replace single-column lists with grids on large screens:

```dart
class AdaptiveGrid extends StatelessWidget {
  final List<Item> items;
  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200, // Maximum width per item
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => ItemCard(items[index]),
    );
  }
}
```

### Dynamic Column Counts

Never hardcode column counts. Calculate based on available space:

```dart
class ResponsiveGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    
    // Calculate columns based on minimum item width
    final columns = (width / 200).floor().clamp(1, 6);
    
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      // ...
    );
  }
}
```

### Content Width Management

Avoid stretching content across the entire width on large screens:

```dart
class ConstrainedContent extends StatelessWidget {
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 1200),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: child,
      ),
    );
  }
}
```

## Foldable Device Support

### Handling Display Features

Use the Display API to detect and respond to foldable features:

```dart
import 'dart:ui' as ui;

class FoldAwareWidget extends StatefulWidget {
  @override
  State<FoldAwareWidget> createState() => _FoldAwareWidgetState();
}

class _FoldAwareWidgetState extends State<FoldAwareWidget> 
    with WidgetsBindingObserver {
  ui.FlutterView? _view;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _view = View.maybeOf(context);
  }
  
  @override
  void didChangeMetrics() {
    final ui.Display? display = _view?.display;
    // Handle display changes (fold/unfold events)
    if (display != null) {
      setState(() {
        // Update UI based on display configuration
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Build adaptive UI based on display state
    return YourAdaptiveUI();
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
```

### Orientation Support

**Never lock screen orientation** for foldable devices:

```dart
// ❌ BAD - Don't do this
SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
]);

// ✅ GOOD - Support all orientations
SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown,
  DeviceOrientation.landscapeLeft,
  DeviceOrientation.landscapeRight,
]);
```

## Navigation Patterns

Adapt navigation based on screen size:

```dart
class AdaptiveNavigation extends StatelessWidget {
  final int selectedIndex;
  final List<NavigationDestination> destinations;
  final Widget body;
  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    
    if (width < 600) {
      // Mobile: Bottom navigation
      return Scaffold(
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          destinations: destinations,
        ),
      );
    } else if (width < 1200) {
      // Tablet: Navigation rail
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              destinations: destinations.map((d) => 
                NavigationRailDestination(
                  icon: d.icon,
                  label: Text(d.label),
                )
              ).toList(),
            ),
            VerticalDivider(thickness: 1, width: 1),
            Expanded(child: body),
          ],
        ),
      );
    } else {
      // Desktop: Extended navigation rail or drawer
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: true, // Show labels next to icons
              selectedIndex: selectedIndex,
              destinations: destinations.map((d) => 
                NavigationRailDestination(
                  icon: d.icon,
                  label: Text(d.label),
                )
              ).toList(),
            ),
            VerticalDivider(thickness: 1, width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }
  }
}
```

## Input Adaptation

### Mouse and Trackpad Support

Large screens often have mice or trackpads:

```dart
class HoverableCard extends StatefulWidget {
  final Widget child;
  
  @override
  State<HoverableCard> createState() => _HoverableCardState();
}

class _HoverableCardState extends State<HoverableCard> {
  bool _isHovered = false;
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..scale(_isHovered ? 1.05 : 1.0),
        child: widget.child,
      ),
    );
  }
}
```

### Stylus Support

Support stylus input for devices with pen support:

```dart
class DrawingCanvas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        // Handle both touch and stylus input
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final localPosition = renderBox.globalToLocal(details.globalPosition);
        
        // Check if input is from stylus
        if (details.kind == PointerDeviceKind.stylus) {
          // Apply pressure sensitivity
          final pressure = details.pressure ?? 1.0;
          // Draw with pressure-adjusted stroke
        }
      },
      child: CustomPaint(
        painter: CanvasPainter(),
      ),
    );
  }
}
```

## Material 3 Components

Use Material 3 components for built-in adaptive behavior:

```dart
MaterialApp(
  theme: ThemeData(
    useMaterial3: true, // Enable Material 3
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  ),
  // Material 3 components automatically adapt to different screen sizes
)
```

## Responsive Breakpoints

Material Design recommended breakpoints:

```dart
class Breakpoints {
  static const double mobile = 600;      // < 600px: Mobile
  static const double tablet = 840;      // 600-840px: Tablet
  static const double desktop = 1200;    // 840-1200px: Small desktop
  static const double largeDesktop = 1600; // > 1200px: Large desktop
}

enum ScreenSize {
  mobile,
  tablet,
  desktop,
  largeDesktop,
}

extension ScreenSizeExtension on BuildContext {
  ScreenSize get screenSize {
    final width = MediaQuery.sizeOf(this).width;
    if (width < Breakpoints.mobile) return ScreenSize.mobile;
    if (width < Breakpoints.tablet) return ScreenSize.tablet;
    if (width < Breakpoints.desktop) return ScreenSize.desktop;
    return ScreenSize.largeDesktop;
  }
}
```

## Testing on Large Screens

### Device Testing

Test on various devices:
- iPad (various sizes)
- Android tablets
- Foldable phones (folded and unfolded)
- Desktop browsers (various window sizes)
- ChromeOS devices

### Responsive Testing in Development

```dart
class ResponsiveTestWrapper extends StatelessWidget {
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    // In debug mode, add controls to test different screen sizes
    if (kDebugMode) {
      return Stack(
        children: [
          child,
          Positioned(
            top: 0,
            right: 0,
            child: ScreenSizeSelector(),
          ),
        ],
      );
    }
    return child;
  }
}
```

## Key Best Practices

1. **Think in breakpoints**: Define clear breakpoints for layout changes
2. **Use flexible layouts**: GridView, Wrap, and Flow widgets adapt naturally
3. **Constrain content width**: Don't let text lines become too long on wide screens
4. **Support all orientations**: Especially important for tablets and foldables
5. **Test input methods**: Support touch, mouse, keyboard, and stylus
6. **Optimize for each size**: Don't just scale up mobile UI - redesign for larger screens
7. **Consider multi-pane layouts**: Use available space for master-detail views on tablets