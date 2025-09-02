import 'package:dio/dio.dart';
import '../models/auth_models.dart';
import '../services/api_client.dart';
import '../services/secure_storage_service.dart';

abstract class AuthRepository {
  Future<TokenResponse> register(UserRegistrationRequest request);
  Future<TokenResponse> login(LoginRequest request);
  Future<TokenResponse> refreshToken(String refreshToken);
  Future<void> logout();
  Future<UserResponse> getCurrentUser();
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final SecureStorageService _storage;

  AuthRepositoryImpl({
    required ApiClient apiClient,
    required SecureStorageService storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  @override
  Future<TokenResponse> register(UserRegistrationRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/register',
        data: request.toJson(),
      );
      
      final tokenResponse = TokenResponse.fromJson(response.data);
      await _storage.saveTokens(tokenResponse);
      
      return tokenResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<TokenResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: request.toJson(),
      );
      
      final tokenResponse = TokenResponse.fromJson(response.data);
      await _storage.saveTokens(tokenResponse);
      
      return tokenResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<TokenResponse> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      
      final tokenResponse = TokenResponse.fromJson(response.data);
      await _storage.saveTokens(tokenResponse);
      
      return tokenResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/auth/logout');
    } catch (e) {
      // Even if logout fails on server, clear local tokens
    } finally {
      await _storage.clearTokens();
    }
  }

  @override
  Future<UserResponse> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get('/auth/me');
      return UserResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  AuthenticationException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return AuthenticationException(
          'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        return _handleServerError(error.response);
      case DioExceptionType.connectionError:
        return AuthenticationException(
          'No internet connection. Please check your network.',
        );
      default:
        return AuthenticationException(
          'An unexpected error occurred. Please try again.',
        );
    }
  }

  AuthenticationException _handleServerError(Response? response) {
    if (response == null) {
      return AuthenticationException('Server error occurred.');
    }

    switch (response.statusCode) {
      case 400:
        final message = response.data['detail'] ?? 'Invalid request';
        return AuthenticationException(message);
      case 401:
        return AuthenticationException('Invalid credentials');
      case 422:
        final errors = response.data['detail'];
        if (errors is List && errors.isNotEmpty) {
          return AuthenticationException(errors[0]['msg'] ?? 'Validation error');
        }
        return AuthenticationException('Validation error');
      case 500:
        return AuthenticationException('Server error. Please try again later.');
      default:
        return AuthenticationException('Unknown error occurred');
    }
  }
}

class AuthenticationException implements Exception {
  final String message;
  
  AuthenticationException(this.message);

  @override
  String toString() => message;
}