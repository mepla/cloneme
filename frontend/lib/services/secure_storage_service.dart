import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth_models.dart';

class SecureStorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';
  
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  Future<void> saveTokens(TokenResponse tokens) async {
    final expiryTime = DateTime.now().add(Duration(seconds: tokens.expiresIn));
    
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: tokens.accessToken),
      _storage.write(key: _refreshTokenKey, value: tokens.refreshToken),
      _storage.write(key: _tokenExpiryKey, value: expiryTime.toIso8601String()),
    ]);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<bool> isTokenValid() async {
    final expiryString = await _storage.read(key: _tokenExpiryKey);
    if (expiryString == null) return false;

    final expiryTime = DateTime.parse(expiryString);
    final bufferTime = DateTime.now().add(const Duration(minutes: 5)); // 5 minute buffer
    
    return bufferTime.isBefore(expiryTime);
  }

  Future<DateTime?> getTokenExpiry() async {
    final expiryString = await _storage.read(key: _tokenExpiryKey);
    if (expiryString == null) return null;
    return DateTime.parse(expiryString);
  }

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _tokenExpiryKey),
    ]);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}