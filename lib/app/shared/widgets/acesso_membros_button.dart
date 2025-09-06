import 'package:flutter/material.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';

class AcessoMembrosButton extends StatelessWidget {
  final VoidCallback funcao;

  const AcessoMembrosButton({Key? key, required this.funcao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: funcao,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      child: Text(
        "Acesso a membros",
        style: TextStyle(
          color: t2,
          fontSize: MediaQuery.of(context).size.width > 400 ? 18 : 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}