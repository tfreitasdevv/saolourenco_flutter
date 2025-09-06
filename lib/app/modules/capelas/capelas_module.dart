import 'package:paroquia_sao_lourenco/app/modules/capelas/capelas_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/capelas/capelas_page.dart';

class CapelasModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(CapelasController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => CapelasPage());
  }
}
