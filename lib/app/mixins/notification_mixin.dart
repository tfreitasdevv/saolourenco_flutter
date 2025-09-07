import 'package:flutter/material.dart';
import 'package:paroquia_sao_lourenco/app/services/notification_service.dart';

/// Exemplo de como integrar notificações em uma tela existente
mixin NotificationMixin<T extends StatefulWidget> on State<T> {
  final NotificationService _notificationService = NotificationService();
  
  @override
  void initState() {
    super.initState();
    _setupNotificationListener();
    _autoSubscribeToGeneralNotifications();
  }

  /// Configura o listener para notificações
  void _setupNotificationListener() {
    _notificationService.messageStream.listen((message) {
      if (mounted) {
        _handleIncomingNotification(message);
      }
    });
  }

  /// Inscreve automaticamente o usuário em notificações gerais
  Future<void> _autoSubscribeToGeneralNotifications() async {
    try {
      await _notificationService.subscribeToTopic('geral');
      debugPrint("✅ Usuário inscrito automaticamente em notificações gerais");
    } catch (e) {
      debugPrint("❌ Erro ao inscrever em notificações gerais: $e");
    }
  }

  /// Manipula notificações recebidas
  void _handleIncomingNotification(message) {
    // Exibe um SnackBar com a notificação
    if (mounted && message.notification != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.notification!.title ?? 'Notificação',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (message.notification!.body != null)
                Text(message.notification!.body!),
            ],
          ),
          backgroundColor: Theme.of(context).primaryColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Ver',
            textColor: Colors.white,
            onPressed: () => _navigateFromNotification(message),
          ),
        ),
      );
    }
  }

  /// Navega baseado nos dados da notificação
  void _navigateFromNotification(message) {
    final data = message.data;
    
    if (data['screen'] != null) {
      switch (data['screen']) {
        case 'eventos':
          // Navegar para tela de eventos
          // Modular.to.pushNamed('/eventos');
          break;
        case 'missas':
          // Navegar para tela de missas
          // Modular.to.pushNamed('/missas');
          break;
        case 'pastorais':
          // Navegar para tela de pastorais
          // Modular.to.pushNamed('/pastorais');
          break;
        default:
          debugPrint("Tela não reconhecida: ${data['screen']}");
      }
    }
  }

  /// Obtém o token FCM do usuário
  Future<String?> getUserFCMToken() async {
    return await _notificationService.getToken();
  }

  /// Inscreve o usuário em um tópico específico
  Future<void> subscribeToTopic(String topic) async {
    await _notificationService.subscribeToTopic(topic);
  }

  /// Desinscreve o usuário de um tópico específico
  Future<void> unsubscribeFromTopic(String topic) async {
    await _notificationService.unsubscribeFromTopic(topic);
  }
}

/// Exemplo de uso do mixin em uma tela
class ExampleScreenWithNotifications extends StatefulWidget {
  const ExampleScreenWithNotifications({super.key});

  @override
  State<ExampleScreenWithNotifications> createState() => _ExampleScreenWithNotificationsState();
}

class _ExampleScreenWithNotificationsState extends State<ExampleScreenWithNotifications> 
    with NotificationMixin {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela com Notificações'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_active,
              size: 64,
              color: Colors.blue,
            ),
            SizedBox(height: 16),
            Text(
              'Esta tela está configurada para receber notificações!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'As notificações aparecerão como SnackBar quando o app estiver em primeiro plano.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final token = await getUserFCMToken();
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Token FCM'),
                content: SelectableText(token ?? 'Token não disponível'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Fechar'),
                  ),
                ],
              ),
            );
          }
        },
        label: const Text('Ver Token'),
        icon: const Icon(Icons.token),
      ),
    );
  }
}
