# General Approach to Adaptive Apps

Flutter's general approach to creating adaptive apps follows a 3-step process that ensures your app works well across different device sizes and orientations.

## The 3-Step Approach

### Step 1: Abstract

Identify the widgets that you plan to make dynamic and analyze their constructors to abstract out shared data.

- Identify widgets that need to be adaptive
- Extract common data and shared information
- Create reusable components that can adapt to different screen sizes
- Examples include:
  - Dialogs that resize based on screen
  - Navigation UI that switches between different styles
  - Custom layouts that reorganize based on available space

### Step 2: Measure

Evaluate your screen size to decide how to display your UI. You have two primary methods:

#### MediaQuery.sizeOf
- Provides the size of the entire app window
- Returns size in logical pixels
- More performance-efficient than MediaQuery.of
- Use when you want your widget to be fullscreen, even when the app window is small
- Best for making decisions based on the total app window size

```dart
final Size screenSize = MediaQuery.sizeOf(context);
if (screenSize.width < 600) {
  // Mobile layout
} else {
  // Tablet/Desktop layout
}
```

#### LayoutBuilder
- Provides layout constraints from the parent widget
- Returns BoxConstraints with width and height ranges
- Use when you need the actual constraints of the screen
- Respects constraints from widgets like NavigationRail and SafeArea
- Best for custom widgets needing localized sizing information

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return MobileLayout();
    } else {
      return TabletLayout();
    }
  },
)
```

### Step 3: Branch

Decide on sizing breakpoints for UI variations and implement adaptive layouts.

- Define clear breakpoints for different layouts
- Base UI changes on window size, not device type
- Example breakpoints (Material Design recommendations):
  - < 600 pixels: Use bottom navigation bar
  - ≥ 600 pixels: Use navigation rail
  - > 840 pixels: Consider using permanent navigation drawer

## Key Principles

1. **Avoid Device-Type Checking**: Don't check if the device is a "phone" or "tablet" when making layout decisions. The space your app is given to render isn't always tied to the full screen size.

2. **Use Adaptive Widgets**: Leverage widgets that automatically adapt:
   - `NavigationBar` for small screens
   - `NavigationRail` for medium screens
   - Permanent drawer for large screens

3. **Share Data**: When switching between different UI components, ensure they share common data (like navigation destinations) to maintain consistency.

4. **Think in Breakpoints**: Define clear breakpoints for your UI transitions rather than trying to create a continuously fluid design that changes at every pixel.

## Example Implementation

```dart
class AdaptiveNavigation extends StatelessWidget {
  final List<NavigationDestination> destinations;
  final int currentIndex;
  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    
    if (width < 600) {
      // Mobile: Bottom navigation
      return Scaffold(
        body: /* ... */,
        bottomNavigationBar: NavigationBar(
          destinations: destinations,
          selectedIndex: currentIndex,
        ),
      );
    } else if (width < 840) {
      // Tablet: Navigation rail
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              destinations: destinations
                  .map((d) => NavigationRailDestination(
                        icon: d.icon,
                        label: Text(d.label),
                      ))
                  .toList(),
              selectedIndex: currentIndex,
            ),
            Expanded(child: /* ... */),
          ],
        ),
      );
    } else {
      // Desktop: Permanent drawer
      return Scaffold(
        body: Row(
          children: [
            Drawer(/* ... */),
            Expanded(child: /* ... */),
          ],
        ),
      );
    }
  }
}
```

This approach ensures your app provides an optimal user experience regardless of the device or window size.