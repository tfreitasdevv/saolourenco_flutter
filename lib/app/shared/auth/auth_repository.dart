import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:paroquia_sao_lourenco/app/shared/auth/local_user.dart';
import 'package:paroquia_sao_lourenco/app/shared/auth/strapi_auth_service.dart';
import 'package:paroquia_sao_lourenco/app/shared/services/strapi_client.dart';

class AuthRepository {
  final LocalUser localUser;
  final StrapiAuthService _authService;
  final StrapiClient _client;
  Map<String, dynamic> dadosUsuario = {};

  AuthRepository(this.localUser, this._authService, this._client);

  void criarUsuario({
    required Map<String, dynamic> dadosUsuario,
    required String senha,
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) async {
    await localUser.setIsLoadingTrue();
    try {
      final email = (dadosUsuario['email'] as String).toLowerCase().trim();

      final result = await _authService.register(
        username: email,
        email: email,
        password: senha,
      );

      final userData = result['user'] as Map<String, dynamic>?;
      final userId = userData?['id'] as int?;

      if (userId != null) {
        final dadosExtras = <String, dynamic>{
          'nome': dadosUsuario['nome'],
          'celular': dadosUsuario['celular'],
          'nascimento': dadosUsuario['nascimento'],
          'sexo': dadosUsuario['sexo'],
        };

        if (dadosUsuario['endereco'] != null) {
          dadosExtras['endereco'] = dadosUsuario['endereco'];
        }

        await _authService.updateProfile(userId, dadosExtras);

        final me = await _authService.getMe();
        localUser.setUserData(me);
      }

      this.dadosUsuario = dadosUsuario;
      onSuccess();
    } on DioException catch (e) {
      final msg = StrapiAuthService.extractErrorMessage(e);
      if (msg.contains('already taken') || msg.contains('already exists')) {
        localUser.mudarErroAoCriarUsuario('auth/email-already-in-use');
      } else {
        localUser.mudarErroAoCriarUsuario(msg);
      }
      onFail();
    } catch (e) {
      debugPrint('❌ Erro ao criar usuário: $e');
      localUser.mudarErroAoCriarUsuario(e.toString());
      onFail();
    } finally {
      await localUser.setIsLoadingFalse();
    }
  }

  void logar({
    required String email,
    required String senha,
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) async {
    await localUser.setIsLoadingTrue();
    try {
      await _authService.login(
        identifier: email.trim(),
        password: senha.trim(),
      );

      final me = await _authService.getMe();
      localUser.setUserData(me);
      dadosUsuario = me;
      onSuccess();
    } on DioException catch (e) {
      final msg = StrapiAuthService.extractErrorMessage(e);
      if (msg.contains('Invalid identifier') || msg.contains('invalid')) {
        localUser.mudarErroAoLogar('auth/wrong-password');
      } else {
        localUser.mudarErroAoLogar(msg);
      }
      onFail();
    } catch (e) {
      debugPrint('❌ Erro ao logar: $e');
      localUser.mudarErroAoLogar(e.toString());
      onFail();
    } finally {
      await localUser.setIsLoadingFalse();
    }
  }

  void logout() {
    _authService.logout();
    dadosUsuario = {};
    localUser.clearUser();
  }

  Future<void> obterUsuarioAtual() async {
    try {
      final autenticado = await _authService.isAuthenticated;
      if (autenticado) {
        final me = await _authService.getMe();
        localUser.setUserData(me);
        dadosUsuario = me;
      }
    } catch (e) {
      debugPrint('⚠️ Erro ao obter usuário atual: $e');
    }
  }

  Future<Map<String, dynamic>> obterUsuarioProfile() async {
    try {
      final autenticado = await _authService.isAuthenticated;
      if (autenticado) {
        final me = await _authService.getMe();
        localUser.setUserData(me);
        dadosUsuario = me;
      }
    } catch (e) {
      debugPrint('⚠️ Erro ao obter perfil: $e');
    }
    return dadosUsuario;
  }

  Future<void> atualizarDadosUsuario(Map<String, dynamic> dadosUsuario) async {
    if (localUser.userId == null) return;
    await _authService.updateProfile(localUser.userId!, dadosUsuario);
    this.dadosUsuario = {...this.dadosUsuario, ...dadosUsuario};
  }

  void recuperarSenha(String email) async {
    try {
      await _client.post(
        '/auth/forgot-password',
        data: {'email': email.trim()},
      );
    } catch (e) {
      debugPrint('⚠️ Recuperação de senha: $e');
    }
  }
}