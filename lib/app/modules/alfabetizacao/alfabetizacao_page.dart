import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class AlfabetizacaoPage extends StatelessWidget {
  final String title;
  const AlfabetizacaoPage({Key? key, this.title = "Alfabetização de Adultos"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'alfabetizacao_adultos',
    );
  }
}
