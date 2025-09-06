import 'package:paroquia_sao_lourenco/app/modules/coroinhas/coroinhas_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/coroinhas/coroinhas_page.dart';

class CoroinhasModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(CoroinhasController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => CoroinhasPage());
  }
}
