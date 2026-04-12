import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class CrismaPage extends StatelessWidget {
  final String title;
  const CrismaPage({Key? key, this.title = "Crisma"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'catecumenato_crismal',
    );
  }
}
