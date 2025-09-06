import 'package:paroquia_sao_lourenco/app/modules/liturgia/liturgia_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/liturgia/liturgia_page.dart';

class LiturgiaModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(LiturgiaController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => LiturgiaPage());
  }
}
