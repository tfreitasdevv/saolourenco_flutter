import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class NascituroPage extends StatelessWidget {
  final String title;
  const NascituroPage({Key? key, this.title = "Pastoral do Nascituro"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'nascituro',
    );
  }
}
