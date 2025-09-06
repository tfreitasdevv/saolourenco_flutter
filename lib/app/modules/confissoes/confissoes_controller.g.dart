// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confissoes_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConfissoesController on _ConfissoesBase, Store {
  late final _$textoConfissoesAtom =
      Atom(name: '_ConfissoesBase.textoConfissoes', context: context);

  @override
  String get textoConfissoes {
    _$textoConfissoesAtom.reportRead();
    return super.textoConfissoes;
  }

  @override
  set textoConfissoes(String value) {
    _$textoConfissoesAtom.reportWrite(value, super.textoConfissoes, () {
      super.textoConfissoes = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_ConfissoesBase.isLoading', context: context);

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

  late final _$carregarTextoConfissoesAsyncAction =
      AsyncAction('_ConfissoesBase.carregarTextoConfissoes', context: context);

  @override
  Future<void> carregarTextoConfissoes() {
    return _$carregarTextoConfissoesAsyncAction
        .run(() => super.carregarTextoConfissoes());
  }

  @override
  String toString() {
    return '''
textoConfissoes: ${textoConfissoes},
isLoading: ${isLoading}
    ''';
  }
}
