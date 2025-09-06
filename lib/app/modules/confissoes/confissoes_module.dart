import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/confissoes/confissoes_page.dart';

class ConfissoesModule extends Module {
  @override
  void binds(Injector i) {
    // Não precisamos mais do controller
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => ConfissoesPage());
  }
}
