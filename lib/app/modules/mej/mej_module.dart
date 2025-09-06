import 'package:paroquia_sao_lourenco/app/modules/mej/mej_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/mej/mej_page.dart';

class MejModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(MejController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => MejPage());
  }
}
