import 'package:paroquia_sao_lourenco/app/modules/avisos/avisos_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/avisos/avisos_page.dart';

class AvisosModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(AvisosController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => AvisosPage());
  }
}