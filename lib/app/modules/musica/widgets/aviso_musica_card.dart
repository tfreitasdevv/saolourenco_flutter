import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';

class AvisoMusicaCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const AvisoMusicaCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dataDT = DateTime.parse(data['data']);
    var dataFormatada = DateFormat('dd/MM/yyyy').format(dataDT);
    String descricaoForm = data['descricao'] ?? '';
    String nD = descricaoForm.replaceAll("\\n", "\n");

    return Card(
        child: Padding(
      padding: EdgeInsets.all(12),
      child: ExpandablePanel(
        header: Column(
          children: <Widget>[
            Text(
              data['titulo'],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 3,
            ),
            Align(
              child: Text(
                "Publicado em $dataFormatada",
                style: TextStyle(color: t5),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
        collapsed: Text(
          nD,
          softWrap: true,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        expanded: Text(
          nD,
          softWrap: true,
        ),
      ),
    ));
  }
}