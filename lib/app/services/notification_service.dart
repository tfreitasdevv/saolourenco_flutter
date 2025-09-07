import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Serviço responsável por gerenciar as notificações push do Firebase Cloud Messaging
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final StreamController<RemoteMessage> _messageController = StreamController<RemoteMessage>.broadcast();

  /// Stream para ouvir mensagens recebidas
  Stream<RemoteMessage> get messageStream => _messageController.stream;

  /// Inicializa o serviço de notificações
  Future<void> initialize() async {
    try {
      // Solicita permissão para notificações (iOS)
      await _requestPermission();

      // Configura handlers para diferentes estados da aplicação
      await _configureHandlers();

      // Obtém o token do dispositivo
      final token = await getToken();
      debugPrint("🔑 FCM Token: $token");

      // Escuta mudanças no token
      _firebaseMessaging.onTokenRefresh.listen((token) {
        debugPrint("🔄 FCM Token atualizado: $token");
        // Aqui você pode enviar o novo token para seu backend
        _saveTokenToDatabase(token);
      });

    } catch (e) {
      debugPrint("❌ Erro ao inicializar NotificationService: $e");
    }
  }

  /// Solicita permissão para notificações
  Future<void> _requestPermission() async {
    try {
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('✅ Permissão para notificações concedida');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        debugPrint('⚠️ Permissão provisória para notificações concedida');
      } else {
        debugPrint('❌ Permissão para notificações negada');
      }
    } catch (e) {
      debugPrint("❌ Erro ao solicitar permissão: $e");
    }
  }

  /// Configura os handlers para diferentes estados da aplicação
  Future<void> _configureHandlers() async {
    try {
      // Handler para quando o app está em foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('📩 Mensagem recebida em foreground: ${message.notification?.title}');
        _messageController.add(message);
        _showNotificationDialog(message);
      });

      // Handler para quando o usuário toca na notificação (app em background)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('🔔 Notificação tocada (app em background): ${message.notification?.title}');
        _handleNotificationTap(message);
      });

      // Verifica se o app foi aberto por uma notificação
      RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('🚀 App aberto por notificação: ${initialMessage.notification?.title}');
        _handleNotificationTap(initialMessage);
      }
    } catch (e) {
      debugPrint("❌ Erro ao configurar handlers: $e");
    }
  }

  /// Obtém o token do dispositivo
  Future<String?> getToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      return token;
    } catch (e) {
      debugPrint("❌ Erro ao obter token: $e");
      return null;
    }
  }

  /// Inscreve em um tópico específico
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint("✅ Inscrito no tópico: $topic");
    } catch (e) {
      debugPrint("❌ Erro ao se inscrever no tópico $topic: $e");
    }
  }

  /// Desinscreve de um tópico específico
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint("✅ Desinscrito do tópico: $topic");
    } catch (e) {
      debugPrint("❌ Erro ao se desinscrever do tópico $topic: $e");
    }
  }

  /// Exibe um dialog com a notificação quando o app está em foreground
  void _showNotificationDialog(RemoteMessage message) {
    // Esta implementação pode ser customizada conforme sua necessidade
    // Por exemplo, você pode usar um package como fluttertoast ou mostrar um SnackBar
    debugPrint("💬 Título: ${message.notification?.title}");
    debugPrint("💬 Corpo: ${message.notification?.body}");
    debugPrint("💬 Dados: ${message.data}");
  }

  /// Manipula o toque na notificação
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint("👆 Notificação tocada: ${message.data}");
    
    // Aqui você pode implementar a navegação baseada nos dados da notificação
    // Exemplo:
    // if (message.data['screen'] == 'profile') {
    //   // Navegar para a tela de perfil
    // } else if (message.data['screen'] == 'events') {
    //   // Navegar para a tela de eventos
    // }
  }

  /// Salva o token no banco de dados (implementar conforme sua necessidade)
  Future<void> _saveTokenToDatabase(String token) async {
    try {
      // Aqui você implementaria a lógica para salvar o token no Firestore
      // Por exemplo:
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(currentUserId)
      //     .update({'fcmToken': token});
      
      debugPrint("💾 Token salvo no banco de dados: $token");
    } catch (e) {
      debugPrint("❌ Erro ao salvar token no banco: $e");
    }
  }

  /// Limpa recursos
  void dispose() {
    _messageController.close();
  }
}

/// Handler para mensagens em background (deve ser função top-level)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("🔄 Mensagem em background: ${message.notification?.title}");
  
  // Aqui você pode processar a mensagem em background
  // Por exemplo, salvar dados localmente, atualizar badge, etc.
}
