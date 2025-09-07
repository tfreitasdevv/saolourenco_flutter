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
  
  // Carrega variáveis de ambiente (arquivo opcional)
  try {
    await dotenv.load(fileName: ".env");
    debugPrint("✅ Arquivo .env carregado com sucesso");
  } catch (e) {
    // Se não encontrar o .env, continue com valores padrão
    debugPrint("⚠️ Arquivo .env não encontrado, usando configuração padrão: $e");
  }
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("✅ Firebase inicializado com sucesso");
    debugPrint("📋 Plataforma: ${DefaultFirebaseOptions.currentPlatform.projectId}");
  } catch (e) {
    debugPrint("❌ Erro ao inicializar Firebase: $e");
  }

  // Inicializa as notificações push
  try {
    final pushService = PushNotificationService();
    await pushService.initialize();
    debugPrint("✅ Push notifications inicializadas com sucesso");
  } catch (e) {
    debugPrint("❌ Erro ao inicializar push notifications: $e");
  }
  
  runApp(ModularApp(
    module: AppModule(),
    child: AppWidget(),
  ));
}