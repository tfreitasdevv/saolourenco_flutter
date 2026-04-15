import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/shared/config/api_config.dart';
import 'package:paroquia_sao_lourenco/app/shared/services/strapi_client.dart';

part 'confissoes_controller.g.dart';

class ConfissoesController = _ConfissoesBase with _$ConfissoesController;

abstract class _ConfissoesBase with Store {
  @observable
  String textoConfissoes = '';

  @observable
  bool isLoading = true;

  @action
  Future<void> carregarTextoConfissoes() async {
    isLoading = true;
    try {
      final strapi = Modular.get<StrapiClient>();
      final response = await strapi.get(ApiConfig.confissoes,
          queryParameters: {
            'filters[secao][\$eq]': 'texto_confissoes',
          });
      final lista = List<Map<String, dynamic>>.from(response.data['data'] ?? []);
      if (lista.isNotEmpty) {
        textoConfissoes = lista.first['texto'] ?? '';
      } else {
        textoConfissoes = 'Texto não encontrado.';
      }
    } catch (e) {
      textoConfissoes = 'Erro ao carregar o texto: $e';
    }
    isLoading = false;
  }
}
