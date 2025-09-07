import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Serviço responsável por gerenciar as notificações push usando OneSignal
class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  bool _isInitialized = false;

  /// ID do app OneSignal (configurado via .env)
  String get _appId {
    final envAppId = dotenv.env['ONESIGNAL_APP_ID'];
    
    if (envAppId != null && envAppId.isNotEmpty && envAppId != 'your_onesignal_app_id_here') {
      return envAppId;
    }
    
    throw Exception('ONESIGNAL_APP_ID não encontrado ou inválido no arquivo .env');
  }

  /// Inicializa o OneSignal
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Obter App ID
      final appId = _appId;
      
      // Configuração básica do OneSignal
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      
      // Inicializa com o App ID
      OneSignal.initialize(appId);

      // Aguarda um pouco para garantir inicialização
      await Future.delayed(const Duration(milliseconds: 500));

      // Configura os handlers de eventos
      _setupNotificationHandlers();

      // Solicita permissão para notificações
      await _requestPermission();

      _isInitialized = true;
    } catch (e) {
      debugPrint('❌ Erro ao inicializar OneSignal: $e');
    }
  }

  /// Configura os handlers para diferentes eventos de notificação
  void _setupNotificationHandlers() {
    // Handler para quando a notificação é recebida em foreground
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      debugPrint('📱 Notificação recebida em foreground: ${event.notification.title}');
      
      // Você pode customizar o comportamento aqui
      // Por exemplo, mostrar uma dialog personalizada
      event.preventDefault();
      event.notification.display();
    });

    // Handler para quando a notificação é clicada
    OneSignal.Notifications.addClickListener((event) {
      debugPrint('👆 Notificação clicada: ${event.notification.title}');
      
      // Navegar para uma tela específica baseada nos dados da notificação
      _handleNotificationClick(event.notification);
    });

    // Handler para mudanças no estado da permissão
    OneSignal.Notifications.addPermissionObserver((state) {
      debugPrint('🔔 Estado da permissão alterado: ${state.toString()}');
    });
  }

  /// Solicita permissão para enviar notificações
  Future<bool> _requestPermission() async {
    try {
      final permission = await OneSignal.Notifications.requestPermission(true);
      return permission;
    } catch (e) {
      debugPrint('❌ Erro ao solicitar permissão: $e');
      return false;
    }
  }

  /// Obtém o Player ID do usuário (usado para envios direcionados)
  Future<String?> getPlayerId() async {
    try {
      final userId = OneSignal.User.pushSubscription.id;
      return userId;
    } catch (e) {
      debugPrint('❌ Erro ao obter Player ID: $e');
      return null;
    }
  }

  /// Define tags do usuário para segmentação
  Future<void> setUserTags(Map<String, String> tags) async {
    try {
      OneSignal.User.addTags(tags);
      debugPrint('🏷️ Tags do usuário definidas: $tags');
    } catch (e) {
      debugPrint('❌ Erro ao definir tags: $e');
    }
  }

  /// Define o email do usuário (para campanhas de email)
  Future<void> setEmail(String email) async {
    try {
      OneSignal.User.addEmail(email);
      debugPrint('📧 Email do usuário definido: $email');
    } catch (e) {
      debugPrint('❌ Erro ao definir email: $e');
    }
  }

  /// Remove o email do usuário
  Future<void> removeEmail(String email) async {
    try {
      OneSignal.User.removeEmail(email);
      debugPrint('📧 Email removido: $email');
    } catch (e) {
      debugPrint('❌ Erro ao remover email: $e');
    }
  }

  /// Envia eventos customizados para análise
  Future<void> sendEvent(String eventName, Map<String, dynamic> properties) async {
    try {
      OneSignal.Session.addOutcome(eventName);
      debugPrint('📊 Evento enviado: $eventName com propriedades: $properties');
    } catch (e) {
      debugPrint('❌ Erro ao enviar evento: $e');
    }
  }

  /// Trata o clique em notificações
  void _handleNotificationClick(OSNotification notification) {
    // Extrair dados customizados da notificação
    final additionalData = notification.additionalData;
    
    if (additionalData != null) {
      // Exemplo de navegação baseada nos dados
      final screenToOpen = additionalData['screen'];
      final itemId = additionalData['item_id'];
      
      debugPrint('📱 Dados da notificação - Tela: $screenToOpen, ID: $itemId');
      
      // Aqui você pode implementar a navegação usando o Modular
      // Modular.to.pushNamed('/screen/$screenToOpen', arguments: itemId);
    }
  }

  /// Obtém o status da permissão atual
  Future<bool> hasPermission() async {
    try {
      return OneSignal.Notifications.permission;
    } catch (e) {
      debugPrint('❌ Erro ao verificar permissão: $e');
      return false;
    }
  }

  /// Abre as configurações do app para o usuário habilitar notificações manualmente
  Future<void> openNotificationSettings() async {
    try {
      // No OneSignal v5, isso pode ser feito através das configurações do sistema
      debugPrint('🔧 Redirecionando para configurações de notificação');
    } catch (e) {
      debugPrint('❌ Erro ao abrir configurações: $e');
    }
  }

  /// Limpa todas as notificações exibidas
  Future<void> clearAllNotifications() async {
    try {
      OneSignal.Notifications.clearAll();
      debugPrint('🧹 Todas as notificações foram limpas');
    } catch (e) {
      debugPrint('❌ Erro ao limpar notificações: $e');
    }
  }
}
