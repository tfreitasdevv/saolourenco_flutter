import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class SaudePage extends StatelessWidget {
  final String title;
  const SaudePage({Key? key, this.title = "Pastoral da Saúde"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'saude',
    );
  }
}
