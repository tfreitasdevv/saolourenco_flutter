import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class GrupoDeOracaoPage extends StatelessWidget {
  final String title;
  const GrupoDeOracaoPage({Key? key, this.title = "Grupo De Oração"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'grupo_de_oracao',
    );
  }
}
