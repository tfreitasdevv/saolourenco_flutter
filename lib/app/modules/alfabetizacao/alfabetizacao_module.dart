import 'package:paroquia_sao_lourenco/app/modules/alfabetizacao/alfabetizacao_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/alfabetizacao/alfabetizacao_page.dart';

class AlfabetizacaoModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(AlfabetizacaoController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => AlfabetizacaoPage());
  }
}
