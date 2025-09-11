import 'package:flutter/material.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';

class ButtonHome extends StatelessWidget {
  final String texto;
  final VoidCallback? funcao;

  const ButtonHome({
    Key? key,
    required this.texto,
    this.funcao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var largura = MediaQuery.of(context).size.width;

    return SizedBox(
      width: largura * 0.80, // 80% da largura da tela
      height: 50,
      child: ElevatedButton(
        onPressed: funcao,
        style: ElevatedButton.styleFrom(
          backgroundColor: t2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: largura < 400 ? 16 : 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}