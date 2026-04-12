import 'package:flutter/material.dart';

import '../../shared/widgets/pastoral_page.dart';

class MaeTresVezesPage extends StatelessWidget {
  final String title;
  const MaeTresVezesPage({Key? key, this.title = "Mãe Três Vezes Admirável Schoenstatt"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastoralPage(
      title: title,
      documentId: 'mae_tres_vezes_admiravel',
    );
  }
}
