import 'package:paroquia_sao_lourenco/app/modules/catequese/catequese_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/catequese/catequese_page.dart';

class CatequeseModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(CatequeseController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => CatequesePage());
  }
}
