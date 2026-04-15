import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:paroquia_sao_lourenco/app/shared/config/api_config.dart';

/// Cliente HTTP centralizado para comunicação com a API Strapi.
///
/// Gerencia autenticação JWT automaticamente via interceptor.
/// Uso: injetado via Flutter Modular como singleton.
class StrapiClient {
  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _tokenKey = 'strapi_jwt';

  StrapiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: '${ApiConfig.baseUrl}${ApiConfig.apiPath}',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          debugPrint(
            '❌ StrapiClient erro: ${error.response?.statusCode} '
            '${error.requestOptions.path} — ${error.message}',
          );
          return handler.next(error);
        },
      ),
    );
  }

  // --- Métodos HTTP ---

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.put(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.delete(path, queryParameters: queryParameters);
  }

  // --- Gerenciamento de Token JWT ---

  Future<void> saveToken(String token) async {
    if (kIsWeb) {
      // flutter_secure_storage no web usa localStorage
      // Para web, o token é armazenado de forma segura via plugin
    }
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> removeToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<bool> get hasToken async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
