import 'package:flutter/material.dart';
import '../eventos_controller.dart';

/// Widget para filtros e busca de eventos
class EventosFiltros extends StatefulWidget {
  final EventosController controller;

  const EventosFiltros({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<EventosFiltros> createState() => _EventosFiltrosState();
}

class _EventosFiltrosState extends State<EventosFiltros> {
  final TextEditingController _buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _buscaController.text = widget.controller.filtroTitulo;
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Campo de busca
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _buscaController,
            decoration: InputDecoration(
              hintText: 'Buscar eventos...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _buscaController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _buscaController.clear();
                        widget.controller.buscarPorTitulo('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            onChanged: (value) {
              widget.controller.buscarPorTitulo(value);
            },
          ),
        ),
        
        // Filtros de visualização
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFiltroChip(
                'Todos',
                TipoVisualizacao.todos,
                Icons.event,
              ),
              const SizedBox(width: 8),
              _buildFiltroChip(
                'Próximos',
                TipoVisualizacao.futuros,
                Icons.upcoming,
              ),
              const SizedBox(width: 8),
              _buildFiltroChip(
                'Passados',
                TipoVisualizacao.passados,
                Icons.history,
              ),
              const SizedBox(width: 8),
              _buildFiltroChip(
                'Este mês',
                TipoVisualizacao.mesAtual,
                Icons.calendar_month,
              ),
            ],
          ),
        ),
        
        // Indicador de filtros ativos
        if (widget.controller.temFiltroAtivo)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.filter_alt,
                  size: 16,
                  color: Colors.blue[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'Filtros ativos',
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    _buscaController.clear();
                    widget.controller.limparFiltros();
                  },
                  child: const Text(
                    'Limpar',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildFiltroChip(String label, TipoVisualizacao tipo, IconData icone) {
    final isSelected = widget.controller.visualizacao == tipo;
    
    return FilterChip(
      avatar: Icon(
        icone,
        size: 16,
        color: isSelected ? Colors.white : Colors.grey[600],
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          widget.controller.alterarVisualizacao(tipo);
        }
      },
      selectedColor: Colors.blue,
      backgroundColor: Colors.grey[100],
      showCheckmark: false,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

/// Widget para exibir estatísticas dos eventos
class EventosEstatisticas extends StatelessWidget {
  final EventosController controller;

  const EventosEstatisticas({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildEstatistica(
              'Total de Eventos',
              controller.totalEventos.toString(),
              Icons.event,
              Colors.blue,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.blue[200],
          ),
          Expanded(
            child: _buildEstatistica(
              'Próximos Eventos',
              controller.totalEventosFuturos.toString(),
              Icons.upcoming,
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstatistica(String titulo, String valor, IconData icone, Color cor) {
    return Column(
      children: [
        Icon(
          icone,
          color: cor,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          valor,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: cor,
          ),
        ),
        Text(
          titulo,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
