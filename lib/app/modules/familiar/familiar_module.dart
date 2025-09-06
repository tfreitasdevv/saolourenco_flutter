import 'package:paroquia_sao_lourenco/app/modules/familiar/familiar_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/familiar/familiar_page.dart';

class FamiliarModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(FamiliarController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => FamiliarPage());
  }
}
