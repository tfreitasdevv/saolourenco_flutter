import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class ConferenciaSaoVicentePage extends StatelessWidget {
  final String title;
  const ConferenciaSaoVicentePage({Key? key, this.title = "Conferência São Vicente de Paulo"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'conferencia_sao_vicente',
    );
  }
}
