import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../eventos_controller.dart';

/// Widget responsável por exibir os filtros de eventos
class EventosFiltros extends StatelessWidget {
  final EventosController controller;

  const EventosFiltros({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Observer(
      builder: (_) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChip(
                label: const Text('Próximos'),
                selected: controller.visualizacao == TipoVisualizacao.futuros,
                onSelected: (_) => controller.alterarVisualizacao(TipoVisualizacao.futuros),
                selectedColor: colorScheme.primaryContainer,
                backgroundColor: colorScheme.surfaceContainerHighest,
                labelStyle: TextStyle(
                  color: controller.visualizacao == TipoVisualizacao.futuros
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                  fontWeight: controller.visualizacao == TipoVisualizacao.futuros
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
                side: BorderSide(
                  color: controller.visualizacao == TipoVisualizacao.futuros
                      ? colorScheme.primary
                      : colorScheme.outline,
                ),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Passados'),
                selected: controller.visualizacao == TipoVisualizacao.passados,
                onSelected: (_) => controller.alterarVisualizacao(TipoVisualizacao.passados),
                selectedColor: colorScheme.primaryContainer,
                backgroundColor: colorScheme.surfaceContainerHighest,
                labelStyle: TextStyle(
                  color: controller.visualizacao == TipoVisualizacao.passados
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                  fontWeight: controller.visualizacao == TipoVisualizacao.passados
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
                side: BorderSide(
                  color: controller.visualizacao == TipoVisualizacao.passados
                      ? colorScheme.primary
                      : colorScheme.outline,
                ),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Todos'),
                selected: controller.visualizacao == TipoVisualizacao.todos,
                onSelected: (_) => controller.alterarVisualizacao(TipoVisualizacao.todos),
                selectedColor: colorScheme.primaryContainer,
                backgroundColor: colorScheme.surfaceContainerHighest,
                labelStyle: TextStyle(
                  color: controller.visualizacao == TipoVisualizacao.todos
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                  fontWeight: controller.visualizacao == TipoVisualizacao.todos
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
                side: BorderSide(
                  color: controller.visualizacao == TipoVisualizacao.todos
                      ? colorScheme.primary
                      : colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
