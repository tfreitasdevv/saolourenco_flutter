import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class CoroinhasPage extends StatelessWidget {
  final String title;
  const CoroinhasPage({Key? key, this.title = "Coroinhas"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'coroinhas',
    );
  }
}
