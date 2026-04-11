import 'package:paroquia_sao_lourenco/app/modules/eac/eac_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/eac/eac_page.dart';

class EacModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(EacController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => EacPage());
  }
}
