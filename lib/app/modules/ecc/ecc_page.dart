import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class EccPage extends StatelessWidget {
  final String title;
  const EccPage({Key? key, this.title = "ECC"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'ecc',
    );
  }
}
