import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class BatismoPage extends StatelessWidget {
  final String title;
  const BatismoPage({Key? key, this.title = "Pastoral do Batismo"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'batismo',
    );
  }
}
