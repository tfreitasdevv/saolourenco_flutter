import 'package:flutter/material.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';
import 'package:paroquia_sao_lourenco/app/shared/utils/url_launcher_utils.dart';

/// Card para exibir cada item da API "como ajudar"
class ComoAjudarCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const ComoAjudarCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String titulo = data['titulo'] ?? '';
    final String comoAtuamos = data['como_atuamos'] ?? '';
    final String comoAjudar = data['como_ajudar'] ?? '';
    final imagem = data['imagem'];
    String imagemUrl = '';
    if (imagem is Map<String, dynamic>) {
      imagemUrl = imagem['url'] ?? '';
    } else if (imagem is String) {
      imagemUrl = imagem;
    }
    final String link = data['link'] ?? '';
    final String contato = data['contato'] ?? '';

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            if (titulo.isNotEmpty)
              Center(
                child: Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: t2,
                  ),
                ),
              ),



            // Como atuamos
            if (comoAtuamos.isNotEmpty) ...[
              SizedBox(height: 12),
              Text(
                "Como atuamos",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: t3,
                ),
              ),
              SizedBox(height: 4),
              Text(
                comoAtuamos,
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
            ],

            // Como ajudar
            if (comoAjudar.isNotEmpty) ...[
              SizedBox(height: 12),
              Text(
                "Como ajudar",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: t3,
                ),
              ),
              SizedBox(height: 4),
              Text(
                comoAjudar,
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
            ],

            // Imagem
            if (imagemUrl.isNotEmpty) ...[
              SizedBox(height: 12),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.3,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imagemUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container();
                      },
                    ),
                  ),
                ),
              ),
            ],

            // Contato
            if (contato.isNotEmpty) ...[
              SizedBox(height: 12),
              Text(
                "Contato",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: t3,
                ),
              ),
              SizedBox(height: 4),
              Text(
                contato,
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
            ],

            // Link
            if (link.isNotEmpty) ...[
              SizedBox(height: 12),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    UrlLauncherUtils.abrirUrl(link, context: context);
                  },
                  icon: Icon(Icons.open_in_new, size: 18),
                  label: Text("Saiba mais"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: t2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
