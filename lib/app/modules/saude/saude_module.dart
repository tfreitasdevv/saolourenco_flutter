import 'package:paroquia_sao_lourenco/app/modules/saude/saude_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/saude/saude_page.dart';

class SaudeModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(SaudeController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => SaudePage());
  }
}
