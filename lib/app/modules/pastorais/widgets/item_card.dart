import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String titulo;
  final String image;
  final VoidCallback funcao;
  final Color textColor;
  final bool isWeb;

  const ItemCard({
    Key? key,
    required this.titulo,
    required this.image,
    required this.funcao,
    required this.textColor,
    required this.isWeb,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        height: 20,
        margin: EdgeInsets.all(4),
      ),
      onTap: funcao,
    );
  }
}