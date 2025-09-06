import 'package:paroquia_sao_lourenco/app/modules/pastorais/pastorais_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/pastorais/pastorais_page.dart';

class PastoraisModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(PastoraisController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => PastoraisPage());
  }
}
