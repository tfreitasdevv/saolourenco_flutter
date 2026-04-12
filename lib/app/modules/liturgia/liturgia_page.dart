import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class LiturgiaPage extends StatelessWidget {
  final String title;
  const LiturgiaPage({Key? key, this.title = "Pastoral da Liturgia"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'liturgia',
    );
  }
}
