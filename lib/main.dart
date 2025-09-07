import 'package:flutter/material.dart';
import 'package:paroquia_sao_lourenco/app/app_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/app_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:paroquia_sao_lourenco/app/shared/services/push_notification_service.dart';
import 'firebase_options_env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carrega variáveis de ambiente
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("❌ Erro ao carregar arquivo .env: $e");
  }
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("❌ Erro ao inicializar Firebase: $e");
  }

  // Inicializa as notificações push
  try {
    final pushService = PushNotificationService();
    await pushService.initialize();
  } catch (e) {
    debugPrint("❌ Erro ao inicializar push notifications: $e");
  }
  
  runApp(ModularApp(
    module: AppModule(),
    child: AppWidget(),
  ));
}