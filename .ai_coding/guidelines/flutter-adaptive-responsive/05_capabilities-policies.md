# Capabilities & Policies

## Overview

Flutter recommends creating `Capability` and `Policy` classes to handle different device behaviors in a maintainable and testable way. This approach moves away from simple platform checks to more nuanced feature detection.

## Concepts

### Capabilities
Define what code or devices **can** do, such as:
- API existence
- OS restrictions  
- Hardware requirements
- Feature availability

### Policies
Define what code **should** do, including:
- App store guidelines
- Design preferences
- Platform-specific features
- Business rules

## Implementation Patterns

### 1. Abstract Capability Classes

```dart
// Base capability interface
abstract class Capability<T> {
  T get value;
  bool get isAvailable;
}

// Device capabilities
abstract class DeviceCapabilities {
  bool get hasCamera;
  bool get hasGPS;
  bool get hasBiometric;
  bool get supportsNFC;
  bool get hasVibration;
}

// Platform capabilities
abstract class PlatformCapabilities {
  bool get supportsFileSystem;
  bool get supportsNotifications;
  bool get supportsBackgroundTasks;
  bool get supportsAppBadges;
}

// Input capabilities
abstract class InputCapabilities {
  bool get hasPhysicalKeyboard;
  bool get hasMouse;
  bool get hasStylus;
  bool get supportsMultitouch;
  bool get hasGamepad;
}
```

### 2. Concrete Implementations

```dart
class FlutterDeviceCapabilities implements DeviceCapabilities {
  @override
  bool get hasCamera => _checkCameraPermission();
  
  @override
  bool get hasGPS => _checkLocationServices();
  
  @override
  bool get hasBiometric => _checkBiometricSupport();
  
  @override
  bool get supportsNFC => Platform.isAndroid; // NFC mostly Android
  
  @override
  bool get hasVibration => !kIsWeb; // Web doesn't support vibration
  
  bool _checkCameraPermission() {
    // Implementation using camera plugin
    return true; // Simplified
  }
  
  bool _checkLocationServices() {
    // Implementation using location plugin
    return true; // Simplified
  }
  
  bool _checkBiometricSupport() {
    // Implementation using local_auth plugin
    return true; // Simplified
  }
}

class FlutterInputCapabilities implements InputCapabilities {
  @override
  bool get hasPhysicalKeyboard {
    // Detect based on form factor and platform
    if (kIsWeb) return true;
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) return true;
    return false; // Mobile devices typically don't have physical keyboards
  }
  
  @override
  bool get hasMouse {
    return !Platform.isIOS && !Platform.isAndroid;
  }
  
  @override
  bool get hasStylus {
    // Could be enhanced to detect actual stylus support
    return Platform.isIOS || Platform.isAndroid;
  }
  
  @override
  bool get supportsMultitouch {
    return Platform.isIOS || Platform.isAndroid || kIsWeb;
  }
  
  @override
  bool get hasGamepad {
    // Desktop platforms typically support gamepads
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }
}
```

### 3. Policy Classes

```dart
// UI Policies
abstract class UIPolicy {
  bool shouldUseBottomNavigation(double screenWidth);
  bool shouldShowSidebar(double screenWidth);
  int getGridColumns(double screenWidth);
  double getMaxContentWidth();
}

class MaterialUIPolicy implements UIPolicy {
  @override
  bool shouldUseBottomNavigation(double screenWidth) {
    return screenWidth < 600; // Material Design breakpoint
  }
  
  @override
  bool shouldShowSidebar(double screenWidth) {
    return screenWidth >= 1200;
  }
  
  @override
  int getGridColumns(double screenWidth) {
    if (screenWidth < 600) return 1;
    if (screenWidth < 1024) return 2;
    if (screenWidth < 1440) return 3;
    return 4;
  }
  
  @override
  double getMaxContentWidth() {
    return 1200; // Material Design recommendation
  }
}

// Navigation Policies  
abstract class NavigationPolicy {
  bool shouldUseDrawer(Capabilities capabilities, double screenWidth);
  bool shouldUseTabBar(int tabCount);
  bool shouldShowBackButton(bool canPop);
}

class AdaptiveNavigationPolicy implements NavigationPolicy {
  @override
  bool shouldUseDrawer(Capabilities capabilities, double screenWidth) {
    // Use drawer on mobile, rail on tablet/desktop
    return screenWidth < 600 && capabilities.input.supportsMultitouch;
  }
  
  @override
  bool shouldUseTabBar(int tabCount) {
    return tabCount <= 5; // Switch to dropdown if more than 5 tabs
  }
  
  @override
  bool shouldShowBackButton(bool canPop) {
    return canPop; // Always show if navigation is possible
  }
}
```

### 4. Unified Capability Service

```dart
class Capabilities {
  final DeviceCapabilities device;
  final PlatformCapabilities platform;
  final InputCapabilities input;
  
  const Capabilities({
    required this.device,
    required this.platform, 
    required this.input,
  });
}

class Policies {
  final UIPolicy ui;
  final NavigationPolicy navigation;
  
  const Policies({
    required this.ui,
    required this.navigation,
  });
}

// Service locator or dependency injection
class AdaptiveService {
  static Capabilities? _capabilities;
  static Policies? _policies;
  
  static Capabilities get capabilities => _capabilities!;
  static Policies get policies => _policies!;
  
  static void initialize({
    required Capabilities capabilities,
    required Policies policies,
  }) {
    _capabilities = capabilities;
    _policies = policies;
  }
}
```

## Usage Examples

### 1. Adaptive Layout Based on Capabilities

```dart
Widget buildAdaptiveLayout(BuildContext context) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  final capabilities = AdaptiveService.capabilities;
  final policies = AdaptiveService.policies;
  
  // Use policy to determine navigation type
  if (policies.ui.shouldUseBottomNavigation(screenWidth)) {
    return Scaffold(
      body: _buildContent(),
      bottomNavigationBar: _buildBottomNav(),
    );
  } else if (policies.ui.shouldShowSidebar(screenWidth)) {
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  } else {
    return Scaffold(
      body: _buildContent(),
      drawer: policies.navigation.shouldUseDrawer(capabilities, screenWidth)
        ? _buildDrawer()
        : null,
    );
  }
}
```

### 2. Input-Aware Interactions

```dart
Widget buildInteractiveWidget(BuildContext context) {
  final inputCapabilities = AdaptiveService.capabilities.input;
  
  Widget widget = MyBaseWidget();
  
  // Add mouse support if available
  if (inputCapabilities.hasMouse) {
    widget = MouseRegion(
      onEnter: (_) => _handleMouseEnter(),
      onExit: (_) => _handleMouseExit(),
      child: widget,
    );
  }
  
  // Add keyboard support if available
  if (inputCapabilities.hasPhysicalKeyboard) {
    widget = Focus(
      onPressed: _handleKeyboardFocus,
      child: widget,
    );
  }
  
  return widget;
}
```

### 3. Feature-Based Functionality

```dart
class PhotoService {
  Future<void> takePhoto() async {
    final deviceCapabilities = AdaptiveService.capabilities.device;
    
    if (!deviceCapabilities.hasCamera) {
      throw UnsupportedError('Camera not available');
    }
    
    // Implement photo capture
  }
  
  Future<void> sharePhoto(String photoPath) async {
    final platformCapabilities = AdaptiveService.capabilities.platform;
    
    if (platformCapabilities.supportsFileSystem) {
      // Share via file system
    } else {
      // Share via platform channels or alternative method
    }
  }
}
```

## Testing Strategies

### 1. Mock Capabilities for Testing

```dart
class MockCapabilities implements Capabilities {
  @override
  final DeviceCapabilities device;
  @override  
  final PlatformCapabilities platform;
  @override
  final InputCapabilities input;
  
  const MockCapabilities({
    required this.device,
    required this.platform,
    required this.input,
  });
}

class MockDeviceCapabilities implements DeviceCapabilities {
  @override
  final bool hasCamera;
  @override
  final bool hasGPS;
  @override
  final bool hasBiometric;
  @override
  final bool supportsNFC;
  @override
  final bool hasVibration;
  
  const MockDeviceCapabilities({
    this.hasCamera = false,
    this.hasGPS = false,
    this.hasBiometric = false,
    this.supportsNFC = false,
    this.hasVibration = false,
  });
}

// Test example
testWidgets('should adapt to capabilities', (WidgetTester tester) async {
  AdaptiveService.initialize(
    capabilities: MockCapabilities(
      device: MockDeviceCapabilities(hasCamera: true),
      platform: MockPlatformCapabilities(),
      input: MockInputCapabilities(hasMouse: true),
    ),
    policies: MaterialPolicies(),
  );
  
  await tester.pumpWidget(MyAdaptiveWidget());
  
  // Verify widget adapts correctly
});
```

## Best Practices

1. **Avoid using `Platform.isX` for layout decisions** - use capability-based detection
2. **Create methods that describe why code branches**, not just where
3. **Use compile-time, runtime, or RPC-backed implementations** as appropriate
4. **Test by mocking capabilities and policies** for different scenarios
5. **Design apps to leverage each platform's unique strengths**
6. **Keep capability detection separate from business logic**
7. **Use dependency injection** to manage capability and policy instances
8. **Document capability assumptions** and fallback behaviors
9. **Create comprehensive capability coverage** for your app's needs
10. **Update capabilities** as platform features evolve