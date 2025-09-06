import 'package:paroquia_sao_lourenco/app/modules/crisma/crisma_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/crisma/crisma_page.dart';

class CrismaModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(CrismaController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => CrismaPage());
  }
}
