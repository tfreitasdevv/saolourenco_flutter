import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';

class AvisoCard extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const AvisoCard({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = snapshot.data() as Map<String, dynamic>;
    Timestamp dataTS = data["data"];
    DateTime dataDT =
        DateTime.fromMillisecondsSinceEpoch(dataTS.seconds * 1000);
    var dataFormatada = DateFormat('dd/MM/yyyy').format(dataDT);
    String descricaoForm = data['descricao'];
    String nD = descricaoForm.replaceAll("\\n", "\n");
    String image = data["imagem"];

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
              expanded: Column(
                children: [
                  Text(nD, softWrap: true),
                  SizedBox(height: 10),
                  // Verificar se a imagem existe antes de exibir
                  if (image.isNotEmpty && image != "")
                    Container(
                      child: Image.network(
                        image,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(); // Widget vazio em caso de erro
                        },
                      ),
                    ),
                ],
              ),
            )));
  }
}