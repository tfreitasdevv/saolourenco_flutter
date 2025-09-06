import 'package:paroquia_sao_lourenco/app/modules/dizimo/dizimo_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/dizimo/dizimo_page.dart';

class DizimoModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(DizimoController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => DizimoPage());
  }
}
