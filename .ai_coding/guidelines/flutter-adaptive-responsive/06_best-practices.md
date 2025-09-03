# Best Practices for Adaptive Flutter Apps

## Design Considerations

### 1. Break Down Complex Widgets
Create smaller, simpler components that are easier to adapt and maintain:

```dart
// Instead of one monolithic widget
class ComplexDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 200+ lines of complex layout code
  }
}

// Break into smaller, focused components
class AdaptiveDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    
    return screenWidth > 1200 
      ? DesktopDashboardLayout()
      : screenWidth > 600 
        ? TabletDashboardLayout()
        : MobileDashboardLayout();
  }
}

class MobileDashboardLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DashboardHeader(),
        Expanded(child: DashboardContent()),
        DashboardActions(),
      ],
    );
  }
}
```

### 2. "Solve Touch First" Philosophy
Focus on touch-oriented UI design as the foundation:

```dart
// Start with touch-friendly design
class TouchFirstButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48, // Minimum touch target size
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

// Then enhance for other input methods
class AdaptiveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hasTouch = MediaQuery.of(context).size.shortestSide < 600;
    
    Widget button = ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
    
    // Add mouse enhancements for non-touch devices
    if (!hasTouch) {
      button = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Focus(
          onPressed: onPressed,
          child: button,
        ),
      );
    }
    
    return SizedBox(
      height: hasTouch ? 48 : 36, // Smaller for mouse/keyboard
      child: button,
    );
  }
}
```

### 3. Leverage Unique Strengths of Form Factors
Design to take advantage of each platform's capabilities:

```dart
class AdaptiveMediaViewer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final isLargeScreen = screenSize.width > 1024;
    final isMobile = screenSize.width < 600;
    
    if (isMobile) {
      // Mobile: Full-screen immersive experience
      return PageView.builder(
        itemBuilder: (context, index) => FullScreenMediaView(media[index]),
        itemCount: media.length,
      );
    } else if (isLargeScreen) {
      // Desktop: Multi-pane with sidebar
      return Row(
        children: [
          SizedBox(
            width: 300,
            child: MediaThumbnailList(
              media: media,
              onSelected: setSelectedMedia,
            ),
          ),
          VerticalDivider(),
          Expanded(
            child: DetailedMediaView(selectedMedia),
          ),
        ],
      );
    } else {
      // Tablet: Adaptive grid
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) => MediaCard(media[index]),
        itemCount: media.length,
      );
    }
  }
}
```

## Implementation Best Practices

### 1. Never Lock App Orientation
Allow the system to handle orientation changes naturally:

```dart
// DON'T do this
void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

// DO support all orientations
void main() {
  runApp(MyApp());
}

// Handle orientation changes in your layouts
class OrientationAwareLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    
    return orientation == Orientation.portrait
      ? PortraitLayout()
      : LandscapeLayout();
  }
}
```

### 2. Don't Use Device Type for Layout Decisions
Use actual measurements instead of platform detection:

```dart
// DON'T base layout on platform
Widget build(BuildContext context) {
  if (Platform.isIOS || Platform.isAndroid) {
    return MobileLayout();
  } else {
    return DesktopLayout();
  }
}

// DO base layout on actual screen size
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  
  if (screenWidth < 600) {
    return CompactLayout();
  } else if (screenWidth < 1200) {
    return MediumLayout();
  } else {
    return ExpandedLayout();
  }
}
```

### 3. Support Variety of Input Devices
Design for multiple interaction methods:

```dart
class AdaptiveListItem extends StatefulWidget {
  @override
  State<AdaptiveListItem> createState() => _AdaptiveListItemState();
}

class _AdaptiveListItemState extends State<AdaptiveListItem> {
  bool _isHovered = false;
  bool _isFocused = false;
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Focus(
        onPressed: widget.onTap,
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(16),
            child: widget.child,
          ),
        ),
      ),
    );
  }
  
  Color _getBackgroundColor() {
    if (_isFocused) return Colors.blue.shade100;
    if (_isHovered) return Colors.grey.shade100;
    return Colors.transparent;
  }
}
```

### 4. Use MediaQuery for Understanding Screen Context
Get comprehensive screen information:

```dart
class ResponsiveContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    final textScaleFactor = MediaQuery.textScaleFactorOf(context);
    final orientation = MediaQuery.orientationOf(context);
    
    // Calculate effective screen size
    final effectiveWidth = screenSize.width / devicePixelRatio;
    final effectiveHeight = screenSize.height / devicePixelRatio;
    
    // Adapt to text scaling
    final baseFontSize = 16.0;
    final adaptedFontSize = baseFontSize * math.min(textScaleFactor, 1.5);
    
    return Container(
      constraints: BoxConstraints(
        maxWidth: _getMaxWidth(effectiveWidth),
      ),
      child: Text(
        'Responsive Text',
        style: TextStyle(fontSize: adaptedFontSize),
      ),
    );
  }
  
  double _getMaxWidth(double screenWidth) {
    if (screenWidth < 600) return screenWidth - 32; // Mobile padding
    if (screenWidth < 1200) return 800; // Tablet max width
    return 1000; // Desktop max width
  }
}
```

### 5. Restore List State Using PageStorageKey
Maintain scroll position across navigation:

```dart
class StatefulScrollView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: PageStorageKey('my_list_view'),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index].title),
          onTap: () => _navigateToDetail(context, items[index]),
        );
      },
    );
  }
  
  void _navigateToDetail(BuildContext context, Item item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPage(item: item)),
    );
    // List position will be restored when returning
  }
}
```

## Layout and Navigation Patterns

### 1. Adaptive Navigation Pattern
Implement different navigation styles based on screen size:

```dart
class AdaptiveScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    
    if (screenWidth < 600) {
      return _buildMobileLayout();
    } else if (screenWidth < 1200) {
      return _buildTabletLayout(); 
    } else {
      return _buildDesktopLayout();
    }
  }
  
  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: body,
      bottomNavigationBar: NavigationBar(
        destinations: destinations,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
  
  Widget _buildTabletLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            destinations: destinations.map((dest) => NavigationRailDestination(
              icon: dest.icon,
              label: Text(dest.label),
            )).toList(),
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                AppBar(title: Text(title), automaticallyImplyLeading: false),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: true,
            destinations: destinations.map((dest) => NavigationRailDestination(
              icon: dest.icon,
              label: Text(dest.label),
            )).toList(),
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                AppBar(title: Text(title), automaticallyImplyLeading: false),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### 2. Content Adaptation Patterns
Adjust content presentation for different screen sizes:

```dart
class AdaptiveContentLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: _getMaxContentWidth(screenWidth),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _getHorizontalPadding(screenWidth),
          ),
          child: content,
        ),
      ),
    );
  }
  
  double _getMaxContentWidth(double screenWidth) {
    if (screenWidth < 600) return screenWidth;
    if (screenWidth < 1200) return 800;
    return 1000;
  }
  
  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth < 600) return 16;
    if (screenWidth < 1200) return 24;
    return 32;
  }
}
```

## Testing and Debugging

### 1. Test Across Multiple Screen Sizes
Use Flutter's device preview tools:

```dart
void main() {
  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => MyApp(),
    ),
  );
}
```

### 2. Debug Layout Issues
Use Flutter Inspector and debug tools:

```dart
class DebuggableLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kDebugMode ? BoxDecoration(
        border: Border.all(color: Colors.red, width: 1),
      ) : null,
      child: Column(
        children: [
          if (kDebugMode) 
            Text('Debug: ${MediaQuery.sizeOf(context)}'),
          Expanded(child: actualContent),
        ],
      ),
    );
  }
}
```

## Performance Considerations

### 1. Lazy Load Adaptive Components
Only build what's needed for the current layout:

```dart
class LazyAdaptiveView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    
    // Don't build unused layouts
    if (screenWidth < 600) {
      return MobileView();
    } else if (screenWidth < 1200) {
      return TabletView();
    } else {
      return DesktopView();
    }
  }
}
```

### 2. Cache Expensive Calculations
Store screen-dependent calculations:

```dart
class OptimizedAdaptiveWidget extends StatefulWidget {
  @override
  State<OptimizedAdaptiveWidget> createState() => _OptimizedAdaptiveWidgetState();
}

class _OptimizedAdaptiveWidgetState extends State<OptimizedAdaptiveWidget> {
  Size? _lastScreenSize;
  Widget? _cachedLayout;
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    
    // Only rebuild if screen size changed significantly
    if (_lastScreenSize == null || 
        (screenSize.width - _lastScreenSize!.width).abs() > 50) {
      _lastScreenSize = screenSize;
      _cachedLayout = _buildAdaptiveLayout(screenSize);
    }
    
    return _cachedLayout!;
  }
  
  Widget _buildAdaptiveLayout(Size screenSize) {
    // Expensive layout calculations here
    return Container();
  }
}
```