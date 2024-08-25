import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'authToken';

  // Save the token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Retrieve the token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Delete the token
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
