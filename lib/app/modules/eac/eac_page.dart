import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class EacPage extends StatelessWidget {
  final String title;
  const EacPage({Key? key, this.title = "EAC"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'eac',
    );
  }
}
