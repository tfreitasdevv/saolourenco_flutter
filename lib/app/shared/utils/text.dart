import 'package:flutter/material.dart';

Text text(
  String s, {
  double fontSize = 14,
  Color color = Colors.white,
  bool bold = false,
}) {
  return Text(
    s,
    style: TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    ),
  );
}