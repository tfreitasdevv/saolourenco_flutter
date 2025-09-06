// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mae_tres_vezes_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MaeTresVezesController on _MaeTresVezesBase, Store {
  late final _$valueAtom =
      Atom(name: '_MaeTresVezesBase.value', context: context);

  @override
  int get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(int value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  late final _$_MaeTresVezesBaseActionController =
      ActionController(name: '_MaeTresVezesBase', context: context);

  @override
  void increment() {
    final _$actionInfo = _$_MaeTresVezesBaseActionController.startAction(
        name: '_MaeTresVezesBase.increment');
    try {
      return super.increment();
    } finally {
      _$_MaeTresVezesBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
