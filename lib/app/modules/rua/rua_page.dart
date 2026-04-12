import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class RuaPage extends StatelessWidget {
  final String title;
  const RuaPage({Key? key, this.title = "Pastoral de Rua"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'rua',
    );
  }
}
