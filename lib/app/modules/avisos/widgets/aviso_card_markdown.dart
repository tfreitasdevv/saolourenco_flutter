import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';
import 'package:paroquia_sao_lourenco/app/shared/widgets/rich_text_markdown.dart';

/// Card de aviso com suporte a formatação Markdown
class AvisoCardMarkdown extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const AvisoCardMarkdown({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = snapshot.data() as Map<String, dynamic>;
    Timestamp dataTS = data["data"];
    DateTime dataDT =
        DateTime.fromMillisecondsSinceEpoch(dataTS.seconds * 1000);
    var dataFormatada = DateFormat('dd/MM/yyyy').format(dataDT);
    
    // O campo descrição agora pode conter Markdown
    String descricaoMarkdown = data['descricao'] ?? '';
    String image = data["imagem"] ?? '';

    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: ExpandablePanel(
          header: Column(
            children: <Widget>[
              Text(
                data['titulo'] ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold,
                  fontFamily: 'CinzelDecorative',
                ),
              ),
              SizedBox(height: 3),
              Align(
                child: Text(
                  "Publicado em $dataFormatada",
                  style: TextStyle(color: t5),
                ),
                alignment: Alignment.centerRight,
              ),
            ],
          ),
          collapsed: Container(),
          expanded: Column(
            children: <Widget>[
              SizedBox(height: 10),
              // Usando RichTextMarkdown em vez de Text simples
              RichTextMarkdown(
                markdownText: descricaoMarkdown,
                fontSize: 14,
                textColor: Colors.black87,
              ),
              SizedBox(height: 10),
              // Imagem (se houver)
              if (image.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 100,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
