# SafeArea & MediaQuery

Two fundamental widgets for creating adaptive Flutter applications that handle different device characteristics and screen features.

## SafeArea Widget

`SafeArea` ensures that your app content won't be cut off by physical display features or operating system UI, setting your app up for success even as new devices with different shapes and styles enter the market.

### What SafeArea Protects Against

- **Physical display features**: Notches, camera cutouts, sensor housings
- **Operating system UI**: Status bars, navigation bars, system overlays
- **Display characteristics**: Rounded corners, edge displays
- **Future device designs**: New form factors and display innovations

### How SafeArea Works

SafeArea insets its child widget to avoid intrusions by adding appropriate padding. It uses MediaQuery behind the scenes to determine the necessary padding for each side of the screen.

```dart
SafeArea(
  child: YourContent(),
)
```

### Customizing SafeArea

You can disable padding on specific sides:

```dart
SafeArea(
  left: false,    // Allow content to extend to left edge
  top: true,      // Protect from top intrusions
  right: true,    // Protect from right intrusions
  bottom: false,  // Allow content to extend to bottom
  child: YourContent(),
)
```

### Best Practices for SafeArea

1. **Scaffold Body**: Generally recommended to wrap the body of a Scaffold widget in SafeArea as a good starting point

```dart
Scaffold(
  body: SafeArea(
    child: YourContent(),
  ),
)
```

2. **Selective Application**: You don't always need SafeArea at the top of your widget tree. If you want parts of your app to stretch under system UI (like an image gallery), apply SafeArea only to specific content:

```dart
Column(
  children: [
    // Full-screen image without SafeArea
    FullScreenImage(),
    // Protected content with SafeArea
    SafeArea(
      child: ContentOverlay(),
    ),
  ],
)
```

3. **Nested SafeAreas**: SafeArea modifies the MediaQuery exposed to its children, making it appear as if the padding doesn't exist. This means you can nest SafeAreas, and only the topmost one will apply the necessary padding.

```dart
SafeArea(           // This applies the padding
  child: SafeArea(  // This has no effect (padding already applied)
    child: Content(),
  ),
)
```

## MediaQuery

MediaQuery is a powerful widget that provides information about the current device and app environment. Sometimes you'll use MediaQuery directly, and sometimes indirectly through widgets like SafeArea.

### Information Provided by MediaQuery

1. **Window Size and Metrics**
   - Current app window size
   - Device pixel ratio
   - Text scale factor
   - Screen brightness

2. **Accessibility Settings**
   - High contrast mode
   - Bold text preference
   - Disable animations preference
   - Whether accessibility services are active (TalkBack, VoiceOver)

3. **Display Features**
   - Display cutouts and notches
   - System UI overlays
   - Keyboard visibility and height
   - Device orientation
   - Hinges or folds (for foldable devices)

### Using MediaQuery Efficiently

#### MediaQuery.sizeOf (Recommended)

For performance reasons, use `MediaQuery.sizeOf` when you only need size information:

```dart
// Efficient - only rebuilds when size changes
final Size screenSize = MediaQuery.sizeOf(context);
```

#### MediaQuery.of

Use when you need multiple properties:

```dart
final MediaQueryData mediaQuery = MediaQuery.of(context);
final double textScale = mediaQuery.textScaleFactor;
final bool highContrast = mediaQuery.highContrast;
final EdgeInsets padding = mediaQuery.padding;
```

### Common Use Cases

#### Responsive Layout Decisions

```dart
Widget build(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  
  if (size.width < 600) {
    return MobileLayout();
  } else if (size.width < 1200) {
    return TabletLayout();
  } else {
    return DesktopLayout();
  }
}
```

#### Handling Keyboard Appearance

```dart
Widget build(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  final keyboardHeight = mediaQuery.viewInsets.bottom;
  
  return Padding(
    padding: EdgeInsets.only(bottom: keyboardHeight),
    child: YourContent(),
  );
}
```

#### Accessibility Adaptations

```dart
Widget build(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  
  // Adapt for users with larger text settings
  final textScale = mediaQuery.textScaleFactor;
  final adjustedFontSize = 14.0 * textScale;
  
  // Check for accessibility services
  final accessibleNavigation = mediaQuery.accessibleNavigation;
  
  return Text(
    'Adaptive Text',
    style: TextStyle(
      fontSize: adjustedFontSize,
      // Increase contrast if needed
      color: mediaQuery.highContrast 
        ? Colors.black 
        : Colors.grey[700],
    ),
  );
}
```

## Combining SafeArea and MediaQuery

SafeArea uses MediaQuery internally and modifies the MediaQuery data for its descendants:

```dart
class AdaptiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the original MediaQuery data
    final mediaQuery = MediaQuery.of(context);
    
    return SafeArea(
      child: Builder(
        builder: (context) {
          // This MediaQuery has been modified by SafeArea
          // The padding has been removed from the available space
          final safeMediaQuery = MediaQuery.of(context);
          final availableHeight = safeMediaQuery.size.height;
          
          return Container(
            height: availableHeight, // Uses safe area height
            child: YourContent(),
          );
        },
      ),
    );
  }
}
```

## Key Takeaways

1. **SafeArea** protects your content from being obscured by device features and system UI
2. **MediaQuery** provides comprehensive information about the device and user preferences
3. Use **MediaQuery.sizeOf** for better performance when you only need size information
4. SafeArea modifies MediaQuery for its children, preventing duplicate padding when nested
5. Both widgets are essential for creating truly adaptive Flutter applications that work across all devices and accessibility settings