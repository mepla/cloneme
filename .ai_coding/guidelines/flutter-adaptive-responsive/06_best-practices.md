# Best Practices for Adaptive Apps

A comprehensive guide to best practices for building adaptive Flutter applications that work seamlessly across all platforms and device types.

## Design Principles

### 1. Break Down Widgets

Create smaller, more focused widgets for better performance and maintainability:

```dart
// ❌ Bad: Monolithic widget
class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header, avatar, stats, posts, etc. all in one widget
        // 500+ lines of code
      ],
    );
  }
}

// ✅ Good: Composed of smaller widgets
class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileHeader(),
        ProfileAvatar(),
        ProfileStats(),
        ProfilePosts(),
      ],
    );
  }
}

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Focused implementation
  }
}
```

Benefits of smaller widgets:
- Improved performance (const constructors, better rebuilds)
- Better code readability and maintainability
- Easier testing
- Reusable components
- More flexible layouts for different screen sizes

### 2. Design to Platform Strengths

Leverage unique capabilities of each platform:

```dart
class PlatformOptimizedFeatures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    
    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      // Use iOS/macOS specific features
      return CupertinoFeatures();
    } else if (platform == TargetPlatform.android) {
      // Use Android specific features
      return MaterialFeatures();
    } else if (kIsWeb) {
      // Optimize for web
      return WebOptimizedFeatures();
    } else {
      // Desktop optimizations
      return DesktopFeatures();
    }
  }
}
```

Platform-specific strengths:
- **Mobile**: Touch gestures, camera, GPS, accelerometer
- **Tablet**: Larger canvas, stylus support, split-screen
- **Desktop**: Keyboard shortcuts, multi-window, file system access
- **Web**: URLs, SEO, browser features, responsive viewport

### 3. Solve Touch First

Design for touch interaction first, then enhance for other inputs:

```dart
class TouchFirstButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Touch-friendly tap target (minimum 48x48)
      onTap: onPressed,
      child: Container(
        constraints: BoxConstraints(minHeight: 48, minWidth: 48),
        child: MouseRegion(
          // Enhanced for mouse users
          cursor: SystemMouseCursors.click,
          child: Shortcuts(
            // Keyboard support
            shortcuts: {
              LogicalKeySet(LogicalKeyboardKey.enter): ActivateIntent(),
            },
            child: child,
          ),
        ),
      ),
    );
  }
}
```

## Layout Best Practices

### 1. Avoid Orientation Locking

Support all orientations for better accessibility:

```dart
// ❌ Bad: Locking orientation
void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

// ✅ Good: Supporting all orientations
void main() {
  // Don't lock orientation, or support all
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(MyApp());
}
```

### 2. Avoid Orientation-Based Layouts

Don't use orientation to determine layout; use available space:

```dart
// ❌ Bad: Using orientation for layout
Widget build(BuildContext context) {
  final orientation = MediaQuery.of(context).orientation;
  if (orientation == Orientation.portrait) {
    return MobileLayout();
  } else {
    return TabletLayout();
  }
}

// ✅ Good: Using available width
Widget build(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 600) {
    return CompactLayout();
  } else if (width < 1200) {
    return MediumLayout();
  } else {
    return ExpandedLayout();
  }
}
```

### 3. Constrain Content Width

Don't stretch content across entire screen on large displays:

```dart
class ReadableContent extends StatelessWidget {
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 800, // Optimal reading width
        ),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: child,
      ),
    );
  }
}
```

### 4. Use Adaptive Breakpoints

Material Design recommended breakpoints:

```dart
class ResponsiveBreakpoints {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 840;
  static const double desktopBreakpoint = 1200;
  static const double largeBreakpoint = 1600;
  
  static bool isMobile(BuildContext context) => 
    MediaQuery.sizeOf(context).width < mobileBreakpoint;
    
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }
  
  static bool isDesktop(BuildContext context) => 
    MediaQuery.sizeOf(context).width >= desktopBreakpoint;
}
```

## Navigation Patterns

### Adaptive Navigation

Switch navigation patterns based on screen size:

```dart
class AdaptiveScaffold extends StatelessWidget {
  final List<NavigationDestination> destinations;
  final int selectedIndex;
  final Widget body;
  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    
    // Mobile: Bottom navigation
    if (width < 600) {
      return Scaffold(
        body: body,
        bottomNavigationBar: NavigationBar(
          destinations: destinations,
          selectedIndex: selectedIndex,
        ),
      );
    }
    
    // Tablet: Navigation rail
    if (width < 1200) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              destinations: _toRailDestinations(destinations),
              selectedIndex: selectedIndex,
              labelType: NavigationRailLabelType.all,
            ),
            VerticalDivider(width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }
    
    // Desktop: Extended navigation rail
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: true,
            destinations: _toRailDestinations(destinations),
            selectedIndex: selectedIndex,
          ),
          VerticalDivider(width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}
```

## Input Device Support

### Multi-Input Support

Support all input methods without compromising any:

```dart
class UniversalInteractiveWidget extends StatefulWidget {
  @override
  State<UniversalInteractiveWidget> createState() => 
    _UniversalInteractiveWidgetState();
}

class _UniversalInteractiveWidgetState 
    extends State<UniversalInteractiveWidget> {
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isPressed = false;
  
  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onShowHoverHighlight: (hover) => setState(() => _isHovered = hover),
      onShowFocusHighlight: (focus) => setState(() => _isFocused = focus),
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.space): ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): ActivateIntent(),
      },
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) => _handleActivation(),
        ),
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: _handleActivation,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              border: _getBorder(),
            ),
            child: Content(),
          ),
        ),
      ),
    );
  }
  
  Color _getBackgroundColor() {
    if (_isPressed) return Colors.blue[700]!;
    if (_isHovered) return Colors.blue[100]!;
    return Colors.white;
  }
  
  Border? _getBorder() {
    if (_isFocused) {
      return Border.all(color: Colors.blue, width: 2);
    }
    return Border.all(color: Colors.grey);
  }
  
  void _handleActivation() {
    // Handle activation
  }
}
```

## State Management

### Preserve State During Configuration Changes

Use PageStorageKey to maintain scroll position and other state:

```dart
class StatefulList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: PageStorageKey('main_list'),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Item $index'),
        );
      },
    );
  }
}
```

### Responsive State Management

```dart
class ResponsiveStateManager extends ChangeNotifier {
  late Size _screenSize;
  late ScreenType _screenType;
  
  void updateScreenSize(Size size) {
    _screenSize = size;
    _screenType = _calculateScreenType(size);
    notifyListeners();
  }
  
  ScreenType _calculateScreenType(Size size) {
    if (size.width < 600) return ScreenType.mobile;
    if (size.width < 1200) return ScreenType.tablet;
    return ScreenType.desktop;
  }
  
  bool get showNavigationRail => _screenType != ScreenType.mobile;
  bool get showExtendedRail => _screenType == ScreenType.desktop;
  int get gridColumns => _screenType == ScreenType.mobile ? 2 : 4;
}
```

## Performance Optimization

### Conditional Widget Building

Build only what's needed for the current screen:

```dart
class OptimizedResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Build only the appropriate layout
        if (constraints.maxWidth < 600) {
          return _buildMobileLayout();
        } else if (constraints.maxWidth < 1200) {
          return _buildTabletLayout();
        } else {
          return _buildDesktopLayout();
        }
      },
    );
  }
  
  Widget _buildMobileLayout() {
    // Mobile-specific widgets only
    return MobileOptimizedView();
  }
  
  Widget _buildTabletLayout() {
    // Tablet-specific widgets only
    return TabletOptimizedView();
  }
  
  Widget _buildDesktopLayout() {
    // Desktop-specific widgets only
    return DesktopOptimizedView();
  }
}
```

## Accessibility

### Always Include Semantics

```dart
class AccessibleButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      hint: 'Double tap to activate',
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Text(label),
        ),
      ),
    );
  }
}
```

### Support Keyboard Navigation

```dart
class KeyboardNavigableList extends StatefulWidget {
  final List<String> items;
  
  @override
  State<KeyboardNavigableList> createState() => 
    _KeyboardNavigableListState();
}

class _KeyboardNavigableListState extends State<KeyboardNavigableList> {
  int _selectedIndex = 0;
  final FocusNode _focusNode = FocusNode();
  
  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            setState(() {
              _selectedIndex = (_selectedIndex + 1) % widget.items.length;
            });
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            setState(() {
              _selectedIndex = (_selectedIndex - 1) % widget.items.length;
            });
          }
        }
      },
      child: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          return Container(
            color: _selectedIndex == index ? Colors.blue[100] : null,
            child: ListTile(
              title: Text(widget.items[index]),
            ),
          );
        },
      ),
    );
  }
}
```

## Testing Strategies

### Test on Multiple Screen Sizes

```dart
void main() {
  group('Responsive Layout Tests', () {
    testWidgets('Shows mobile layout on small screens', (tester) async {
      tester.view.physicalSize = Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(MaterialApp(home: ResponsiveApp()));
      
      expect(find.byType(MobileLayout), findsOneWidget);
      expect(find.byType(TabletLayout), findsNothing);
    });
    
    testWidgets('Shows tablet layout on medium screens', (tester) async {
      tester.view.physicalSize = Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(MaterialApp(home: ResponsiveApp()));
      
      expect(find.byType(TabletLayout), findsOneWidget);
      expect(find.byType(MobileLayout), findsNothing);
    });
  });
}
```

## Summary Checklist

✅ **Design Principles**
- [ ] Break down large widgets into smaller components
- [ ] Design to platform strengths
- [ ] Solve for touch first, enhance for other inputs

✅ **Layout**
- [ ] Support all orientations
- [ ] Use screen size, not orientation for layout decisions
- [ ] Constrain content width on large screens
- [ ] Use Material Design breakpoints

✅ **Navigation**
- [ ] Adapt navigation pattern to screen size
- [ ] Support keyboard navigation
- [ ] Provide multiple ways to navigate

✅ **Input**
- [ ] Support touch, mouse, keyboard, and stylus
- [ ] Provide appropriate visual feedback
- [ ] Meet minimum touch target sizes (48x48)

✅ **State**
- [ ] Preserve state during configuration changes
- [ ] Use PageStorageKey for scroll positions
- [ ] Handle orientation changes gracefully

✅ **Accessibility**
- [ ] Include semantic information
- [ ] Support screen readers
- [ ] Ensure keyboard navigation
- [ ] Respect system accessibility settings

✅ **Testing**
- [ ] Test on multiple screen sizes
- [ ] Test with different input methods
- [ ] Test accessibility features
- [ ] Test on actual devices when possible