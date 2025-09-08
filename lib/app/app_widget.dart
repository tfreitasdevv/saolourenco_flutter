import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Paróquia São Lourenço',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8D6E63), // Marrom mais consistente
          brightness: Brightness.light,
        ).copyWith(
          // Personalizações específicas para manter a identidade visual
          primaryContainer: const Color(0xFFD7CCC8), // Bege claro para filtros selecionados
          onPrimaryContainer: const Color(0xFF3E2723), // Marrom escuro
          surface: Colors.white, // Fundo branco para Cards, botões, etc.
          surfaceContainer: Colors.white, // Fundo branco para containers
          surfaceContainerLow: Colors.white, // Fundo branco para containers baixos
          surfaceContainerHigh: Colors.white, // Fundo branco para containers altos
          surfaceContainerHighest: Colors.white, // Fundo branco para filtros não selecionados
          onSurfaceVariant: const Color(0xFF5D4037), // Marrom médio para texto
        ),
        fontFamily: 'Raleway',
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white, // Cor do texto e ícones da AppBar
          iconTheme: IconThemeData(color: Colors.white), // Cor dos ícones
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      routerConfig: Modular.routerConfig,
    );
  }
}