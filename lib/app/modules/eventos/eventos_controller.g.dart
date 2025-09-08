// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eventos_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EventosController on _EventosBase, Store {
  Computed<List<EventoModel>>? _$eventosFiltradosComputed;

  @override
  List<EventoModel> get eventosFiltrados => (_$eventosFiltradosComputed ??=
          Computed<List<EventoModel>>(() => super.eventosFiltrados,
              name: '_EventosBase.eventosFiltrados'))
      .value;
  Computed<bool>? _$temEventosComputed;

  @override
  bool get temEventos =>
      (_$temEventosComputed ??= Computed<bool>(() => super.temEventos,
              name: '_EventosBase.temEventos'))
          .value;
  Computed<bool>? _$temProximosEventosComputed;

  @override
  bool get temProximosEventos => (_$temProximosEventosComputed ??=
          Computed<bool>(() => super.temProximosEventos,
              name: '_EventosBase.temProximosEventos'))
      .value;
  Computed<bool>? _$temFiltroAtivoComputed;

  @override
  bool get temFiltroAtivo =>
      (_$temFiltroAtivoComputed ??= Computed<bool>(() => super.temFiltroAtivo,
              name: '_EventosBase.temFiltroAtivo'))
          .value;

  late final _$eventosAtom =
      Atom(name: '_EventosBase.eventos', context: context);

  @override
  List<EventoModel> get eventos {
    _$eventosAtom.reportRead();
    return super.eventos;
  }

  @override
  set eventos(List<EventoModel> value) {
    _$eventosAtom.reportWrite(value, super.eventos, () {
      super.eventos = value;
    });
  }

  late final _$proximosEventosAtom =
      Atom(name: '_EventosBase.proximosEventos', context: context);

  @override
  List<EventoModel> get proximosEventos {
    _$proximosEventosAtom.reportRead();
    return super.proximosEventos;
  }

  @override
  set proximosEventos(List<EventoModel> value) {
    _$proximosEventosAtom.reportWrite(value, super.proximosEventos, () {
      super.proximosEventos = value;
    });
  }

  late final _$eventosPassadosAtom =
      Atom(name: '_EventosBase.eventosPassados', context: context);

  @override
  List<EventoModel> get eventosPassados {
    _$eventosPassadosAtom.reportRead();
    return super.eventosPassados;
  }

  @override
  set eventosPassados(List<EventoModel> value) {
    _$eventosPassadosAtom.reportWrite(value, super.eventosPassados, () {
      super.eventosPassados = value;
    });
  }

  late final _$carregandoEventosAtom =
      Atom(name: '_EventosBase.carregandoEventos', context: context);

  @override
  bool get carregandoEventos {
    _$carregandoEventosAtom.reportRead();
    return super.carregandoEventos;
  }

  @override
  set carregandoEventos(bool value) {
    _$carregandoEventosAtom.reportWrite(value, super.carregandoEventos, () {
      super.carregandoEventos = value;
    });
  }

  late final _$carregandoProximosEventosAtom =
      Atom(name: '_EventosBase.carregandoProximosEventos', context: context);

  @override
  bool get carregandoProximosEventos {
    _$carregandoProximosEventosAtom.reportRead();
    return super.carregandoProximosEventos;
  }

  @override
  set carregandoProximosEventos(bool value) {
    _$carregandoProximosEventosAtom
        .reportWrite(value, super.carregandoProximosEventos, () {
      super.carregandoProximosEventos = value;
    });
  }

  late final _$erroEventosAtom =
      Atom(name: '_EventosBase.erroEventos', context: context);

  @override
  String? get erroEventos {
    _$erroEventosAtom.reportRead();
    return super.erroEventos;
  }

  @override
  set erroEventos(String? value) {
    _$erroEventosAtom.reportWrite(value, super.erroEventos, () {
      super.erroEventos = value;
    });
  }

  late final _$filtroTituloAtom =
      Atom(name: '_EventosBase.filtroTitulo', context: context);

  @override
  String get filtroTitulo {
    _$filtroTituloAtom.reportRead();
    return super.filtroTitulo;
  }

  @override
  set filtroTitulo(String value) {
    _$filtroTituloAtom.reportWrite(value, super.filtroTitulo, () {
      super.filtroTitulo = value;
    });
  }

  late final _$visualizacaoAtom =
      Atom(name: '_EventosBase.visualizacao', context: context);

  @override
  TipoVisualizacao get visualizacao {
    _$visualizacaoAtom.reportRead();
    return super.visualizacao;
  }

  @override
  set visualizacao(TipoVisualizacao value) {
    _$visualizacaoAtom.reportWrite(value, super.visualizacao, () {
      super.visualizacao = value;
    });
  }

  late final _$totalEventosAtom =
      Atom(name: '_EventosBase.totalEventos', context: context);

  @override
  int get totalEventos {
    _$totalEventosAtom.reportRead();
    return super.totalEventos;
  }

  @override
  set totalEventos(int value) {
    _$totalEventosAtom.reportWrite(value, super.totalEventos, () {
      super.totalEventos = value;
    });
  }

  late final _$totalEventosFuturosAtom =
      Atom(name: '_EventosBase.totalEventosFuturos', context: context);

  @override
  int get totalEventosFuturos {
    _$totalEventosFuturosAtom.reportRead();
    return super.totalEventosFuturos;
  }

  @override
  set totalEventosFuturos(int value) {
    _$totalEventosFuturosAtom.reportWrite(value, super.totalEventosFuturos, () {
      super.totalEventosFuturos = value;
    });
  }

  late final _$obterEstatisticasAsyncAction =
      AsyncAction('_EventosBase.obterEstatisticas', context: context);

  @override
  Future<void> obterEstatisticas() {
    return _$obterEstatisticasAsyncAction.run(() => super.obterEstatisticas());
  }

  late final _$obterEventoPorIdAsyncAction =
      AsyncAction('_EventosBase.obterEventoPorId', context: context);

  @override
  Future<EventoModel?> obterEventoPorId(String id) {
    return _$obterEventoPorIdAsyncAction.run(() => super.obterEventoPorId(id));
  }

  late final _$_EventosBaseActionController =
      ActionController(name: '_EventosBase', context: context);

  @override
  void inicializar() {
    final _$actionInfo = _$_EventosBaseActionController.startAction(
        name: '_EventosBase.inicializar');
    try {
      return super.inicializar();
    } finally {
      _$_EventosBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void carregarEventos() {
    final _$actionInfo = _$_EventosBaseActionController.startAction(
        name: '_EventosBase.carregarEventos');
    try {
      return super.carregarEventos();
    } finally {
      _$_EventosBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void carregarProximosEventos() {
    final _$actionInfo = _$_EventosBaseActionController.startAction(
        name: '_EventosBase.carregarProximosEventos');
    try {
      return super.carregarProximosEventos();
    } finally {
      _$_EventosBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarVisualizacao(TipoVisualizacao novaVisualizacao) {
    final _$actionInfo = _$_EventosBaseActionController.startAction(
        name: '_EventosBase.alterarVisualizacao');
    try {
      return super.alterarVisualizacao(novaVisualizacao);
    } finally {
      _$_EventosBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void buscarPorTitulo(String titulo) {
    final _$actionInfo = _$_EventosBaseActionController.startAction(
        name: '_EventosBase.buscarPorTitulo');
    try {
      return super.buscarPorTitulo(titulo);
    } finally {
      _$_EventosBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparFiltros() {
    final _$actionInfo = _$_EventosBaseActionController.startAction(
        name: '_EventosBase.limparFiltros');
    try {
      return super.limparFiltros();
    } finally {
      _$_EventosBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
eventos: ${eventos},
proximosEventos: ${proximosEventos},
eventosPassados: ${eventosPassados},
carregandoEventos: ${carregandoEventos},
carregandoProximosEventos: ${carregandoProximosEventos},
erroEventos: ${erroEventos},
filtroTitulo: ${filtroTitulo},
visualizacao: ${visualizacao},
totalEventos: ${totalEventos},
totalEventosFuturos: ${totalEventosFuturos},
eventosFiltrados: ${eventosFiltrados},
temEventos: ${temEventos},
temProximosEventos: ${temProximosEventos},
temFiltroAtivo: ${temFiltroAtivo}
    ''';
  }
}
