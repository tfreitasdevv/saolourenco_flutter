import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class DizimoPage extends StatelessWidget {
  final String title;
  const DizimoPage({Key? key, this.title = "Pastoral do Dízimo"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'dizimo',
    );
  }
}
