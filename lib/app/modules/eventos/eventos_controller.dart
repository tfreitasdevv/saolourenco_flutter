import 'package:mobx/mobx.dart';
import 'dart:async';
import 'models/evento_model.dart';
import 'repositories/eventos_repository.dart';

part 'eventos_controller.g.dart';

class EventosController = _EventosBase with _$EventosController;

abstract class _EventosBase with Store {
  final EventosRepository _repository = EventosRepository();
  StreamSubscription? _eventosSubscription;
  StreamSubscription? _proximosEventosSubscription;

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
  TipoVisualizacao visualizacao = TipoVisualizacao.todos;

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
  void carregarEventos() {
    try {
      carregandoEventos = true;
      erroEventos = null;

      Stream<List<EventoModel>> stream;
      
      switch (visualizacao) {
        case TipoVisualizacao.futuros:
          stream = _repository.obterEventosFuturos();
          break;
        case TipoVisualizacao.passados:
          stream = _repository.obterEventosPassados();
          break;
        case TipoVisualizacao.mesAtual:
          stream = _repository.obterEventosDoMesAtual();
          break;
        case TipoVisualizacao.todos:
        default:
          stream = _repository.obterEventos();
          break;
      }

      _eventosSubscription?.cancel();
      _eventosSubscription = stream.listen(
        (listaEventos) {
          eventos = listaEventos;
          carregandoEventos = false;
        },
        onError: (erro) {
          erroEventos = 'Erro ao carregar eventos: $erro';
          carregandoEventos = false;
        },
      );
    } catch (e) {
      erroEventos = 'Erro inesperado ao carregar eventos: $e';
      carregandoEventos = false;
    }
  }

  @action
  void carregarProximosEventos() {
    try {
      carregandoProximosEventos = true;

      _proximosEventosSubscription?.cancel();
      _proximosEventosSubscription = _repository.obterProximosEventos(dias: 30).listen(
        (listaEventos) {
          proximosEventos = listaEventos;
          carregandoProximosEventos = false;
        },
        onError: (erro) {
          carregandoProximosEventos = false;
        },
      );
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
  void buscarPorTitulo(String titulo) {
    filtroTitulo = titulo;
    
    if (titulo.isEmpty) {
      carregarEventos();
      return;
    }

    try {
      carregandoEventos = true;
      erroEventos = null;

      _eventosSubscription?.cancel();
      _eventosSubscription = _repository.buscarEventosPorTitulo(titulo).listen(
        (listaEventos) {
          eventos = listaEventos;
          carregandoEventos = false;
        },
        onError: (erro) {
          erroEventos = 'Erro ao buscar eventos: $erro';
          carregandoEventos = false;
        },
      );
    } catch (e) {
      erroEventos = 'Erro inesperado ao buscar eventos: $e';
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

  void dispose() {
    _eventosSubscription?.cancel();
    _proximosEventosSubscription?.cancel();
  }
}

enum TipoVisualizacao {
  todos,
  futuros,
  passados,
  mesAtual,
}
