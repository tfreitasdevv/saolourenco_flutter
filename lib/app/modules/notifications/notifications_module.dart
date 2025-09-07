import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/notifications/notification_settings_page.dart';

/// Módulo responsável pelas funcionalidades de notificações push
class NotificationsModule extends Module {
  @override
  void binds(Injector i) {
    // O serviço já está registrado no AppModule
    // mas você pode adicionar outros binds relacionados aqui se necessário
  }

  @override
  void routes(RouteManager r) {
    r.child('/settings', child: (context) => const NotificationSettingsPage());
  }
}
