import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';
import 'eventos_controller.dart';
import 'widgets/evento_card.dart';
import 'widgets/eventos_estados.dart';
import 'widgets/eventos_filtros.dart';

class EventosPage extends StatefulWidget {
  final String title;
  const EventosPage({Key? key, this.title = "Eventos"}) : super(key: key);

  @override
  _EventosPageState createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  final EventosController controller = Modular.get<EventosController>();

  @override
  void initState() {
    super.initState();
    controller.inicializar();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: t2,
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.carregarEventos(),
            tooltip: 'Atualizar eventos',
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Estatísticas dos eventos
              Observer(
                builder: (_) => EventosEstatisticas(controller: controller),
              ),
              
              // Filtros e busca
              EventosFiltros(controller: controller),
              
              // Lista de eventos
              Expanded(
                child: Observer(
                  builder: (_) {
                    if (controller.carregandoEventos) {
                      return const EventosCarregando(
                        mensagem: 'Carregando eventos...',
                      );
                    }

                    if (controller.erroEventos != null) {
                      return EventosVazios.erro(
                        onRecarregar: () => controller.carregarEventos(),
                      );
                    }

                    final eventos = controller.eventosFiltrados;

                    if (eventos.isEmpty) {
                      if (controller.temFiltroAtivo) {
                        return EventosVazios.busca(
                          onRecarregar: () => controller.limparFiltros(),
                        );
                      }

                      switch (controller.visualizacao) {
                        case TipoVisualizacao.futuros:
                          return EventosVazios.semEventosFuturos(
                            onRecarregar: () => controller.carregarEventos(),
                          );
                        case TipoVisualizacao.passados:
                          return EventosVazios.semEventosPassados(
                            onRecarregar: () => controller.carregarEventos(),
                          );
                        default:
                          return EventosVazios(
                            onRecarregar: () => controller.carregarEventos(),
                          );
                      }
                    }

                    return RefreshIndicator(
                      onRefresh: () async => controller.carregarEventos(),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: eventos.length,
                        itemBuilder: (context, index) {
                          final evento = eventos[index];
                          return EventoCard(
                            evento: evento,
                            onTap: () => _mostrarDetalhesEvento(evento),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Observer(
        builder: (_) => controller.temProximosEventos
            ? FloatingActionButton.extended(
                onPressed: () => _mostrarProximosEventos(),
                backgroundColor: t2,
                icon: const Icon(Icons.upcoming),
                label: const Text('Próximos'),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  void _mostrarDetalhesEvento(evento) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: SingleChildScrollView(
            controller: scrollController,
            child: EventoCard(
              evento: evento,
              mostrarDataCompleta: true,
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarProximosEventos() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              Row(
                children: [
                  Icon(Icons.upcoming, color: t2),
                  const SizedBox(width: 8),
                  Text(
                    'Próximos Eventos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: t2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Lista de próximos eventos
              Expanded(
                child: Observer(
                  builder: (_) {
                    if (controller.carregandoProximosEventos) {
                      return const EventosCarregando(
                        mensagem: 'Carregando próximos eventos...',
                      );
                    }

                    if (controller.proximosEventos.isEmpty) {
                      return const EventosVazios.semEventosFuturos();
                    }

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: controller.proximosEventos.length,
                      itemBuilder: (context, index) {
                        final evento = controller.proximosEventos[index];
                        return EventoCardCompacto(
                          evento: evento,
                          onTap: () {
                            Navigator.pop(context);
                            _mostrarDetalhesEvento(evento);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
