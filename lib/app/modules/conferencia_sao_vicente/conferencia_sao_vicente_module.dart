import 'package:paroquia_sao_lourenco/app/modules/conferencia_sao_vicente/conferencia_sao_vicente_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/conferencia_sao_vicente/conferencia_sao_vicente_page.dart';

class ConferenciaSaoVicenteModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(ConferenciaSaoVicenteController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => ConferenciaSaoVicentePage());
  }
}
