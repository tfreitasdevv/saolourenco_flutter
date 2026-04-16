import 'package:flutter/material.dart';

class IconsHome extends StatelessWidget {
  final String icone;
  final VoidCallback funcao;
  final bool web;

  const IconsHome({
    Key? key,
    required this.icone,
    required this.funcao,
    required this.web,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        icone,
        color: Colors.white,
      ),
      iconSize: 40,
      onPressed: funcao,
    );
  }
}