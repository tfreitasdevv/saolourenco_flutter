import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../eventos_controller.dart';

/// Widget responsável por exibir estatísticas dos eventos
class EventosEstatisticas extends StatelessWidget {
  final EventosController controller;

  const EventosEstatisticas({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Observer(
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatCard(
              context,
              icon: Icons.event,
              title: 'Total',
              value: '${controller.totalEventos}',
              color: colorScheme.primary,
            ),
            Container(
              height: 40,
              width: 1,
              color: colorScheme.outline.withOpacity(0.3),
            ),
            _buildStatCard(
              context,
              icon: Icons.upcoming,
              title: 'Próximos',
              value: '${controller.totalEventosFuturos}',
              color: colorScheme.secondary,
            ),
            Container(
              height: 40,
              width: 1,
              color: colorScheme.outline.withOpacity(0.3),
            ),
            _buildStatCard(
              context,
              icon: Icons.history,
              title: 'Passados',
              value: '${controller.totalEventos - controller.totalEventosFuturos}',
              color: colorScheme.tertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
