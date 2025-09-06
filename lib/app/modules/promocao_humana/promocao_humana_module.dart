import 'package:paroquia_sao_lourenco/app/modules/promocao_humana/promocao_humana_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/promocao_humana/promocao_humana_page.dart';

class PromocaoHumanaModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(PromocaoHumanaController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => PromocaoHumanaPage());
  }
}
