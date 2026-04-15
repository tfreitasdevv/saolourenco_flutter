import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/shared/config/api_config.dart';
import 'package:paroquia_sao_lourenco/app/shared/services/strapi_client.dart';
import '../models/evento_model.dart';

/// Repository responsável por gerenciar as operações de dados dos eventos
/// via API Strapi
class EventosRepository {
  StrapiClient get _client => Modular.get<StrapiClient>();

  List<EventoModel> _parseEventos(dynamic responseData) {
    final List data = responseData['data'] ?? [];
    return data
        .map((json) => EventoModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Obtém todos os eventos ordenados por data
  Future<List<EventoModel>> obterEventos() async {
    final response = await _client.get(
      ApiConfig.eventos,
      queryParameters: {
        'sort': 'data:asc',
        'populate': 'imagem',
        'pagination[pageSize]': '100',
      },
    );
    return _parseEventos(response.data);
  }

  /// Obtém apenas os eventos futuros ordenados por data
  Future<List<EventoModel>> obterEventosFuturos() async {
    final agora = DateTime.now().toIso8601String();
    final response = await _client.get(
      ApiConfig.eventos,
      queryParameters: {
        'filters[data][\$gte]': agora,
        'sort': 'data:asc',
        'populate': 'imagem',
        'pagination[pageSize]': '100',
      },
    );
    return _parseEventos(response.data);
  }

  /// Obtém apenas os eventos passados ordenados por data (mais recentes primeiro)
  Future<List<EventoModel>> obterEventosPassados() async {
    final agora = DateTime.now().toIso8601String();
    final response = await _client.get(
      ApiConfig.eventos,
      queryParameters: {
        'filters[data][\$lt]': agora,
        'sort': 'data:desc',
        'populate': 'imagem',
        'pagination[pageSize]': '100',
      },
    );
    return _parseEventos(response.data);
  }

  /// Obtém os próximos eventos (nos próximos N dias)
  Future<List<EventoModel>> obterProximosEventos({int dias = 30}) async {
    final agora = DateTime.now();
    final limite = agora.add(Duration(days: dias));
    final response = await _client.get(
      ApiConfig.eventos,
      queryParameters: {
        'filters[data][\$gte]': agora.toIso8601String(),
        'filters[data][\$lte]': limite.toIso8601String(),
        'sort': 'data:asc',
        'populate': 'imagem',
        'pagination[pageSize]': '100',
      },
    );
    return _parseEventos(response.data);
  }

  /// Obtém um evento específico pelo documentId
  Future<EventoModel?> obterEventoPorId(String documentId) async {
    final response = await _client.get(
      '${ApiConfig.eventos}/$documentId',
      queryParameters: {'populate': 'imagem'},
    );
    final data = response.data['data'];
    if (data == null) return null;
    return EventoModel.fromJson(data as Map<String, dynamic>);
  }

  /// Busca eventos por título
  Future<List<EventoModel>> buscarEventosPorTitulo(String titulo) async {
    final response = await _client.get(
      ApiConfig.eventos,
      queryParameters: {
        'filters[titulo][\$containsi]': titulo,
        'sort': 'data:asc',
        'populate': 'imagem',
        'pagination[pageSize]': '100',
      },
    );
    return _parseEventos(response.data);
  }

  /// Obtém eventos em um intervalo de datas específico
  Future<List<EventoModel>> obterEventosPorPeriodo({
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    final response = await _client.get(
      ApiConfig.eventos,
      queryParameters: {
        'filters[data][\$gte]': dataInicio.toIso8601String(),
        'filters[data][\$lte]': dataFim.toIso8601String(),
        'sort': 'data:asc',
        'populate': 'imagem',
        'pagination[pageSize]': '100',
      },
    );
    return _parseEventos(response.data);
  }

  /// Obtém os eventos do mês atual
  Future<List<EventoModel>> obterEventosDoMesAtual() {
    final agora = DateTime.now();
    final inicioMes = DateTime(agora.year, agora.month, 1);
    final fimMes = DateTime(agora.year, agora.month + 1, 0, 23, 59, 59);
    return obterEventosPorPeriodo(dataInicio: inicioMes, dataFim: fimMes);
  }

  /// Obtém a contagem total de eventos (usando pagination meta)
  Future<int> obterTotalEventos() async {
    final response = await _client.get(
      ApiConfig.eventos,
      queryParameters: {'pagination[pageSize]': '1'},
    );
    return response.data['meta']?['pagination']?['total'] ?? 0;
  }

  /// Obtém a contagem de eventos futuros
  Future<int> obterTotalEventosFuturos() async {
    final agora = DateTime.now().toIso8601String();
    final response = await _client.get(
      ApiConfig.eventos,
      queryParameters: {
        'filters[data][\$gte]': agora,
        'pagination[pageSize]': '1',
      },
    );
    return response.data['meta']?['pagination']?['total'] ?? 0;
  }
}
