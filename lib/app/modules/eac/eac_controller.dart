import 'package:mobx/mobx.dart';

part 'eac_controller.g.dart';

class EacController = _EacBase with _$EacController;

abstract class _EacBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
