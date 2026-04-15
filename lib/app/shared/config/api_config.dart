import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl =>
      dotenv.env['STRAPI_URL'] ?? 'http://localhost:1337';

  static String get apiPath => '/api';

  // Endpoints de conteúdo público (sem autenticação)
  static const String avisos = '/avisos';
  static const String avisosMusica = '/aviso-musicas';
  static const String cleros = '/cleros';
  static const String comoAjudar = '/como-ajudars';
  static const String confissoes = '/confissoes';
  static const String eventos = '/eventos';
  static const String horariosMissa = '/horario-missas';
  static const String imagensCapelas = '/imagem-capelas';
  static const String pastoralConteudos = '/pastoral-conteudos';

  // Endpoints de autenticação
  static const String authLogin = '/auth/local';
  static const String authRegister = '/auth/local/register';
  static const String usersMe = '/users/me';

  /// Monta a URL completa de um endpoint da API.
  static String endpoint(String path) => '$baseUrl$apiPath$path';

  /// Monta a URL completa de um endpoint fora do /api (ex: auth).
  static String authEndpoint(String path) => '$baseUrl$apiPath$path';
}
