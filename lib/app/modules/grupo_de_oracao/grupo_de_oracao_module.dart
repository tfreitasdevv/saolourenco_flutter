import 'package:paroquia_sao_lourenco/app/modules/grupo_de_oracao/grupo_de_oracao_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/grupo_de_oracao/grupo_de_oracao_page.dart';

class GrupoDeOracaoModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(GrupoDeOracaoController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => GrupoDeOracaoPage());
  }
}
