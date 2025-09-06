import 'package:flutter/material.dart';

class PastoralItemModel {
  final String titulo;
  final String image;
  final Color textColor;
  final VoidCallback funcao;

  PastoralItemModel({
    required this.titulo,
    required this.image,
    required this.textColor,
    required this.funcao,
  });
}