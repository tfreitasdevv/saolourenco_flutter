import 'package:paroquia_sao_lourenco/app/modules/eventos/eventos_controller.dart';
import 'package:paroquia_sao_lourenco/app/modules/eventos/repositories/eventos_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/eventos/eventos_page.dart';

class EventosModule extends Module {
  @override
  void binds(Injector i) {
    // Repository para operações com o Firestore
    i.addLazySingleton(EventosRepository.new);
    
    // Controller para gerenciar o estado dos eventos
    i.addSingleton(EventosController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => EventosPage());
  }
}
