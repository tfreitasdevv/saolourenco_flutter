import 'package:paroquia_sao_lourenco/app/modules/sobre/sobre_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/sobre/sobre_page.dart';

class SobreModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(SobreController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => SobrePage());
  }
}
