import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';
import 'package:paroquia_sao_lourenco/app/shared/utils/url_launcher_utils.dart';
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
              // Observer(
              //   builder: (_) => EventosEstatisticas(controller: controller),
              // ),
              
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
        builder: (context, scrollController) => SafeArea(
          bottom: true,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: SingleChildScrollView(
              controller: scrollController,
              child: _buildEventoDetalhes(evento),
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
        builder: (context, scrollController) => SafeArea(
          bottom: true,
          child: Container(
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
      ),
    );
  }

  /// Widget customizado para exibir os detalhes do evento no bottom sheet
  Widget _buildEventoDetalhes(evento) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem do evento (se houver) - com altura máxima de 600px
          if (evento.temImagem) _buildImagemEventoBottomSheet(evento.imagem!),
          
          // Conteúdo principal
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Data e status do evento
                _buildDataEventoBottomSheet(evento),
                
                const SizedBox(height: 8),
                
                // Título do evento
                _buildTituloEventoBottomSheet(evento.titulo),
                
                // Descrição (se houver)
                if (evento.temDescricao) ...[
                  const SizedBox(height: 12),
                  _buildDescricaoEventoBottomSheet(evento.descricao!),
                ],
                
                // Link (se houver)
                if (evento.temLink) ...[
                  const SizedBox(height: 12),
                  _buildLinkEventoBottomSheet(evento),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Imagem do evento com altura máxima de 600px mantendo proporção
  Widget _buildImagemEventoBottomSheet(String imageUrl) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 600, // Altura máxima de 600px
        ),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: double.infinity,
          fit: BoxFit.contain, // Mantém a proporção original
          placeholder: (context, url) => Container(
            height: 200,
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: 200,
            color: Colors.grey[300],
            child: const Center(
              child: Icon(
                Icons.error,
                color: Colors.grey,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Data e status do evento para o bottom sheet
  Widget _buildDataEventoBottomSheet(evento) {
    final data = evento.data;
    String dataFormatada = '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} às ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
    
    Color corData;
    IconData iconeData;
    String statusTexto = '';

    if (evento.eHoje) {
      corData = Colors.orange;
      iconeData = Icons.today;
      statusTexto = 'HOJE';
    } else if (evento.eProximo) {
      corData = Colors.blue;
      iconeData = Icons.upcoming;
      statusTexto = 'PRÓXIMO';
    } else if (evento.jaPassou) {
      corData = Colors.grey;
      iconeData = Icons.history;
      statusTexto = 'PASSADO';
    } else {
      corData = Colors.green;
      iconeData = Icons.event;
      statusTexto = 'FUTURO';
    }

    return Row(
      children: [
        Icon(
          iconeData,
          size: 16,
          color: corData,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            dataFormatada,
            style: TextStyle(
              color: corData,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: corData.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            statusTexto,
            style: TextStyle(
              color: corData,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Título do evento para o bottom sheet
  Widget _buildTituloEventoBottomSheet(String titulo) {
    return MarkdownBody(
      data: titulo,
      styleSheet: MarkdownStyleSheet(
        p: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        strong: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        em: const TextStyle(
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  /// Descrição do evento para o bottom sheet
  Widget _buildDescricaoEventoBottomSheet(String descricao) {
    return MarkdownBody(
      data: descricao,
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
          height: 1.4,
        ),
        strong: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        em: const TextStyle(
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  /// Link do evento para o bottom sheet
  Widget _buildLinkEventoBottomSheet(evento) {
    return InkWell(
      onTap: () => _abrirLinkEvento(evento.link!),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: t2.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: t2, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.link,
              size: 16,
              color: t2,
            ),
            const SizedBox(width: 8),
            Text(
              'Ver mais informações',
              style: TextStyle(
                color: t2,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.open_in_new,
              size: 14,
              color: t2,
            ),
          ],
        ),
      ),
    );
  }

  /// Abrir link do evento
  void _abrirLinkEvento(String link) async {
    await UrlLauncherUtils.abrirUrl(link, context: context);
  }
}
