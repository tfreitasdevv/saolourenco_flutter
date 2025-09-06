import 'package:paroquia_sao_lourenco/app/modules/acolitos/acolitos_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/alfabetizacao/alfabetizacao_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/avisos/avisos_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/batismo/batismo_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/capelas/capelas_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/catequese/catequese_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/conferencia_sao_vicente/conferencia_sao_vicente_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/confissoes/confissoes_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/cor/cor_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/coroinhas/coroinhas_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/crisma/crisma_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/dizimo/dizimo_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/ecc/ecc_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/ejc/ejc_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/eventos/eventos_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/familiar/familiar_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/grupo_de_oracao/grupo_de_oracao_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/home/home_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/home/home_page.dart';
import 'package:paroquia_sao_lourenco/app/modules/horarios/horarios_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/liturgia/liturgia_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/mae_tres_vezes/mae_tres_vezes_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/mej/mej_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/musica/musica_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/nascituro/nascituro_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/pascom/pascom_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/pastorais/pastorais_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/promocao_humana/promocao_humana_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/rua/rua_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/saude/saude_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/sobre/sobre_module.dart';

class HomeModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(HomeController());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => HomePage());
    r.module('/avisos', module: AvisosModule());
    r.module('/horarios', module: HorariosModule());
    r.module('/capelas', module: CapelasModule());
    r.module('/pastorais', module: PastoraisModule());
    r.module('/sobre', module: SobreModule());
    r.module('/confissoes', module: ConfissoesModule());
    r.module('/musica', module: MusicaModule());
    r.module('/liturgia', module: LiturgiaModule());
    r.module('/batismo', module: BatismoModule());
    r.module('/grupo_de_oracao', module: GrupoDeOracaoModule());
    r.module('/catequese', module: CatequeseModule());
    r.module('/crisma', module: CrismaModule());
    r.module('/cor', module: CorModule());
    r.module('/pascom', module: PascomModule());
    r.module('/mej', module: MejModule());
    r.module('/acolitos', module: AcolitosModule());
    r.module('/alfabetizacao', module: AlfabetizacaoModule());
    r.module('/mae_tres_vezes', module: MaeTresVezesModule());
    r.module('/dizimo', module: DizimoModule());
    r.module('/ecc', module: EccModule());
    r.module('/coroinhas', module: CoroinhasModule());
    r.module('/ejc', module: EjcModule());
    r.module('/eventos', module: EventosModule());
    r.module('/nascituro', module: NascituroModule());
    r.module('/saude', module: SaudeModule());
    r.module('/rua', module: RuaModule());
    r.module('/conferencia_sao_vicente', module: ConferenciaSaoVicenteModule());
    r.module('/familiar', module: FamiliarModule());
    r.module('/promocao_humana', module: PromocaoHumanaModule());
  }
}