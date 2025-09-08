import 'package:flutter/material.dart';

/// Widget para exibir quando não há eventos para mostrar
class EventosVazios extends StatelessWidget {
  final String titulo;
  final String mensagem;
  final IconData icone;
  final VoidCallback? onRecarregar;

  const EventosVazios({
    Key? key,
    this.titulo = 'Nenhum evento encontrado',
    this.mensagem = 'Não há eventos disponíveis no momento.',
    this.icone = Icons.event_busy,
    this.onRecarregar,
  }) : super(key: key);

  const EventosVazios.semEventosFuturos({
    Key? key,
    this.onRecarregar,
  }) : titulo = 'Nenhum evento próximo',
        mensagem = 'Não há eventos agendados para os próximos dias.',
        icone = Icons.upcoming,
        super(key: key);

  const EventosVazios.semEventosPassados({
    Key? key,
    this.onRecarregar,
  }) : titulo = 'Nenhum evento anterior',
        mensagem = 'Não há eventos passados para exibir.',
        icone = Icons.history,
        super(key: key);

  const EventosVazios.busca({
    Key? key,
    this.onRecarregar,
  }) : titulo = 'Nenhum resultado encontrado',
        mensagem = 'Tente alterar os termos de busca.',
        icone = Icons.search_off,
        super(key: key);

  const EventosVazios.erro({
    Key? key,
    this.onRecarregar,
  }) : titulo = 'Erro ao carregar eventos',
        mensagem = 'Verifique sua conexão com a internet e tente novamente.',
        icone = Icons.error_outline,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icone,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              titulo,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              mensagem,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (onRecarregar != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRecarregar,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget para exibir carregamento dos eventos
class EventosCarregando extends StatelessWidget {
  final String? mensagem;

  const EventosCarregando({
    Key? key,
    this.mensagem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            if (mensagem != null) ...[
              const SizedBox(height: 16),
              Text(
                mensagem!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
