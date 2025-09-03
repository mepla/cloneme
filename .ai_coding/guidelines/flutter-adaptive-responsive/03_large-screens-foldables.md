# Large Screens & Foldables

## Overview

Flutter recommends optimizing apps for large screens like tablets, foldables, ChromeOS, web, desktop, and iPads to improve user engagement, app visibility, and meet platform submission guidelines.

## Layout Adaptation Strategies

### 1. Use GridView Instead of ListView

Better utilize screen space by switching from linear to grid layouts:

```dart
Widget buildItemList(BuildContext context) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  
  if (screenWidth > 600) {
    // Large screen: Use GridView
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth > 1200 ? 4 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) => MyItemCard(items[index]),
      itemCount: items.length,
    );
  } else {
    // Small screen: Use ListView
    return ListView.builder(
      itemBuilder: (context, index) => MyItemTile(items[index]),
      itemCount: items.length,
    );
  }
}
```

### 2. Responsive Grid Delegates

```dart
// Fixed cross-axis count based on screen size
SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: screenWidth > 1200 ? 4 : screenWidth > 800 ? 3 : 2,
)

// Max cross-axis extent for consistent sizing
SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 300, // Each item max 300px wide
  crossAxisSpacing: 16,
  mainAxisSpacing: 16,
)
```

### 3. Navigation Adaptation

Switch between navigation patterns based on available space:

```dart
Widget buildAdaptiveNavigation(BuildContext context) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  
  if (screenWidth < 600) {
    // Mobile: Bottom Navigation
    return NavigationBar(
      destinations: navigationDestinations,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
    );
  } else if (screenWidth < 1200) {
    // Tablet: Navigation Rail
    return NavigationRail(
      destinations: navigationDestinations.map((dest) => 
        NavigationRailDestination(
          icon: dest.icon,
          label: Text(dest.label),
        ),
      ).toList(),
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
    );
  } else {
    // Desktop: Extended Navigation Rail
    return NavigationRail(
      extended: true,
      destinations: navigationDestinations.map((dest) => 
        NavigationRailDestination(
          icon: dest.icon,
          label: Text(dest.label),
        ),
      ).toList(),
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
    );
  }
}
```

## Foldable Device Considerations

### 1. Avoid Locking Screen Orientation

```dart
// DON'T lock orientation
SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
]);

// DO support all orientations
SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown,
  DeviceOrientation.landscapeLeft,
  DeviceOrientation.landscapeRight,
]);
```

### 2. Use Display API for Physical Screen Dimensions

```dart
import 'dart:ui' as ui;

Widget buildFoldableAwareLayout(BuildContext context) {
  final display = ui.PlatformDispatcher.instance.displays.first;
  final physicalSize = display.size;
  final devicePixelRatio = display.devicePixelRatio;
  
  final logicalWidth = physicalSize.width / devicePixelRatio;
  final logicalHeight = physicalSize.height / devicePixelRatio;
  
  // Adapt layout based on actual screen dimensions
  return Container(/* responsive layout */);
}
```

### 3. Handle Multiple Orientations

```dart
Widget build(BuildContext context) {
  final orientation = MediaQuery.orientationOf(context);
  
  if (orientation == Orientation.landscape) {
    return Row(
      children: [
        Expanded(flex: 1, child: SidePanel()),
        Expanded(flex: 2, child: MainContent()),
      ],
    );
  } else {
    return Column(
      children: [
        Expanded(child: MainContent()),
        SidePanel(),
      ],
    );
  }
}
```

## Input Adaptations

### 1. Support Mouse and Stylus Inputs

Use Material 3 components for built-in input state handling:

```dart
// Material 3 buttons automatically handle hover states
ElevatedButton(
  onPressed: () {},
  child: Text('Hover-aware Button'),
)

// Custom hover handling
MouseRegion(
  onEnter: (_) => setState(() => isHovered = true),
  onExit: (_) => setState(() => isHovered = false),
  child: Container(
    color: isHovered ? Colors.blue.shade100 : Colors.white,
    child: MyContent(),
  ),
)
```

### 2. Adaptive Master-Detail Pattern

```dart
Widget buildMasterDetail(BuildContext context) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  
  if (screenWidth > 800) {
    // Large screen: Side-by-side
    return Row(
      children: [
        SizedBox(width: 300, child: MasterView()),
        VerticalDivider(),
        Expanded(child: DetailView()),
      ],
    );
  } else {
    // Small screen: Navigation-based
    return Navigator(/* handle navigation between master/detail */);
  }
}
```

## Breakpoint Recommendations

```dart
class ScreenBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
  
  static bool isMobile(BuildContext context) => 
    MediaQuery.sizeOf(context).width < mobile;
    
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobile && width < desktop;
  }
  
  static bool isDesktop(BuildContext context) => 
    MediaQuery.sizeOf(context).width >= desktop;
}
```

## Best Practices

1. **Use MediaQuery to determine window size dynamically**
2. **Support multiple orientations** - don't lock orientation
3. **Create fluid layouts** that work across different screen sizes
4. **Implement progressive enhancement** - start with mobile, enhance for larger screens
5. **Test on actual large screen devices** including foldables and tablets
6. **Use proper breakpoints** based on content, not device categories