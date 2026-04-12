import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class PromocaoHumanaPage extends StatelessWidget {
  final String title;
  const PromocaoHumanaPage({Key? key, this.title = "Pastoral da Promoção Humana"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'promocao_humana',
    );
  }
}
