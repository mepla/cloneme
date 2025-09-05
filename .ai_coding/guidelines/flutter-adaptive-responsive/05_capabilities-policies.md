# Capabilities & Policies

Understanding the difference between capabilities and policies is crucial for writing maintainable, platform-agnostic Flutter code that can adapt to different devices and requirements.

## Understanding Capabilities vs Policies

### Capabilities
"Capabilities" define what code or a device **can** do:
- API existence and availability
- Operating system restrictions
- Hardware requirements and features
- Platform limitations
- Technical constraints

### Policies
"Policies" define what code **should** do:
- App store guidelines and requirements
- Design preferences and conventions
- Business rules and decisions
- Platform-specific user expectations
- Legal and compliance requirements

## The Problem with Platform Checks

### ❌ Bad: Direct Platform Checks

```dart
// DON'T DO THIS
class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: Platform.isIOS ? null : _handlePurchase,
      child: Text('Purchase'),
    );
  }
}
```

This approach has several problems:
- Unclear why iOS is different
- Hard to test
- Difficult to modify when requirements change
- Couples business logic to platform detection

### ✅ Good: Abstraction with Clear Intent

```dart
// DO THIS INSTEAD
class PaymentPolicy {
  // Clearly documents WHY the behavior differs
  bool shouldAllowExternalPurchase() {
    // External payment links are prohibited by Apple App Store guidelines
    // See: https://developer.apple.com/app-store/review/guidelines/#3.1.1
    return !Platform.isIOS;
  }
  
  bool shouldShowPurchaseButton() {
    // On iOS, we use native StoreKit instead
    return !Platform.isIOS || _hasStoreKitIntegration();
  }
  
  String getPurchaseButtonText() {
    if (Platform.isIOS) {
      return 'Purchase with Apple Pay';
    } else if (Platform.isAndroid) {
      return 'Purchase with Google Pay';
    } else {
      return 'Purchase';
    }
  }
}
```

## Creating Capability Classes

Organize technical capabilities by feature:

```dart
abstract class DeviceCapabilities {
  bool get hasCamera;
  bool get hasGPS;
  bool get hasBiometricAuth;
  bool get hasNFC;
  bool get hasStylus;
  bool get canMakePhoneCalls;
  bool get canSendSMS;
  bool get hasGyroscope;
  bool get hasAccelerometer;
}

class PlatformDeviceCapabilities implements DeviceCapabilities {
  @override
  bool get hasCamera => _checkCameraAvailability();
  
  @override
  bool get hasBiometricAuth => _checkBiometricSupport();
  
  @override
  bool get hasNFC {
    // NFC is available on most modern Android devices and newer iPhones
    if (Platform.isAndroid) {
      return _checkAndroidNFC();
    } else if (Platform.isIOS) {
      // iPhone 7 and later support NFC
      return _checkIOSNFC();
    }
    return false;
  }
  
  @override
  bool get canMakePhoneCalls {
    // Tablets typically can't make phone calls
    if (Platform.isIOS) {
      return _deviceModel.contains('iPhone');
    } else if (Platform.isAndroid) {
      return _hasTelephonyFeature();
    }
    return false;
  }
  
  // Private implementation methods
  bool _checkCameraAvailability() {
    // Implementation using camera plugin
  }
  
  bool _checkBiometricSupport() {
    // Implementation using local_auth plugin
  }
}
```

## Creating Policy Classes

Organize business rules and platform conventions:

```dart
abstract class AppPolicies {
  // Store policies
  bool shouldAllowExternalPayments();
  bool shouldShowAds();
  bool shouldRequestAppStoreReview();
  
  // Design policies
  bool shouldUseNativeNavigation();
  bool shouldShowSplashScreen();
  EdgeInsets getDefaultPadding();
  
  // Privacy policies
  bool shouldRequestTrackingPermission();
  bool shouldShowCookieBanner();
  
  // Feature policies
  bool shouldEnableOfflineMode();
  bool shouldAutoBackup();
  int getMaxFileUploadSize();
}

class PlatformAppPolicies implements AppPolicies {
  @override
  bool shouldAllowExternalPayments() {
    // Apple App Store Guidelines 3.1.1 prohibit external payment links
    // Google Play allows them with proper disclosure
    if (Platform.isIOS) {
      return false;
    }
    return true;
  }
  
  @override
  bool shouldUseNativeNavigation() {
    // Use platform-specific navigation patterns
    if (Platform.isIOS) {
      return true; // Use Cupertino navigation
    } else if (Platform.isAndroid) {
      return true; // Use Material navigation
    } else {
      return false; // Use custom navigation for web/desktop
    }
  }
  
  @override
  EdgeInsets getDefaultPadding() {
    // Platform-specific padding conventions
    if (Platform.isIOS) {
      return EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    } else if (Platform.isAndroid) {
      return EdgeInsets.all(16);
    } else {
      // Desktop/Web needs more padding
      return EdgeInsets.all(24);
    }
  }
  
  @override
  bool shouldRequestTrackingPermission() {
    // iOS 14.5+ requires ATT permission
    // Android doesn't have equivalent requirement
    if (Platform.isIOS) {
      return _iosVersion >= 14.5;
    }
    return false;
  }
  
  @override
  int getMaxFileUploadSize() {
    // Different limits for different platforms
    if (Platform.isIOS || Platform.isAndroid) {
      return 100 * 1024 * 1024; // 100 MB on mobile
    } else {
      return 500 * 1024 * 1024; // 500 MB on desktop/web
    }
  }
}
```

## Dependency Injection for Testing

Make your code testable by injecting capabilities and policies:

```dart
class PhotoUploadScreen extends StatelessWidget {
  final DeviceCapabilities capabilities;
  final AppPolicies policies;
  
  PhotoUploadScreen({
    DeviceCapabilities? capabilities,
    AppPolicies? policies,
  }) : capabilities = capabilities ?? PlatformDeviceCapabilities(),
       policies = policies ?? PlatformAppPolicies();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (capabilities.hasCamera)
          ElevatedButton(
            onPressed: _takePhoto,
            child: Text('Take Photo'),
          ),
        ElevatedButton(
          onPressed: _pickFromGallery,
          child: Text('Choose from Gallery'),
        ),
        Text('Max file size: ${_formatBytes(policies.getMaxFileUploadSize())}'),
      ],
    );
  }
}

// Testing becomes easy
testWidgets('Shows camera button when camera available', (tester) async {
  final mockCapabilities = MockDeviceCapabilities();
  when(mockCapabilities.hasCamera).thenReturn(true);
  
  await tester.pumpWidget(
    MaterialApp(
      home: PhotoUploadScreen(capabilities: mockCapabilities),
    ),
  );
  
  expect(find.text('Take Photo'), findsOneWidget);
});
```

## Platform-Specific Features

### Feature Detection Pattern

```dart
class FeatureManager {
  // Don't check platform, check for feature availability
  Future<bool> canUseFeature(String feature) async {
    switch (feature) {
      case 'biometric_auth':
        return await _checkBiometricAvailability();
      case 'push_notifications':
        return await _checkPushNotificationSupport();
      case 'ar_core':
        return await _checkARSupport();
      default:
        return false;
    }
  }
  
  Future<bool> _checkBiometricAvailability() async {
    try {
      final LocalAuthentication auth = LocalAuthentication();
      final bool canCheckBiometrics = await auth.canCheckBiometrics;
      final bool isDeviceSupported = await auth.isDeviceSupported();
      return canCheckBiometrics && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }
}
```

### Runtime vs Compile-Time Checks

```dart
class AdaptiveImplementation {
  // Compile-time platform check (tree-shaken on other platforms)
  Widget buildPlatformWidget() {
    if (kIsWeb) {
      return WebImplementation();
    } else if (Platform.isIOS || Platform.isAndroid) {
      return MobileImplementation();
    } else {
      return DesktopImplementation();
    }
  }
  
  // Runtime capability check
  Future<void> shareContent(String content) async {
    if (await canShare()) {
      await Share.share(content);
    } else {
      // Fallback: Copy to clipboard
      await Clipboard.setData(ClipboardData(text: content));
      showSnackBar('Copied to clipboard');
    }
  }
  
  Future<bool> canShare() async {
    // Check if share capability is available
    try {
      // This might fail on some platforms
      return await Share.shareAvailable();
    } catch (e) {
      return false;
    }
  }
}
```

## Store Policy Implementation

Handle app store requirements elegantly:

```dart
class StorePolicy {
  final TargetPlatform platform;
  
  StorePolicy(this.platform);
  
  bool mustUseInAppPurchase() {
    // Apple requires IAP for digital goods
    return platform == TargetPlatform.iOS;
  }
  
  bool canLinkToExternalSubscription() {
    // Apple prohibits external subscription links
    // Google allows with proper disclosure
    return platform != TargetPlatform.iOS;
  }
  
  bool requiresAgeGating() {
    // COPPA compliance for US
    // Different requirements in different regions
    return true; // Simplified - would check region
  }
  
  String getPrivacyPolicyUrl() {
    // Platform-specific privacy policy URLs
    switch (platform) {
      case TargetPlatform.iOS:
        return 'https://example.com/privacy/ios';
      case TargetPlatform.android:
        return 'https://example.com/privacy/android';
      default:
        return 'https://example.com/privacy';
    }
  }
}
```

## Design System Policies

Platform-specific design decisions:

```dart
class DesignPolicy {
  final BuildContext context;
  
  DesignPolicy(this.context);
  
  bool shouldUseCupertinoDesign() {
    // Respect platform conventions
    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.iOS || 
           platform == TargetPlatform.macOS;
  }
  
  Duration getAnimationDuration() {
    // Respect accessibility settings
    final mediaQuery = MediaQuery.of(context);
    if (mediaQuery.disableAnimations) {
      return Duration.zero;
    }
    
    // Platform-specific animation speeds
    if (shouldUseCupertinoDesign()) {
      return Duration(milliseconds: 250); // iOS standard
    } else {
      return Duration(milliseconds: 200); // Material standard
    }
  }
  
  double getElevation() {
    // iOS doesn't use elevation/shadows the same way
    if (shouldUseCupertinoDesign()) {
      return 0;
    } else {
      return 4; // Material elevation
    }
  }
}
```

## Testing Strategies

### Mock Implementations

```dart
class MockDeviceCapabilities implements DeviceCapabilities {
  final bool _hasCamera;
  final bool _hasGPS;
  
  MockDeviceCapabilities({
    bool hasCamera = true,
    bool hasGPS = true,
  }) : _hasCamera = hasCamera,
       _hasGPS = hasGPS;
  
  @override
  bool get hasCamera => _hasCamera;
  
  @override
  bool get hasGPS => _hasGPS;
}

class MockAppPolicies implements AppPolicies {
  final bool _allowExternalPayments;
  
  MockAppPolicies({
    bool allowExternalPayments = true,
  }) : _allowExternalPayments = allowExternalPayments;
  
  @override
  bool shouldAllowExternalPayments() => _allowExternalPayments;
}
```

## Best Practices

1. **Abstract platform checks**: Create methods that describe intent, not platform
2. **Document why**: Always document why behavior differs between platforms
3. **Use dependency injection**: Make code testable by injecting capabilities/policies
4. **Check features, not platforms**: Detect capability availability rather than platform type
5. **Centralize policies**: Keep all policy decisions in dedicated classes
6. **Version defensively**: Account for OS version differences
7. **Fail gracefully**: Always provide fallbacks for missing capabilities
8. **Keep policies updatable**: Store policies that might change in remote config