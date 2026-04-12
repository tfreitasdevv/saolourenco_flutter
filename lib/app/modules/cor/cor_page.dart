import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class CorPage extends StatelessWidget {
  final String title;
  const CorPage({Key? key, this.title = "Cor"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'cor',
    );
  }
}
