import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JwtService {
  final storage = const FlutterSecureStorage();
  final Dio dio = Dio();

  Future<String?> getToken() async {
    return await storage.read(key: 'accessToken');
  }

  setToken(String token) async {
    await storage.write(key: 'accessToken', value: token);
  }

  deleteToken() async {
    await storage.delete(key: 'accessToken');
  }

  Future<bool> isAuthorized() async {
    return await storage.read(key: 'accessToken') != null;
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refreshToken');
  }

  setRefreshToken(String token) async {
    await storage.write(key: 'refreshToken', value: token);
  }

  refreshToken(String refreshToken) {
    var url = 'https://dummyjson.com/auth/refresh';
    return dio.post(url, data: {
      'refreshToken': refreshToken,
    });
  }
}