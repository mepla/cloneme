# Frontend Authentication Implementation Plan

## Project Overview
EverMynd is a human-centric AI coaching platform. The frontend will be a Flutter 3.35+ application built for responsive Web, Android, and iOS. The app serves both end users (consumers) and creators, with authentication and authorization handled via Supabase integration through the backend API.

## Authentication Requirements Analysis

Based on the main spec and backend implementation, the authentication system must support:

### User Types & Roles
- **Consumer Role**: Regular users who consume AI coaching content
- **Creator Role**: Users who create AI coaches (can also be consumers)
- **Admin Role**: System administrators
- Users can have multiple roles assigned simultaneously

### Core Authentication Features
1. **User Registration**: Email/password signup with optional display name
2. **User Login**: Email/password authentication
3. **Token Management**: JWT access tokens with refresh token support
4. **User Profile**: Access to current user information including roles
5. **Session Management**: Logout functionality
6. **Role-based Access Control**: Different UI/functionality based on user roles

### Backend API Integration
The backend provides these endpoints:
- `POST /auth/register` - User registration
- `POST /auth/login` - User authentication  
- `POST /auth/refresh` - Token refresh
- `POST /auth/logout` - User logout
- `GET /auth/me` - Get current user profile

## Flutter App Architecture Plan

### 1. Project Structure
```
frontend/
├── lib/
│   ├── main.dart
│   ├── app/
│   │   ├── app.dart
│   │   └── router/
│   │       └── app_router.dart
│   ├── core/
│   │   ├── constants/
│   │   │   └── api_constants.dart
│   │   ├── error/
│   │   │   ├── exceptions.dart
│   │   │   └── failure.dart
│   │   ├── network/
│   │   │   ├── dio_client.dart
│   │   │   └── network_info.dart
│   │   └── utils/
│   │       ├── validators.dart
│   │       └── extensions.dart
│   ├── features/
│   │   └── authentication/
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   ├── auth_local_datasource.dart
│   │       │   │   └── auth_remote_datasource.dart
│   │       │   ├── models/
│   │       │   │   ├── user_model.dart
│   │       │   │   ├── login_request_model.dart
│   │       │   │   ├── register_request_model.dart
│   │       │   │   └── token_response_model.dart
│   │       │   └── repositories/
│   │       │       └── auth_repository_impl.dart
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   ├── user.dart
│   │       │   │   └── auth_token.dart
│   │       │   ├── repositories/
│   │       │   │   └── auth_repository.dart
│   │       │   └── usecases/
│   │       │       ├── login_usecase.dart
│   │       │       ├── register_usecase.dart
│   │       │       ├── logout_usecase.dart
│   │       │       ├── refresh_token_usecase.dart
│   │       │       └── get_current_user_usecase.dart
│   │       └── presentation/
│   │           ├── bloc/
│   │           │   ├── auth_bloc.dart
│   │           │   ├── auth_event.dart
│   │           │   └── auth_state.dart
│   │           ├── pages/
│   │           │   ├── login_page.dart
│   │           │   ├── register_page.dart
│   │           │   └── splash_page.dart
│   │           └── widgets/
│   │               ├── auth_form.dart
│   │               ├── custom_text_field.dart
│   │               └── auth_button.dart
│   └── shared/
│       ├── widgets/
│       │   ├── loading_widget.dart
│       │   └── error_widget.dart
│       └── theme/
│           └── app_theme.dart
├── pubspec.yaml
└── analysis_options.yaml
```

### 2. Key Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  
  # HTTP & API
  dio: ^5.3.2
  retrofit: ^4.0.3
  json_annotation: ^4.8.1
  
  # Local Storage
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0
  
  # Dependency Injection
  get_it: ^7.6.4
  injectable: ^2.3.2
  
  # Routing
  go_router: ^12.1.1
  
  # Form Validation
  formz: ^0.6.1
  
  # UI Components
  flutter_screenutil: ^5.9.0

dev_dependencies:
  build_runner: ^2.4.7
  retrofit_generator: ^8.0.4
  json_serializable: ^6.7.1
  injectable_generator: ^2.4.1
  flutter_test:
    sdk: flutter
  mockito: ^5.4.2
  bloc_test: ^9.1.4
```

### 3. Authentication Flow Design

#### Login Flow
1. User enters email/password on LoginPage
2. LoginEvent triggered in AuthBloc
3. LoginUseCase validates input and calls AuthRepository
4. AuthRepository calls AuthRemoteDataSource
5. HTTP request to backend `/auth/login` endpoint
6. On success: Store tokens locally, emit AuthenticatedState
7. On failure: Emit AuthErrorState with error message
8. Navigate to appropriate screen based on user roles

#### Registration Flow
1. User fills registration form on RegisterPage
2. RegisterEvent triggered in AuthBloc
3. RegisterUseCase validates input and calls AuthRepository
4. AuthRepository calls AuthRemoteDataSource
5. HTTP request to backend `/auth/register` endpoint
6. On success: Store tokens locally, emit AuthenticatedState
7. On failure: Emit AuthErrorState with error message
8. Navigate to appropriate screen based on user roles

#### Token Management Flow
1. Store access_token and refresh_token securely using FlutterSecureStorage
2. Attach access_token to all authenticated API requests via Dio interceptor
3. On 401 response, automatically attempt token refresh
4. If refresh succeeds: Retry original request with new token
5. If refresh fails: Clear stored tokens, emit UnauthenticatedState, navigate to login

#### App Initialization Flow
1. SplashPage displays while checking authentication status
2. Check for stored access_token in FlutterSecureStorage
3. If token exists: Validate with `/auth/me` endpoint
4. If valid: Emit AuthenticatedState with user data
5. If invalid/expired: Attempt token refresh
6. If no token or refresh fails: Emit UnauthenticatedState
7. Navigate to appropriate screen based on authentication state

### 4. State Management with BLoC

#### AuthBloc States
```dart
abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthUnauthenticated extends AuthState {}
class AuthAuthenticated extends AuthState {
  final User user;
}
class AuthError extends AuthState {
  final String message;
}
```

#### AuthBloc Events
```dart
abstract class AuthEvent extends Equatable {}

class AuthStarted extends AuthEvent {}
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
}
class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String? displayName;
}
class AuthLogoutRequested extends AuthEvent {}
class AuthRefreshRequested extends AuthEvent {}
```

### 5. Data Models

#### User Entity
```dart
class User extends Equatable {
  final String userId;
  final String email;
  final String? displayName;
  final List<String> roles;
  final String subscriptionStatus;
  final DateTime createdAt;
}
```

#### AuthToken Entity
```dart
class AuthToken extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final DateTime issuedAt;
}
```

### 6. Network Layer Design

#### Dio Configuration
- Base URL configuration pointing to backend API
- Request/Response interceptors for token management
- Error handling interceptor for consistent error responses
- Logging interceptor for development debugging

#### AuthRemoteDataSource
```dart
abstract class AuthRemoteDataSource {
  Future<TokenResponseModel> login(LoginRequestModel request);
  Future<TokenResponseModel> register(RegisterRequestModel request);
  Future<TokenResponseModel> refreshToken(String refreshToken);
  Future<UserModel> getCurrentUser();
  Future<void> logout();
}
```

### 7. Local Storage Strategy

#### Token Storage
- Use FlutterSecureStorage for access_token and refresh_token
- Store user profile data in SharedPreferences for quick access
- Implement data encryption for sensitive information

#### Cache Management
- Cache user profile data locally to reduce API calls
- Implement cache invalidation strategies
- Clear all local data on logout

### 8. Error Handling Strategy

#### Error Types
- Network errors (no connection, timeouts)
- Authentication errors (invalid credentials, token expired)
- Validation errors (invalid email format, weak password)
- Server errors (500, 502, etc.)

#### Error Presentation
- User-friendly error messages in UI
- Consistent error state management in BLoC
- Retry mechanisms for recoverable errors
- Graceful degradation for non-critical failures

### 9. UI/UX Design Considerations

#### Responsive Design
- Use ScreenUtil for responsive layouts across devices
- Implement platform-specific adaptations (Material/Cupertino)
- Support for various screen sizes and orientations

#### Form Design
- Email/password input fields with proper validation
- Real-time form validation with visual feedback
- Loading states during authentication requests
- Clear error message display

#### Navigation Strategy
- Protected routes requiring authentication
- Role-based navigation (different screens for consumers vs creators)
- Deep linking support for authenticated routes
- Proper back navigation handling

### 10. Security Considerations

#### Token Security
- Store tokens in FlutterSecureStorage (encrypted)
- Never log sensitive data in production
- Implement automatic token refresh
- Clear sensitive data from memory after use

#### Input Validation
- Client-side validation for user experience
- Server-side validation as primary security measure
- Sanitize all user inputs
- Implement rate limiting for authentication attempts

### 11. Testing Strategy

#### Unit Tests
- Test all UseCases with mock repositories
- Test BLoC logic with various event/state scenarios
- Test data model serialization/deserialization
- Test validation logic

#### Widget Tests
- Test authentication forms and user interactions
- Test navigation flows
- Test error state presentations
- Test loading states

#### Integration Tests
- Test full authentication flows end-to-end
- Test token refresh mechanism
- Test offline/online behavior
- Test role-based access control

### 12. Performance Optimization

#### API Optimization
- Implement request caching where appropriate
- Use pagination for large data sets
- Minimize API calls through efficient state management
- Implement proper loading states

#### App Performance
- Lazy loading of authentication-related widgets
- Efficient state management to prevent unnecessary rebuilds
- Optimize image and asset loading
- Implement proper memory management

### 13. Accessibility

#### Screen Reader Support
- Proper semantic labels for all interactive elements
- Descriptive error messages
- Focus management for form navigation

#### Visual Accessibility
- High contrast color schemes
- Scalable text sizes
- Clear visual hierarchy
- Loading indicators with proper announcements

## Implementation Phases

### Phase 1: Core Authentication Setup
1. Set up Flutter project structure
2. Configure dependencies and build tools
3. Implement basic data models and entities
4. Set up network layer with Dio
5. Implement local storage layer

### Phase 2: Authentication Logic
1. Implement AuthRepository and data sources
2. Create authentication use cases
3. Set up AuthBloc with state management
4. Implement token management and refresh logic

### Phase 3: UI Implementation
1. Design and implement login page
2. Design and implement registration page
3. Create reusable authentication widgets
4. Implement splash screen and app initialization

### Phase 4: Integration and Navigation
1. Integrate authentication with app routing
2. Implement role-based navigation
3. Set up protected routes
4. Handle deep linking for authenticated routes

### Phase 5: Testing and Optimization
1. Write comprehensive unit tests
2. Implement widget and integration tests
3. Performance optimization and testing
4. Accessibility testing and improvements

### Phase 6: Error Handling and Edge Cases
1. Comprehensive error handling implementation
2. Offline/online state management
3. Edge case handling (expired tokens, network issues)
4. User experience refinements

This plan provides a comprehensive roadmap for implementing the authentication feature in the Flutter frontend, ensuring scalability, maintainability, and adherence to Flutter best practices while integrating seamlessly with the existing backend API.