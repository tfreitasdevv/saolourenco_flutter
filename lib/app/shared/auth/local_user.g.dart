// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_user.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LocalUser on _LocalUserBase, Store {
  late final _$firebaseUserAtom =
      Atom(name: '_LocalUserBase.firebaseUser', context: context);

  @override
  User? get firebaseUser {
    _$firebaseUserAtom.reportRead();
    return super.firebaseUser;
  }

  @override
  set firebaseUser(User? value) {
    _$firebaseUserAtom.reportWrite(value, super.firebaseUser, () {
      super.firebaseUser = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_LocalUserBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$nomeAtom = Atom(name: '_LocalUserBase.nome', context: context);

  @override
  String? get nome {
    _$nomeAtom.reportRead();
    return super.nome;
  }

  @override
  set nome(String? value) {
    _$nomeAtom.reportWrite(value, super.nome, () {
      super.nome = value;
    });
  }

  late final _$emailAtom = Atom(name: '_LocalUserBase.email', context: context);

  @override
  String? get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String? value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$erroAoCriarUsuarioAtom =
      Atom(name: '_LocalUserBase.erroAoCriarUsuario', context: context);

  @override
  String? get erroAoCriarUsuario {
    _$erroAoCriarUsuarioAtom.reportRead();
    return super.erroAoCriarUsuario;
  }

  @override
  set erroAoCriarUsuario(String? value) {
    _$erroAoCriarUsuarioAtom.reportWrite(value, super.erroAoCriarUsuario, () {
      super.erroAoCriarUsuario = value;
    });
  }

  late final _$erroAoLogarAtom =
      Atom(name: '_LocalUserBase.erroAoLogar', context: context);

  @override
  String? get erroAoLogar {
    _$erroAoLogarAtom.reportRead();
    return super.erroAoLogar;
  }

  @override
  set erroAoLogar(String? value) {
    _$erroAoLogarAtom.reportWrite(value, super.erroAoLogar, () {
      super.erroAoLogar = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('_LocalUserBase.init', context: context);

  @override
  Future init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$setFirebaseUserAsyncAction =
      AsyncAction('_LocalUserBase.setFirebaseUser', context: context);

  @override
  Future setFirebaseUser(User? value) {
    return _$setFirebaseUserAsyncAction.run(() => super.setFirebaseUser(value));
  }

  late final _$_LocalUserBaseActionController =
      ActionController(name: '_LocalUserBase', context: context);

  @override
  bool isLoggedIn() {
    final _$actionInfo = _$_LocalUserBaseActionController.startAction(
        name: '_LocalUserBase.isLoggedIn');
    try {
      return super.isLoggedIn();
    } finally {
      _$_LocalUserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsLoadingTrue() {
    final _$actionInfo = _$_LocalUserBaseActionController.startAction(
        name: '_LocalUserBase.setIsLoadingTrue');
    try {
      return super.setIsLoadingTrue();
    } finally {
      _$_LocalUserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsLoadingFalse() {
    final _$actionInfo = _$_LocalUserBaseActionController.startAction(
        name: '_LocalUserBase.setIsLoadingFalse');
    try {
      return super.setIsLoadingFalse();
    } finally {
      _$_LocalUserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic mudarNome(String value) {
    final _$actionInfo = _$_LocalUserBaseActionController.startAction(
        name: '_LocalUserBase.mudarNome');
    try {
      return super.mudarNome(value);
    } finally {
      _$_LocalUserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic mudarEmail(String value) {
    final _$actionInfo = _$_LocalUserBaseActionController.startAction(
        name: '_LocalUserBase.mudarEmail');
    try {
      return super.mudarEmail(value);
    } finally {
      _$_LocalUserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic mudarErroAoCriarUsuario(String value) {
    final _$actionInfo = _$_LocalUserBaseActionController.startAction(
        name: '_LocalUserBase.mudarErroAoCriarUsuario');
    try {
      return super.mudarErroAoCriarUsuario(value);
    } finally {
      _$_LocalUserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic mudarErroAoLogar(String value) {
    final _$actionInfo = _$_LocalUserBaseActionController.startAction(
        name: '_LocalUserBase.mudarErroAoLogar');
    try {
      return super.mudarErroAoLogar(value);
    } finally {
      _$_LocalUserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
firebaseUser: ${firebaseUser},
isLoading: ${isLoading},
nome: ${nome},
email: ${email},
erroAoCriarUsuario: ${erroAoCriarUsuario},
erroAoLogar: ${erroAoLogar}
    ''';
  }
}
