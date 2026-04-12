import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class MejPage extends StatelessWidget {
  final String title;
  const MejPage({Key? key, this.title = "MEJ"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'mej',
    );
  }
}
