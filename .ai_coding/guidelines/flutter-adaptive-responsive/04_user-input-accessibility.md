# User Input & Accessibility

Creating adaptive Flutter applications requires supporting various input methods beyond touch, ensuring accessibility for all users regardless of their abilities or preferred interaction methods.

## Input Methods Overview

Modern Flutter apps must support:
- **Touch**: Primary mobile interaction
- **Mouse**: Desktop and web users
- **Keyboard**: Navigation and shortcuts
- **Stylus/Pen**: Tablets and drawing apps
- **Trackpad**: Laptop users
- **Game controllers**: TV and gaming devices
- **Assistive technologies**: Screen readers, switch controls

## Scroll Wheel Support

### Custom Scroll Wheel Behavior

Most scrollable widgets support scroll wheel by default, but you can customize behavior:

```dart
class CustomScrollWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          // Custom scroll handling
          final double scrollDelta = pointerSignal.scrollDelta.dy;
          // Implement custom scroll behavior
          // e.g., horizontal scrolling, zoom, or custom animations
        }
      },
      child: SingleChildScrollView(
        child: YourContent(),
      ),
    );
  }
}
```

### Fine-tuning Scroll Physics

```dart
ScrollConfiguration(
  behavior: ScrollConfiguration.of(context).copyWith(
    // Enable scroll wheel on all platforms
    scrollbars: true,
    // Customize scroll physics
    physics: BouncingScrollPhysics(),
  ),
  child: ListView(
    // Your list content
  ),
)
```

## Tab Traversal and Focus

Supporting keyboard navigation is crucial for accessibility and power users.

### FocusableActionDetector

Create custom focusable controls:

```dart
class CustomButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  
  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _focused = false;
  bool _hovering = false;
  
  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      autofocus: false,
      onFocusChange: (focused) => setState(() => _focused = focused),
      onShowHoverHighlight: (hovering) => setState(() => _hovering = hovering),
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.enter): ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onPressed();
            return null;
          },
        ),
      },
      child: Container(
        decoration: BoxDecoration(
          color: _hovering ? Colors.blue[100] : Colors.white,
          border: Border.all(
            color: _focused ? Colors.blue : Colors.grey,
            width: _focused ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(16),
        child: widget.child,
      ),
    );
  }
}
```

### Focus Traversal Order

Control tab order with FocusTraversalGroup:

```dart
class FormWithCustomTabOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Column(
        children: [
          FocusTraversalOrder(
            order: NumericFocusOrder(1),
            child: TextField(
              decoration: InputDecoration(labelText: 'First Name'),
            ),
          ),
          FocusTraversalOrder(
            order: NumericFocusOrder(2),
            child: TextField(
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
          ),
          FocusTraversalOrder(
            order: NumericFocusOrder(3),
            child: TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
          ),
          // Skip this field in tab order
          ExcludeFocus(
            excluding: true,
            child: TextField(
              decoration: InputDecoration(labelText: 'Hidden Field'),
            ),
          ),
        ],
      ),
    );
  }
}
```

## Keyboard Shortcuts

Implement keyboard shortcuts for power users and accessibility.

### Using Shortcuts Widget

```dart
class AppWithShortcuts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS): 
          SaveIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN): 
          NewDocumentIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyO): 
          OpenDocumentIntent(),
        LogicalKeySet(LogicalKeyboardKey.escape): 
          CloseDialogIntent(),
      },
      child: Actions(
        actions: {
          SaveIntent: CallbackAction<SaveIntent>(
            onInvoke: (_) => _saveDocument(),
          ),
          NewDocumentIntent: CallbackAction<NewDocumentIntent>(
            onInvoke: (_) => _createNewDocument(),
          ),
          OpenDocumentIntent: CallbackAction<OpenDocumentIntent>(
            onInvoke: (_) => _openDocument(),
          ),
          CloseDialogIntent: CallbackAction<CloseDialogIntent>(
            onInvoke: (_) => Navigator.of(context).pop(),
          ),
        },
        child: YourApp(),
      ),
    );
  }
}

// Define intents
class SaveIntent extends Intent {}
class NewDocumentIntent extends Intent {}
class OpenDocumentIntent extends Intent {}
class CloseDialogIntent extends Intent {}
```

### Using KeyboardListener

For more direct keyboard handling:

```dart
class KeyboardHandlingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          // Handle arrow keys for custom navigation
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            // Move selection up
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            // Move selection down
          }
        }
      },
      child: YourContent(),
    );
  }
}
```

### Global Keyboard Listeners

For app-wide shortcuts:

```dart
class GlobalShortcutManager {
  static void initialize() {
    HardwareKeyboard.instance.addHandler(_handleGlobalKey);
  }
  
  static bool _handleGlobalKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      // Check for global shortcuts
      if (HardwareKeyboard.instance.isControlPressed &&
          event.logicalKey == LogicalKeyboardKey.keyK) {
        // Open command palette
        _openCommandPalette();
        return true; // Event handled
      }
    }
    return false; // Event not handled
  }
  
  static void _openCommandPalette() {
    // Implementation
  }
}
```

## Mouse Interactions

Enhance user experience with mouse-specific interactions.

### MouseRegion for Hover Effects

```dart
class InteractiveCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  
  @override
  State<InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<InteractiveCard> {
  bool _isHovered = false;
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null 
        ? SystemMouseCursors.click 
        : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.grey[100] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.2 : 0.1),
              blurRadius: _isHovered ? 8 : 4,
              offset: Offset(0, _isHovered ? 4 : 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: widget.onTap,
          child: widget.child,
        ),
      ),
    );
  }
}
```

### Custom Cursors

```dart
MouseRegion(
  cursor: SystemMouseCursors.text,     // For text fields
  cursor: SystemMouseCursors.click,    // For clickable elements
  cursor: SystemMouseCursors.grab,     // For draggable elements
  cursor: SystemMouseCursors.resizeUpDown, // For resizable elements
  cursor: SystemMouseCursors.forbidden,    // For disabled elements
  child: YourWidget(),
)
```

## Visual Density

Adjust widget hit areas for different input devices.

### Configuring Visual Density

```dart
MaterialApp(
  theme: ThemeData(
    // Adapt density based on platform
    visualDensity: VisualDensity.adaptivePlatformDensity,
  ),
)

// Or create custom density
class AdaptiveDensity {
  static VisualDensity getDensity(BuildContext context) {
    final platform = Theme.of(context).platform;
    final size = MediaQuery.sizeOf(context);
    
    // Compact for mobile touch
    if (platform == TargetPlatform.iOS || 
        platform == TargetPlatform.android) {
      return VisualDensity.compact;
    }
    
    // Standard for desktop with mouse
    if (size.width > 600) {
      return VisualDensity.standard;
    }
    
    // Comfortable for tablets
    return VisualDensity.comfortable;
  }
}
```

### Custom Visual Density

```dart
class CustomDensityButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final VisualDensity visualDensity;
  
  @override
  Widget build(BuildContext context) {
    // Adjust padding based on density
    final basePadding = 16.0;
    final horizontalPadding = basePadding + visualDensity.horizontal * 4;
    final verticalPadding = basePadding + visualDensity.vertical * 4;
    
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
      ),
      child: Text(label),
    );
  }
}
```

## Accessibility Features

### Screen Reader Support

```dart
Semantics(
  label: 'Play button',
  hint: 'Double tap to play the video',
  button: true,
  enabled: true,
  child: IconButton(
    icon: Icon(Icons.play_arrow),
    onPressed: _playVideo,
  ),
)
```

### Semantic Annotations

```dart
class AccessibleList extends StatelessWidget {
  final List<String> items;
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Semantics(
          label: 'Item ${index + 1} of ${items.length}',
          value: items[index],
          onTapHint: 'Double tap to select',
          child: ListTile(
            title: Text(items[index]),
            onTap: () => _selectItem(index),
          ),
        );
      },
    );
  }
}
```

### High Contrast Support

```dart
class ContrastAwareWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isHighContrast = mediaQuery.highContrast;
    
    return Container(
      decoration: BoxDecoration(
        border: isHighContrast 
          ? Border.all(color: Colors.black, width: 2)
          : null,
        color: isHighContrast 
          ? Colors.white 
          : Colors.grey[100],
      ),
      child: Text(
        'Adaptive Content',
        style: TextStyle(
          color: isHighContrast 
            ? Colors.black 
            : Colors.grey[700],
          fontWeight: isHighContrast 
            ? FontWeight.bold 
            : FontWeight.normal,
        ),
      ),
    );
  }
}
```

### Reduced Motion

```dart
class MotionAwareAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final disableAnimations = mediaQuery.disableAnimations;
    
    return AnimatedContainer(
      duration: disableAnimations 
        ? Duration.zero 
        : Duration(milliseconds: 300),
      // Animation properties
    );
  }
}
```

## Testing Accessibility

### Using Accessibility Inspector

```dart
void main() {
  // Enable semantics debugger in development
  runApp(MaterialApp(
    showSemanticsDebugger: true, // Shows semantic tree overlay
    home: MyApp(),
  ));
}
```

### Automated Accessibility Testing

```dart
testWidgets('Button has correct semantics', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ElevatedButton(
          onPressed: () {},
          child: Text('Click me'),
        ),
      ),
    ),
  );
  
  // Check semantics
  final semantics = tester.getSemantics(find.text('Click me'));
  expect(semantics.label, 'Click me');
  expect(semantics.hasFlag(ui.SemanticsFlag.isButton), true);
  expect(semantics.hasFlag(ui.SemanticsFlag.isEnabled), true);
});
```

## Best Practices

1. **Always support keyboard navigation**: Every interactive element should be keyboard accessible
2. **Provide visual feedback**: Show focus indicators, hover states, and pressed states
3. **Use semantic widgets**: Prefer semantic widgets over generic containers
4. **Test with assistive technologies**: Use screen readers to test your app
5. **Support all input methods**: Don't assume users will only use touch
6. **Respect user preferences**: Honor system accessibility settings
7. **Provide keyboard shortcuts**: Add shortcuts for common actions
8. **Make hit targets accessible**: Minimum 48x48 dp for touch targets