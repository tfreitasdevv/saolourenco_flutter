import 'package:flutter/material.dart';
import 'package:paroquia_sao_lourenco/app/app_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/app_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ModularApp(
    module: AppModule(),
    child: AppWidget(),
  ));
}