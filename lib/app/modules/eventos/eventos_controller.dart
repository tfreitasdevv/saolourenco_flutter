import 'package:mobx/mobx.dart';
import 'models/evento_model.dart';
import 'repositories/eventos_repository.dart';

part 'eventos_controller.g.dart';

class EventosController = _EventosBase with _$EventosController;

abstract class _EventosBase with Store {
  final EventosRepository _repository = EventosRepository();

  @observable
  List<EventoModel> eventos = [];

  @observable
  List<EventoModel> proximosEventos = [];

  @observable
  List<EventoModel> eventosPassados = [];

  @observable
  bool carregandoEventos = false;

  @observable
  bool carregandoProximosEventos = false;

  @observable
  String? erroEventos;

  @observable
  String filtroTitulo = '';

  @observable
  TipoVisualizacao visualizacao = TipoVisualizacao.futuros;

  @observable
  int totalEventos = 0;

  @observable
  int totalEventosFuturos = 0;

  @action
  void inicializar() {
    carregarEventos();
    carregarProximosEventos();
    obterEstatisticas();
  }

  @action
  Future<void> carregarEventos() async {
    try {
      carregandoEventos = true;
      erroEventos = null;

      switch (visualizacao) {
        case TipoVisualizacao.futuros:
          eventos = await _repository.obterEventosFuturos();
          break;
        case TipoVisualizacao.passados:
          eventos = await _repository.obterEventosPassados();
          break;
        case TipoVisualizacao.mesAtual:
          eventos = await _repository.obterEventosDoMesAtual();
          break;
        case TipoVisualizacao.todos:
        default:
          eventos = await _repository.obterEventos();
          break;
      }

      carregandoEventos = false;
    } catch (e) {
      erroEventos = 'Erro ao carregar eventos: $e';
      carregandoEventos = false;
    }
  }

  @action
  Future<void> carregarProximosEventos() async {
    try {
      carregandoProximosEventos = true;
      proximosEventos = await _repository.obterProximosEventos(dias: 30);
      carregandoProximosEventos = false;
    } catch (e) {
      carregandoProximosEventos = false;
    }
  }

  @action
  Future<void> obterEstatisticas() async {
    try {
      totalEventos = await _repository.obterTotalEventos();
      totalEventosFuturos = await _repository.obterTotalEventosFuturos();
    } catch (e) {
      // Log do erro se necessário
    }
  }

  @action
  void alterarVisualizacao(TipoVisualizacao novaVisualizacao) {
    if (visualizacao != novaVisualizacao) {
      visualizacao = novaVisualizacao;
      carregarEventos();
    }
  }

  @action
  Future<void> buscarPorTitulo(String titulo) async {
    filtroTitulo = titulo;
    
    if (titulo.isEmpty) {
      carregarEventos();
      return;
    }

    try {
      carregandoEventos = true;
      erroEventos = null;
      eventos = await _repository.buscarEventosPorTitulo(titulo);
      carregandoEventos = false;
    } catch (e) {
      erroEventos = 'Erro ao buscar eventos: $e';
      carregandoEventos = false;
    }
  }

  @action
  Future<EventoModel?> obterEventoPorId(String id) async {
    try {
      return await _repository.obterEventoPorId(id);
    } catch (e) {
      erroEventos = 'Erro ao obter evento: $e';
      return null;
    }
  }

  @action
  void limparFiltros() {
    filtroTitulo = '';
    visualizacao = TipoVisualizacao.todos;
    carregarEventos();
  }

  @computed
  List<EventoModel> get eventosFiltrados {
    if (filtroTitulo.isEmpty) {
      return eventos;
    }

    return eventos.where((evento) {
      return evento.titulo.toLowerCase().contains(filtroTitulo.toLowerCase()) ||
          (evento.descricao?.toLowerCase().contains(filtroTitulo.toLowerCase()) ?? false);
    }).toList();
  }

  @computed
  bool get temEventos => eventos.isNotEmpty;

  @computed
  bool get temProximosEventos => proximosEventos.isNotEmpty;

  @computed
  bool get temFiltroAtivo => filtroTitulo.isNotEmpty || visualizacao != TipoVisualizacao.todos;
}

enum TipoVisualizacao {
  todos,
  futuros,
  passados,
  mesAtual,
}
