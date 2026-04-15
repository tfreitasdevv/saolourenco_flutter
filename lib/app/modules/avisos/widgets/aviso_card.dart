import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';
import 'package:paroquia_sao_lourenco/app/shared/utils/url_launcher_utils.dart';

class AvisoCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const AvisoCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? dataStr = data["data"];
    String dataFormatada = '';
    if (dataStr != null && dataStr.isNotEmpty) {
      final dataDT = DateTime.tryParse(dataStr);
      if (dataDT != null) {
        dataFormatada = DateFormat('dd/MM/yyyy').format(dataDT);
      }
    }
    String descricaoForm = data['descricao'] ?? '';
    String nD = descricaoForm.replaceAll("\\n", "\n");
    final imagem = data["imagem"];
    String image = '';
    if (imagem is Map<String, dynamic>) {
      image = imagem['url'] ?? '';
    } else if (imagem is String) {
      image = imagem;
    }
    String? linkTitulo = data["link_titulo"];
    String? linkUrl = data["link_url"];

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
                  // Link opcional
                  if (linkTitulo != null &&
                      linkTitulo.isNotEmpty &&
                      linkUrl != null &&
                      linkUrl.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 16),
                      child: InkWell(
                        onTap: () {
                          UrlLauncherUtils.abrirUrl(linkUrl, context: context);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.open_in_new_rounded,
                                color: t3, size: 18),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                linkTitulo,
                                style: TextStyle(
                                  color: t3,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor: t5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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