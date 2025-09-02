import 'package:dio/dio.dart';
import 'secure_storage_service.dart';

class ApiClient {
  static const String baseUrl = 'http://localhost:8000/api/v1';
  
  late final Dio _dio;
  final SecureStorageService _storage = SecureStorageService();

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(AuthInterceptor(_storage));
  }

  Dio get dio => _dio;
}

class AuthInterceptor extends Interceptor {
  final SecureStorageService _storage;

  AuthInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip auth header for auth endpoints
    if (options.path.contains('/auth/register') ||
        options.path.contains('/auth/login') ||
        options.path.contains('/auth/refresh')) {
      return handler.next(options);
    }

    final token = await _storage.getAccessToken();
    if (token != null && await _storage.isTokenValid()) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token might be expired, try to refresh
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken != null) {
        try {
          // Create a new dio instance to avoid infinite loop
          final dio = Dio(BaseOptions(baseUrl: ApiClient.baseUrl));
          
          final response = await dio.post(
            '/auth/refresh',
            data: {'refresh_token': refreshToken},
          );
          
          if (response.statusCode == 200) {
            // Save new tokens and retry original request
            // This would need proper TokenResponse parsing
            final newToken = response.data['access_token'];
            
            // Retry the original request
            final opts = err.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newToken';
            
            final retryResponse = await dio.fetch(opts);
            return handler.resolve(retryResponse);
          }
        } catch (e) {
          // Refresh failed, clear tokens and let the error propagate
          await _storage.clearTokens();
        }
      }
    }
    
    handler.next(err);
  }
}