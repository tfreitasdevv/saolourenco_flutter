import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class PascomPage extends StatelessWidget {
  final String title;
  const PascomPage({Key? key, this.title = "PASCOM"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'pascom',
    );
  }
}
