import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:paroquia_sao_lourenco/app/shared/auth/strapi_auth_service.dart';

part 'local_user.g.dart';

class LocalUser = _LocalUserBase with _$LocalUser;

abstract class _LocalUserBase with Store {
  final StrapiAuthService _authService;

  _LocalUserBase(this._authService) {
    init();
  }

  @action
  Future<void> init() async {
    try {
      final autenticado = await _authService.isAuthenticated;
      if (autenticado) {
        final data = await _authService.getMe();
        _popularDados(data);
      }
    } catch (e) {
      debugPrint('⚠️ LocalUser.init — token inválido ou expirado: $e');
      await _authService.logout();
      clearUser();
    }
  }

  @observable
  int? userId;

  @observable
  Map<String, dynamic>? userData;

  @action
  void setUserData(Map<String, dynamic> data) {
    _popularDados(data);
  }

  @action
  void clearUser() {
    userId = null;
    userData = null;
    nome = null;
    email = null;
  }

  void _popularDados(Map<String, dynamic> data) {
    userId = data['id'] as int?;
    userData = data;
    nome = data['nome'] as String? ?? data['username'] as String?;
    email = data['email'] as String?;
  }

  @action
  bool isLoggedIn() {
    return userId != null;
  }

  @observable
  bool isLoading = false;
  @action
  setIsLoadingTrue() => isLoading = true;
  @action
  setIsLoadingFalse() => isLoading = false;

  @observable
  String? nome;
  @action
  mudarNome(String value) => nome = value;

  @observable
  String? email;
  @action
  mudarEmail(String value) => email = value;

  @observable
  String? erroAoCriarUsuario;
  @action
  mudarErroAoCriarUsuario(String value) {
    erroAoCriarUsuario = value;
  }

  @observable
  String? erroAoLogar;
  @action
  mudarErroAoLogar(String value) {
    erroAoLogar = value;
  }
}