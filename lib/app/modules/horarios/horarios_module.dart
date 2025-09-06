import 'package:paroquia_sao_lourenco/app/modules/horarios/horarios_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/horarios/horarios_page.dart';

class HorariosModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(HorariosController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => HorariosPage());
  }
}
