import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paroquia_sao_lourenco/app/shared/auth/local_user.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalUser localUser;
  Map<String, dynamic> dadosUsuario = {};

  AuthRepository(this.localUser);

  void criarUsuario({
    required Map<String, dynamic> dadosUsuario,
    required String senha,
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) async {
    await localUser.setIsLoadingTrue();
    _auth
        .createUserWithEmailAndPassword(
      email: dadosUsuario["email"],
      password: senha,
    )
        .then((authResult) async {
      localUser.setFirebaseUser(authResult.user!);
      await _salvarDadosUsuario(dadosUsuario);
      onSuccess();
      await localUser.setIsLoadingFalse();
    }).catchError((e) async {
      await localUser.mudarErroAoCriarUsuario(e.code);
      onFail();
      await localUser.setIsLoadingFalse();
    });
  }

  Future<void> _salvarDadosUsuario(Map<String, dynamic> dadosUsuario) async {
    this.dadosUsuario = dadosUsuario;
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(localUser.firebaseUser!.uid)
        .set(dadosUsuario);
  }

  Future<void> atualizarDadosUsuario(Map<String, dynamic> dadosUsuario) async {
    this.dadosUsuario = dadosUsuario;
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(localUser.firebaseUser!.uid)
        .update(dadosUsuario);
  }

  void logar({
    required String email,
    required String senha,
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) async {
    await localUser.setIsLoadingTrue();
    _auth
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((authResult) async {
      await localUser.setFirebaseUser(authResult.user!);
      await obterUsuarioAtual();
      onSuccess();
      await localUser.setIsLoadingFalse();
    }).catchError((e) async {
      await localUser.mudarErroAoLogar(e.code);
      onFail();
      await localUser.setIsLoadingFalse();
    });
  }

  void logout() async {
    await _auth.signOut();
    dadosUsuario = {};
    localUser.setFirebaseUser(null);
    localUser.mudarNome('');
    localUser.mudarEmail('');
  }

  Future<void> obterUsuarioAtual() async {
    if (localUser.firebaseUser == null) {
      localUser.firebaseUser = _auth.currentUser;
    }
    if (localUser.firebaseUser != null) {
      DocumentSnapshot docUser = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(localUser.firebaseUser!.uid)
          .get();
      dadosUsuario = docUser.data() as Map<String, dynamic>? ?? {};
    }
  }

  Future<Map<String, dynamic>> obterUsuarioProfile() async {
    if (localUser.firebaseUser == null) {
      localUser.firebaseUser = _auth.currentUser;
    }
    if (localUser.firebaseUser != null) {
      DocumentSnapshot docUser = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(localUser.firebaseUser!.uid)
          .get();
      dadosUsuario = docUser.data() as Map<String, dynamic>? ?? {};
    }
    return dadosUsuario;
  }

  void recuperarSenha(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }
}