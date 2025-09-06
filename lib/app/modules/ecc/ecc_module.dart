import 'package:paroquia_sao_lourenco/app/modules/ecc/ecc_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/ecc/ecc_page.dart';

class EccModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(EccController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => EccPage());
  }
}
