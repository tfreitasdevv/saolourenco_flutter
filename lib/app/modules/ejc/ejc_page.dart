import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared/constants/constants.dart';
import '../../shared/utils/url_launcher_utils.dart';
import '../../shared/widgets/rich_text_markdown.dart';

class EjcPage extends StatefulWidget {
  final String title;
  const EjcPage({Key? key, this.title = "EJC"}) : super(key: key);

  @override
  _EjcPageState createState() => _EjcPageState();
}

class _EjcPageState extends State<EjcPage> {
  /// Extrai as seções do documento Firebase e ordena pelo campo "ordem".
  /// Maps cujo nome começa com ">botao" são tratados como botões.
  List<Map<String, dynamic>> _extrairSecoes(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>? ?? {};
    final secoes = <Map<String, dynamic>>[];

    for (final entry in data.entries) {
      if (entry.value is Map) {
        final map = entry.value as Map<String, dynamic>;
        final ehBotao = entry.key.startsWith('>botao');
        final ehImagem = entry.key.startsWith('>imagem');
        secoes.add({
          'titulo': entry.key,
          'tipo': ehBotao ? 'botao' : ehImagem ? 'imagem' : 'texto',
          'texto': (map['texto'] ?? '').toString(),
          if (ehBotao) 'link': (map['link'] ?? '').toString(),
          if (ehImagem) 'url': (map['url'] ?? '').toString(),
          'ordem': (map['ordem'] ?? 999) is int
              ? map['ordem']
              : int.tryParse(map['ordem'].toString()) ?? 999,
        });
      }
    }

    secoes.sort((a, b) => (a['ordem'] as int).compareTo(b['ordem'] as int));
    return secoes;
  }

  /// Regex para detectar números de telefone brasileiros no texto
  static final _regexTelefone = RegExp(
    r'(?:\+55\s?)?'
    r'(?:\(?\d{2}\)?[\s.-]?)'
    r'\d{4,5}[\s.-]?\d{4}',
  );

  /// Converte números de telefone no texto em links Markdown de WhatsApp
  String _converterTelefonesEmLinks(String texto) {
    return texto.replaceAllMapped(_regexTelefone, (match) {
      final numero = match.group(0)!;
      final soDigitos = numero.replaceAll(RegExp(r'[^\d]'), '');
      return '[$numero](whatsapp:$soDigitos)';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 400;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: t2,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(bg), fit: BoxFit.cover)),
        child: SafeArea(
          child: SingleChildScrollView(
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('conteudo_pagina_pastoral')
                  .doc('ejc')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final secoes = _extrairSecoes(snapshot.data!);

                if (secoes.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(28),
                    child: Center(
                      child: Text(
                        'Nenhum conteúdo disponível.',
                        style: TextStyle(
                          fontSize: isWide ? 18 : 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }

                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < secoes.length; i++) ...[
                        if (secoes[i]['tipo'] == 'imagem') ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              secoes[i]['url'] as String,
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: progress.expectedTotalBytes != null
                                        ? progress.cumulativeBytesLoaded /
                                            progress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.broken_image,
                                      color: Colors.white54, size: 48),
                            ),
                          ),
                        ] else if (secoes[i]['tipo'] == 'botao') ...[
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                final link = secoes[i]['link'] as String;
                                if (link.isNotEmpty) {
                                  UrlLauncherUtils.abrirUrl(link, context: context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: t2,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 28,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                secoes[i]['texto'],
                                style: TextStyle(
                                  fontSize: isWide ? 18 : 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          if (secoes[i]['titulo'] != '_') ...[
                            Text(
                              secoes[i]['titulo'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isWide ? 22 : 20,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                          RichTextMarkdown(
                            markdownText: _converterTelefonesEmLinks(secoes[i]['texto']),
                            fontSize: isWide ? 18 : 16,
                            textColor: Colors.white,
                            textAlign: TextAlign.justify,
                            onTapLink: (text, href, title) {
                              if (href != null && href.startsWith('whatsapp:')) {
                                final telefone = href.replaceFirst('whatsapp:', '');
                                UrlLauncherUtils.abrirWhatsApp(telefone, context: context);
                              } else if (href != null) {
                                UrlLauncherUtils.abrirUrl(href, context: context);
                              }
                            },
                          ),
                        ],
                        if (i < secoes.length - 1) SizedBox(height: 22),
                      ],
                      SizedBox(height: 22),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
