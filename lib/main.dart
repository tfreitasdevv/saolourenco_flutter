import 'package:flutter/material.dart';
import 'package:paroquia_sao_lourenco/app/app_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/app_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:paroquia_sao_lourenco/app/services/notification_service.dart';
import 'firebase_options_env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Registra o handler para mensagens em background
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
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
    
    // Inicializa o serviço de notificações
    await NotificationService().initialize();
    debugPrint("✅ Serviço de notificações inicializado");
    
  } catch (e) {
    debugPrint("❌ Erro ao inicializar Firebase: $e");
  }
  
  runApp(ModularApp(
    module: AppModule(),
    child: AppWidget(),
  ));
}