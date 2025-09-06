import 'package:cached_network_image/cached_network_image.dart';
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
      icon: web == false
          ? CachedNetworkImage(
              color: Colors.white,
              imageUrl: icone,
              errorWidget: (context, url, error) => Icon(
                Icons.image_not_supported,
                color: Colors.white,
              ),
            )
          : Image.network(
              icone,
              color: Colors.white,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.image_not_supported,
                color: Colors.white,
              ),
            ),
      iconSize: 20,
      onPressed: funcao,
    );
  }
}