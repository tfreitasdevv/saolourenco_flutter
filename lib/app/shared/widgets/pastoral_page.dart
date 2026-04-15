import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../config/api_config.dart';
import '../constants/constants.dart';
import '../services/strapi_client.dart';
import '../utils/url_launcher_utils.dart';
import 'rich_text_markdown.dart';

/// Widget centralizado para páginas de pastorais/movimentos.
///
/// Todas as páginas que exibem conteúdo dinâmico da API Strapi
/// (content type "pastoral-conteudo") compartilham a mesma estrutura visual.
/// Este widget elimina a duplicação de código entre os módulos.
///
/// Parâmetros:
/// - [title]: título exibido na AppBar.
/// - [documentId]: slug da pastoral no Strapi (equivalente ao antigo documentId do Firestore).
/// - [bottomWidget]: widget opcional exibido abaixo das seções (ex.: botão de acesso a membros).
class PastoralPage extends StatefulWidget {
  final String title;
  final String documentId;
  final Widget? bottomWidget;

  const PastoralPage({
    Key? key,
    required this.title,
    required this.documentId,
    this.bottomWidget,
  }) : super(key: key);

  @override
  State<PastoralPage> createState() => _PastoralPageState();
}

class _PastoralPageState extends State<PastoralPage> {
  late final Future<List<Map<String, dynamic>>> _secoesFuture;

  /// Regex para detectar números de telefone brasileiros no texto
  static final _regexTelefone = RegExp(
    r'(?:\+55\s?)?'
    r'(?:\(?\d{2}\)?[\s.-]?)'
    r'\d{4,5}[\s.-]?\d{4}',
  );

  @override
  void initState() {
    super.initState();
    _secoesFuture = _carregarSecoes();
  }

  /// Carrega as seções da pastoral via API Strapi.
  /// Busca pelo slug e extrai o componente repetível "secoes".
  Future<List<Map<String, dynamic>>> _carregarSecoes() async {
    final client = Modular.get<StrapiClient>();
    final response = await client.get(
      ApiConfig.pastoralConteudos,
      queryParameters: {
        'filters[slug][\$eq]': widget.documentId,
        'populate': 'secoes,secoes.url_imagem',
      },
    );
    final List data = response.data['data'] ?? [];
    if (data.isEmpty) return [];

    final pastoral = data.first as Map<String, dynamic>;
    final List secoesRaw = pastoral['secoes'] ?? [];

    final secoes = secoesRaw.map<Map<String, dynamic>>((s) {
      final map = s as Map<String, dynamic>;
      final tipo = map['tipo'] ?? 'texto';
      final urlImagem = map['url_imagem'];
      String imagemUrl = '';
      if (urlImagem is Map<String, dynamic>) {
        imagemUrl = urlImagem['url'] ?? '';
      } else if (urlImagem is String) {
        imagemUrl = urlImagem;
      }
      return {
        'titulo': map['titulo'] ?? '',
        'tipo': tipo,
        'texto': (map['texto'] ?? '').toString(),
        'link': (map['link'] ?? '').toString(),
        'url': imagemUrl,
        'ordem': map['ordem'] ?? 999,
      };
    }).toList();

    secoes.sort((a, b) => (a['ordem'] as int).compareTo(b['ordem'] as int));
    return secoes;
  }

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
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _secoesFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final secoes = snapshot.data!;

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
                                  UrlLauncherUtils.abrirUrl(link,
                                      context: context);
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
                            markdownText:
                                _converterTelefonesEmLinks(secoes[i]['texto']),
                            fontSize: isWide ? 18 : 16,
                            textColor: Colors.white,
                            textAlign: TextAlign.justify,
                            onTapLink: (text, href, title) {
                              if (href != null &&
                                  href.startsWith('whatsapp:')) {
                                final telefone =
                                    href.replaceFirst('whatsapp:', '');
                                UrlLauncherUtils.abrirWhatsApp(telefone,
                                    context: context);
                              } else if (href != null) {
                                UrlLauncherUtils.abrirUrl(href,
                                    context: context);
                              }
                            },
                          ),
                        ],
                        if (i < secoes.length - 1) SizedBox(height: 22),
                      ],
                      SizedBox(height: 22),
                      if (widget.bottomWidget != null) widget.bottomWidget!,
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
