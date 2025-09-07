import 'package:flutter/material.dart';
import 'package:paroquia_sao_lourenco/app/services/notification_service.dart';

/// Widget de demonstração para testar as funcionalidades de notificação
class NotificationTestWidget extends StatefulWidget {
  const NotificationTestWidget({super.key});

  @override
  State<NotificationTestWidget> createState() => _NotificationTestWidgetState();
}

class _NotificationTestWidgetState extends State<NotificationTestWidget> {
  final NotificationService _notificationService = NotificationService();
  String? _fcmToken;
  bool _isSubscribedToGeneral = false;
  bool _isSubscribedToEvents = false;

  @override
  void initState() {
    super.initState();
    _loadFCMToken();
    _setupNotificationListener();
  }

  /// Carrega o token FCM
  Future<void> _loadFCMToken() async {
    final token = await _notificationService.getToken();
    if (mounted) {
      setState(() {
        _fcmToken = token;
      });
    }
  }

  /// Configura o listener para notificações
  void _setupNotificationListener() {
    _notificationService.messageStream.listen((message) {
      if (mounted) {
        _showNotificationSnackBar(
          "Notificação recebida: ${message.notification?.title}",
        );
      }
    });
  }

  /// Exibe um SnackBar com a mensagem da notificação
  void _showNotificationSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Inscreve/desinscreve do tópico geral
  Future<void> _toggleGeneralSubscription() async {
    if (_isSubscribedToGeneral) {
      await _notificationService.unsubscribeFromTopic('geral');
      _showNotificationSnackBar("Desinscrito do tópico: geral");
    } else {
      await _notificationService.subscribeToTopic('geral');
      _showNotificationSnackBar("Inscrito no tópico: geral");
    }
    
    setState(() {
      _isSubscribedToGeneral = !_isSubscribedToGeneral;
    });
  }

  /// Inscreve/desinscreve do tópico eventos
  Future<void> _toggleEventsSubscription() async {
    if (_isSubscribedToEvents) {
      await _notificationService.unsubscribeFromTopic('eventos');
      _showNotificationSnackBar("Desinscrito do tópico: eventos");
    } else {
      await _notificationService.subscribeToTopic('eventos');
      _showNotificationSnackBar("Inscrito no tópico: eventos");
    }
    
    setState(() {
      _isSubscribedToEvents = !_isSubscribedToEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste de Notificações'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Token FCM:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                _fcmToken ?? 'Carregando...',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Gerenciar Inscrições:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: const Text('Notificações Gerais'),
                subtitle: Text(
                  _isSubscribedToGeneral ? 'Inscrito' : 'Não inscrito',
                ),
                trailing: Switch(
                  value: _isSubscribedToGeneral,
                  onChanged: (_) => _toggleGeneralSubscription(),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Eventos'),
                subtitle: Text(
                  _isSubscribedToEvents ? 'Inscrito' : 'Não inscrito',
                ),
                trailing: Switch(
                  value: _isSubscribedToEvents,
                  onChanged: (_) => _toggleEventsSubscription(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Instruções:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1. Copie o token FCM acima',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '2. Use o Firebase Console para enviar uma notificação de teste',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '3. Ou inscreva-se nos tópicos e envie notificações para eles',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
