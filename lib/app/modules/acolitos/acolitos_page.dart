import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class AcolitosPage extends StatelessWidget {
  final String title;
  const AcolitosPage({Key? key, this.title = "Acólitos Instituídos"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'acolitos',
    );
  }
}
