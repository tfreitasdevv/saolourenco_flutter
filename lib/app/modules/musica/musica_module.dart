import 'package:paroquia_sao_lourenco/app/modules/musica/pages/membros_musica/membros_musica_controller.dart';
import 'package:paroquia_sao_lourenco/app/modules/musica/musica_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/musica/musica_page.dart';
import 'package:paroquia_sao_lourenco/app/modules/musica/pages/membros_musica/membros_musica_page.dart';

// class MusicaModule extends ChildModule {
//   @override
//   List<Bind> get binds => [
//         Bind((i) => MembrosMusicaController()),
//         Bind((i) => MusicaController()),
//       ];

//   @override
//   List<Router> get routers => [
//         Router('/', child: (_, args) => MusicaPage()),
//         Router('/membros_musica', child: (_, args) => MembrosMusicaPage()),
//       ];

//   static Inject get to => Inject<MusicaModule>.of();
// }

class MusicaModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(MusicaController());
    i.addInstance(MembrosMusicaController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => MusicaPage());
    r.child('/membros_musica', child: (context) => MembrosMusicaPage());
  }
}

