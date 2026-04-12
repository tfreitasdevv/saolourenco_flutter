import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class FamiliarPage extends StatelessWidget {
  final String title;
  const FamiliarPage({Key? key, this.title = "Pastoral Familiar"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'familiar',
    );
  }
}
