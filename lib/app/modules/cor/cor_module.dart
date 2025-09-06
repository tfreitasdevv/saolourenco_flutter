import 'package:paroquia_sao_lourenco/app/modules/cor/cor_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/cor/cor_page.dart';

class CorModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(CorController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => CorPage());
  }
}
