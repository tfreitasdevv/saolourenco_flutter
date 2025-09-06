import 'package:paroquia_sao_lourenco/app/modules/mae_tres_vezes/mae_tres_vezes_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/mae_tres_vezes/mae_tres_vezes_page.dart';

class MaeTresVezesModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(MaeTresVezesController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => MaeTresVezesPage());
  }
}
