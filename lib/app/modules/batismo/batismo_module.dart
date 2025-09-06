import 'package:paroquia_sao_lourenco/app/modules/batismo/batismo_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/batismo/batismo_page.dart';

class BatismoModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(BatismoController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => BatismoPage());
  }
}
