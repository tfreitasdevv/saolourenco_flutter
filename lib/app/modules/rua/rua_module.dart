import 'package:paroquia_sao_lourenco/app/modules/rua/rua_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/rua/rua_page.dart';

class RuaModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(RuaController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => RuaPage());
  }
}
