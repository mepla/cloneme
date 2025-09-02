import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/auth_models.dart';
import '../../repositories/auth_repository.dart';
import '../../services/secure_storage_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final SecureStorageService _storageService;

  AuthBloc({
    required AuthRepository authRepository,
    required SecureStorageService storageService,
  })  : _authRepository = authRepository,
        _storageService = storageService,
        super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegistrationRequested>(_onRegistrationRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthTokenRefreshRequested>(_onTokenRefreshRequested);
    on<AuthUserLoaded>(_onUserLoaded);
  }

  Future<void> _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      final token = await _storageService.getAccessToken();
      
      if (token == null || !await _storageService.isTokenValid()) {
        emit(AuthUnauthenticated());
        return;
      }

      // Token exists and is valid, get user profile
      final user = await _authRepository.getCurrentUser();
      emit(AuthAuthenticated(user));
    } catch (e) {
      // If getting user profile fails, clear tokens and show as unauthenticated
      await _storageService.clearTokens();
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      final loginRequest = LoginRequest(
        email: event.email,
        password: event.password,
      );
      
      await _authRepository.login(loginRequest);
      
      // After successful login, get user profile
      final user = await _authRepository.getCurrentUser();
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegistrationRequested(AuthRegistrationRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      final registrationRequest = UserRegistrationRequest(
        email: event.email,
        password: event.password,
        displayName: event.displayName,
      );
      
      await _authRepository.register(registrationRequest);
      
      // After successful registration, get user profile
      final user = await _authRepository.getCurrentUser();
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      await _authRepository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      // Even if logout fails on server, clear local state
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onTokenRefreshRequested(AuthTokenRefreshRequested event, Emitter<AuthState> emit) async {
    try {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken == null) {
        emit(AuthUnauthenticated());
        return;
      }

      await _authRepository.refreshToken(refreshToken);
      
      // After successful refresh, get user profile
      final user = await _authRepository.getCurrentUser();
      emit(AuthAuthenticated(user));
    } catch (e) {
      await _storageService.clearTokens();
      emit(AuthUnauthenticated());
    }
  }

  void _onUserLoaded(AuthUserLoaded event, Emitter<AuthState> emit) {
    emit(AuthAuthenticated(event.user));
  }
}