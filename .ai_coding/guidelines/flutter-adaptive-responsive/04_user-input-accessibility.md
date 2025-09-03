# User Input & Accessibility

## Overview

Flutter supports various input methods beyond touch, including scroll wheel, keyboard navigation, mouse interactions, and accessibility features. Creating adaptable interfaces that work well across different input methods is crucial for inclusive design.

## Input Methods Support

### 1. Scroll Wheel Support

Most scrollable widgets support scroll wheel by default. For custom scroll behaviors:

```dart
// Custom scroll behavior with Listener
Listener(
  onPointerSignal: (pointerSignal) {
    if (pointerSignal is PointerScrollEvent) {
      // Handle scroll wheel events
      final delta = pointerSignal.scrollDelta.dy;
      // Implement custom scrolling logic
    }
  },
  child: CustomScrollView(/* your content */),
)

// Using SingleChildScrollView with scroll physics
SingleChildScrollView(
  physics: const BouncingScrollPhysics(),
  child: MyContent(),
)
```

### 2. Tab Traversal and Focus Management

Support keyboard navigation for users with assistive technologies:

```dart
// Basic focusable widget
FocusableActionDetector(
  onPressed: () => handleAction(),
  child: Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: Focus.of(context).hasFocus ? Colors.blue : Colors.grey,
        width: 2,
      ),
    ),
    child: MyCustomControl(),
  ),
)

// Focus traversal group for complex layouts
FocusTraversalGroup(
  policy: WidgetOrderTraversalPolicy(),
  child: Column(
    children: [
      FocusableWidget(order: 1),
      FocusableWidget(order: 2),
      FocusableWidget(order: 3),
    ],
  ),
)

// Request focus programmatically
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final FocusNode _focusNode = FocusNode();
  
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onPressed: () => _focusNode.requestFocus(),
      child: MyContent(),
    );
  }
}
```

### 3. Keyboard Accelerators and Shortcuts

Implement keyboard shortcuts using multiple approaches:

```dart
// Using KeyboardListener
KeyboardListener(
  focusNode: FocusNode(),
  onKeyEvent: (KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        handleEnterKey();
        return true;
      }
    }
    return false;
  },
  child: MyWidget(),
)

// Using Shortcuts widget
Shortcuts(
  shortcuts: {
    LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS): SaveIntent(),
    LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyC): CopyIntent(),
  },
  child: Actions(
    actions: {
      SaveIntent: CallbackAction<SaveIntent>(
        onInvoke: (SaveIntent intent) => handleSave(),
      ),
      CopyIntent: CallbackAction<CopyIntent>(
        onInvoke: (CopyIntent intent) => handleCopy(),
      ),
    },
    child: MyContent(),
  ),
)

// Global keyboard listeners
class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }
  
  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    super.dispose();
  }
  
  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      // Handle global keyboard shortcuts
      return true; // Event consumed
    }
    return false; // Event not handled
  }
}

// Define custom intents
class SaveIntent extends Intent {}
class CopyIntent extends Intent {}
```

### 4. Mouse Interactions

Use MouseRegion for enhanced mouse support:

```dart
// Mouse hover effects
MouseRegion(
  cursor: SystemMouseCursors.click,
  onEnter: (_) => setState(() => isHovered = true),
  onExit: (_) => setState(() => isHovered = false),
  onHover: (PointerHoverEvent event) {
    // Handle mouse movement
    final position = event.localPosition;
    // Update hover state based on position
  },
  child: AnimatedContainer(
    duration: Duration(milliseconds: 200),
    decoration: BoxDecoration(
      color: isHovered ? Colors.blue.shade100 : Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: isHovered ? [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ] : null,
    ),
    child: MyContent(),
  ),
)

// Different cursor types
MouseRegion(
  cursor: SystemMouseCursors.resizeColumn, // or resizeRow, grab, etc.
  child: MyResizableWidget(),
)

// Context menus on right-click
GestureDetector(
  onSecondaryTapDown: (TapDownDetails details) {
    showContextMenu(
      context: context,
      position: details.globalPosition,
      items: [
        PopupMenuItem(child: Text('Copy')),
        PopupMenuItem(child: Text('Paste')),
        PopupMenuItem(child: Text('Delete')),
      ],
    );
  },
  child: MyContent(),
)
```

## Visual Density Adaptation

Adjust hit areas and component sizes across different input devices:

```dart
// Configure visual density in MaterialApp
MaterialApp(
  theme: ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity, // Adaptive density
    // Or set specific density:
    // visualDensity: VisualDensity.compact, // Smaller touch targets
    // visualDensity: VisualDensity.comfortable, // Larger touch targets
  ),
  home: MyHomePage(),
)

// Custom visual density based on input method
Widget buildAdaptiveButton(BuildContext context) {
  final hasTouch = MediaQuery.of(context).size.shortestSide < 600;
  
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      visualDensity: hasTouch 
        ? VisualDensity.comfortable  // Larger for touch
        : VisualDensity.compact,     // Smaller for mouse/keyboard
      minimumSize: Size(
        hasTouch ? 48 : 32, // Minimum touch target size
        hasTouch ? 48 : 32,
      ),
    ),
    onPressed: () {},
    child: Text('Adaptive Button'),
  );
}
```

## Accessibility Features

### Text Scaling Support

```dart
// Respect system text scaling
Text(
  'Scalable text',
  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize! * 
              MediaQuery.textScaleFactorOf(context),
  ),
)

// Limit text scaling for specific components
MediaQuery(
  data: MediaQuery.of(context).copyWith(
    textScaleFactor: math.min(MediaQuery.textScaleFactorOf(context), 1.5),
  ),
  child: MyFixedSizeWidget(),
)
```

### High Contrast and Bold Text Support

```dart
Widget build(BuildContext context) {
  final boldText = MediaQuery.boldTextOf(context);
  final highContrast = MediaQuery.highContrastOf(context);
  
  return Text(
    'Accessible text',
    style: TextStyle(
      fontWeight: boldText ? FontWeight.bold : FontWeight.normal,
      color: highContrast ? Colors.black : Colors.grey.shade800,
    ),
  );
}
```

## Best Practices

1. **Support multiple input methods** - don't assume touch-only
2. **Implement proper focus management** for keyboard navigation
3. **Use semantic widgets** with proper labels and hints
4. **Test with screen readers** and assistive technologies
5. **Respect system accessibility settings** like text scaling and high contrast
6. **Provide keyboard shortcuts** for common actions
7. **Use appropriate cursor styles** for different interactions
8. **Implement hover states** for mouse interactions
9. **Ensure minimum touch target sizes** (48x48 logical pixels)
10. **Test across different input devices** and accessibility settings