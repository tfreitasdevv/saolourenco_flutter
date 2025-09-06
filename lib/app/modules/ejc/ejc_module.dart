import 'package:paroquia_sao_lourenco/app/modules/ejc/ejc_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/ejc/ejc_page.dart';

class EjcModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(EjcController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => EjcPage());
  }
}
