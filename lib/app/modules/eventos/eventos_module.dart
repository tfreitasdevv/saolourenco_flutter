import 'package:paroquia_sao_lourenco/app/modules/eventos/eventos_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/eventos/eventos_page.dart';

class EventosModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(EventosController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => EventosPage());
  }
}
