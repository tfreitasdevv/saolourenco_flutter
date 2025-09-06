// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catequese_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CatequeseController on _CatequeseBase, Store {
  late final _$valueAtom = Atom(name: '_CatequeseBase.value', context: context);

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

  late final _$_CatequeseBaseActionController =
      ActionController(name: '_CatequeseBase', context: context);

  @override
  void increment() {
    final _$actionInfo = _$_CatequeseBaseActionController.startAction(
        name: '_CatequeseBase.increment');
    try {
      return super.increment();
    } finally {
      _$_CatequeseBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
