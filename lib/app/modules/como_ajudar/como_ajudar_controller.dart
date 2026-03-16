import 'package:mobx/mobx.dart';

part 'como_ajudar_controller.g.dart';

class ComoAjudarController = _ComoAjudarControllerBase
    with _$ComoAjudarController;

abstract class _ComoAjudarControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
