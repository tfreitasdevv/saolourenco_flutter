import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Paróquia São Lourenço',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'Raleway',
        appBarTheme: AppBarTheme(
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