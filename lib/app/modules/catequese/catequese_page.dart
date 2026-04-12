import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class CatequesePage extends StatelessWidget {
  final String title;
  const CatequesePage({Key? key, this.title = "Catequese"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'catequese',
    );
  }
}
