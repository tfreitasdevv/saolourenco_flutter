import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class EjcPage extends StatelessWidget {
  final String title;
  const EjcPage({Key? key, this.title = "EJC"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'ejc',
    );
  }
}
