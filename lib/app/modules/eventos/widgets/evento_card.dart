import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/evento_model.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/utils/url_launcher_utils.dart';

/// Widget para exibir um evento individual
class EventoCard extends StatelessWidget {
  final EventoModel evento;
  final VoidCallback? onTap;
  final bool mostrarDataCompleta;

  const EventoCard({
    Key? key,
    required this.evento,
    this.onTap,
    this.mostrarDataCompleta = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do evento (se houver)
            if (evento.temImagem) _buildImagemEvento(),
            
            // Conteúdo principal
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Data e status do evento
                  _buildDataEvento(),
                  
                  const SizedBox(height: 8),
                  
                  // Título do evento
                  _buildTituloEvento(),
                  
                  // Descrição (se houver)
                  if (evento.temDescricao) ...[
                    const SizedBox(height: 12),
                    _buildDescricaoEvento(),
                  ],
                  
                  // Link (se houver)
                  if (evento.temLink) ...[
                    const SizedBox(height: 12),
                    _buildLinkEvento(context),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagemEvento() {
    // Widget base da imagem
    final imagemWidget = CachedNetworkImage(
      imageUrl: evento.imagem!,
      height: 300,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        height: 300,
        color: Colors.grey[300],
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: 300,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(
            Icons.error,
            color: Colors.grey,
            size: 40,
          ),
        ),
      ),
    );

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: evento.jaPassou
          ? ColorFiltered(
              colorFilter: const ColorFilter.matrix(<double>[
                0.2126, 0.7152, 0.0722, 0, 0, // Red channel
                0.2126, 0.7152, 0.0722, 0, 0, // Green channel  
                0.2126, 0.7152, 0.0722, 0, 0, // Blue channel
                0,      0,      0,      1, 0, // Alpha channel
              ]),
              child: imagemWidget,
            )
          : imagemWidget,
    );
  }

  Widget _buildDataEvento() {
    // Usar formatação manual para evitar problemas de localização
    final data = evento.data;
    String dataFormatada;
    
    if (mostrarDataCompleta) {
      dataFormatada = '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} às ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
    } else {
      dataFormatada = '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
    }
    
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

  Widget _buildTituloEvento() {
    return MarkdownBody(
      data: evento.titulo,
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

  Widget _buildDescricaoEvento() {
    return MarkdownBody(
      data: evento.descricao!,
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

  Widget _buildLinkEvento(BuildContext context) {
    return InkWell(
      onTap: () => _abrirLink(context),
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

  void _abrirLink(BuildContext context) async {
    if (evento.link == null) return;
    
    await UrlLauncherUtils.abrirUrl(evento.link!, context: context);
  }
}

/// Widget para exibir um evento em formato compacto (para listas)
class EventoCardCompacto extends StatelessWidget {
  final EventoModel evento;
  final VoidCallback? onTap;

  const EventoCardCompacto({
    Key? key,
    required this.evento,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      child: ListTile(
        leading: evento.temImagem
            ? _buildAvatarComImagem()
            : CircleAvatar(
                backgroundColor: evento.eHoje 
                    ? Colors.orange 
                    : evento.eProximo 
                        ? Colors.blue 
                        : evento.jaPassou 
                            ? Colors.grey 
                            : Colors.green,
                child: Icon(
                  evento.eHoje 
                      ? Icons.today 
                      : evento.eProximo 
                          ? Icons.upcoming 
                          : evento.jaPassou 
                              ? Icons.history 
                              : Icons.event,
                  color: Colors.white,
                  size: 20,
                ),
              ),
        title: Text(
          evento.titulo,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${evento.data.day.toString().padLeft(2, '0')}/${evento.data.month.toString().padLeft(2, '0')}/${evento.data.year} ${evento.data.hour.toString().padLeft(2, '0')}:${evento.data.minute.toString().padLeft(2, '0')}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (evento.temImagem)
              Icon(Icons.image, color: Colors.grey[600], size: 16),
            if (evento.temLink) ...[
              const SizedBox(width: 4),
              Icon(Icons.link, color: Colors.grey[600], size: 16),
            ],
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: Colors.grey[600]),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  /// Constrói um avatar circular com a imagem do evento
  Widget _buildAvatarComImagem() {
    // Widget base da imagem
    final imagemWidget = CachedNetworkImage(
      imageUrl: evento.imagem!,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey[300],
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(
            Icons.error,
            color: Colors.grey,
            size: 20,
          ),
        ),
      ),
    );

    return CircleAvatar(
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: evento.jaPassou
            ? ColorFiltered(
                colorFilter: const ColorFilter.matrix(<double>[
                  0.2126, 0.7152, 0.0722, 0, 0, // Red channel
                  0.2126, 0.7152, 0.0722, 0, 0, // Green channel  
                  0.2126, 0.7152, 0.0722, 0, 0, // Blue channel
                  0,      0,      0,      1, 0, // Alpha channel
                ]),
                child: imagemWidget,
              )
            : imagemWidget,
      ),
    );
  }
}
