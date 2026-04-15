import 'package:dio/dio.dart';
import 'package:paroquia_sao_lourenco/app/shared/config/api_config.dart';
import 'package:paroquia_sao_lourenco/app/shared/services/strapi_client.dart';

/// Serviço de autenticação via Strapi Users & Permissions.
///
/// Gerencia registro, login, logout e consulta de perfil do usuário.
/// Utiliza JWT persistido pelo [StrapiClient].
class StrapiAuthService {
  final StrapiClient _client;

  StrapiAuthService(this._client);

  /// Registra um novo usuário.
  ///
  /// Retorna os dados do usuário criado (incluindo JWT).
  /// Lança [DioException] em caso de erro (email duplicado, validação, etc.).
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    Map<String, dynamic>? extraFields,
  }) async {
    final body = <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
      if (extraFields != null) ...extraFields,
    };

    final response = await _client.post(
      ApiConfig.authRegister,
      data: body,
    );

    final data = response.data as Map<String, dynamic>;
    final jwt = data['jwt'] as String?;
    if (jwt != null) {
      await _client.saveToken(jwt);
    }

    return data;
  }

  /// Autentica um usuário existente.
  ///
  /// Retorna os dados do usuário (incluindo JWT).
  /// Lança [DioException] em caso de credenciais inválidas.
  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    final response = await _client.post(
      ApiConfig.authLogin,
      data: {
        'identifier': identifier,
        'password': password,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final jwt = data['jwt'] as String?;
    if (jwt != null) {
      await _client.saveToken(jwt);
    }

    return data;
  }

  /// Remove o token JWT armazenado, efetivando o logout local.
  Future<void> logout() async {
    await _client.removeToken();
  }

  /// Retorna os dados do usuário autenticado.
  ///
  /// Requer token JWT válido armazenado.
  /// Lança [DioException] se não autenticado (401).
  Future<Map<String, dynamic>> getMe() async {
    final response = await _client.get(ApiConfig.usersMe);
    return response.data as Map<String, dynamic>;
  }

  /// Atualiza os dados do perfil do usuário autenticado.
  ///
  /// [userId] é o ID numérico do usuário no Strapi.
  Future<Map<String, dynamic>> updateProfile(
    int userId,
    Map<String, dynamic> data,
  ) async {
    final response = await _client.put(
      '/users/$userId',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  /// Verifica se existe um token JWT armazenado.
  Future<bool> get isAuthenticated => _client.hasToken;

  /// Extrai informações de erro amigáveis de uma [DioException] do Strapi.
  static String extractErrorMessage(DioException error) {
    try {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final errorObj = data['error'];
        if (errorObj is Map<String, dynamic>) {
          return errorObj['message'] as String? ?? 'Erro desconhecido';
        }
      }
    } catch (_) {}
    return error.message ?? 'Erro de conexão';
  }
}
