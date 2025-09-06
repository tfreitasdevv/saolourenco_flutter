import 'package:paroquia_sao_lourenco/app/modules/nascituro/nascituro_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/nascituro/nascituro_page.dart';

class NascituroModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(NascituroController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => NascituroPage());
  }
}
