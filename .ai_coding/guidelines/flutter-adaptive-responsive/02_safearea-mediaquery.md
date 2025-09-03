# SafeArea & MediaQuery

## SafeArea

SafeArea helps prevent UI elements from being blocked by device features like notches, cutouts, and system UI. It "insets its child widget to avoid intrusions" such as status bars and rounded display corners.

### Key Features
- By default, applies padding on all four sides
- Can be customized to apply padding selectively
- Intelligently modifies the MediaQuery for its child widgets
- Allows nested SafeArea widgets without redundant padding

### Usage Examples

```dart
// Basic SafeArea usage
SafeArea(
  child: Column(
    children: [
      AppBar(title: Text('My App')),
      Expanded(child: MyContent()),
    ],
  ),
)

// Selective SafeArea (only top and bottom)
SafeArea(
  left: false,
  right: false,
  child: MyContent(),
)

// Wrap Scaffold body for content visibility
Scaffold(
  body: SafeArea(
    child: MyPageContent(),
  ),
)
```

## MediaQuery

MediaQuery provides crucial device information including:
- Window size
- Accessibility settings
- Display features
- Padding details

### Essential Properties

```dart
final mediaQuery = MediaQuery.of(context);

// Screen dimensions
final screenSize = mediaQuery.size;
final screenWidth = screenSize.width;
final screenHeight = screenSize.height;

// Device pixel ratio
final devicePixelRatio = mediaQuery.devicePixelRatio;

// Safe area paddings
final padding = mediaQuery.padding;
final topPadding = padding.top; // Status bar height
final bottomPadding = padding.bottom; // Home indicator height

// Accessibility
final textScaleFactor = mediaQuery.textScaleFactor;
final boldText = mediaQuery.boldText;

// Orientation
final orientation = mediaQuery.orientation;
```

### Modern MediaQuery Methods

```dart
// Preferred method for getting size
final screenSize = MediaQuery.sizeOf(context);

// Other specific queries
final orientation = MediaQuery.orientationOf(context);
final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
final platformBrightness = MediaQuery.platformBrightnessOf(context);
```

## Best Practices

1. **Wrap Scaffold body with SafeArea** to ensure content visibility across different device types
2. **Use MediaQuery.sizeOf() for size queries** instead of the full MediaQuery.of()
3. **Combine SafeArea and MediaQuery** for comprehensive layout protection
4. **Consider nested SafeArea** - they work intelligently without double-padding
5. **Move SafeArea to wrap whatever content makes sense** while keeping the rest full-screen

## Common Patterns

```dart
// Responsive layout with SafeArea
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  
  return Scaffold(
    body: SafeArea(
      child: screenWidth > 600 
        ? DesktopLayout()
        : MobileLayout(),
    ),
  );
}

// Custom padding based on MediaQuery
Widget buildWithCustomPadding(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  final topPadding = mediaQuery.padding.top;
  
  return Padding(
    padding: EdgeInsets.only(
      top: topPadding + 16, // Status bar + custom spacing
      left: 16,
      right: 16,
      bottom: 16,
    ),
    child: MyContent(),
  );
}
```