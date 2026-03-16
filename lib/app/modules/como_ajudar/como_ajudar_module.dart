import 'package:paroquia_sao_lourenco/app/modules/como_ajudar/como_ajudar_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/como_ajudar/como_ajudar_page.dart';

class ComoAjudarModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(ComoAjudarController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => ComoAjudarPage());
  }
}
