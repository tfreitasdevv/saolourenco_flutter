// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eventos_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EventosController on _EventosBase, Store {
  late final _$valueAtom = Atom(name: '_EventosBase.value', context: context);

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

  late final _$_EventosBaseActionController =
      ActionController(name: '_EventosBase', context: context);

  @override
  void increment() {
    final _$actionInfo = _$_EventosBaseActionController.startAction(
        name: '_EventosBase.increment');
    try {
      return super.increment();
    } finally {
      _$_EventosBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
