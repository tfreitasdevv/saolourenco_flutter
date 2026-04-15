import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'dart:ui'; // Para ImageFilter
import 'package:paroquia_sao_lourenco/app/shared/config/api_config.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';
import 'package:paroquia_sao_lourenco/app/shared/services/strapi_client.dart';
import 'package:paroquia_sao_lourenco/app/shared/widgets/rich_text_markdown.dart';

class ConfissoesPage extends StatefulWidget {
  final String title;
  const ConfissoesPage({Key? key, this.title = "Confissões"}) : super(key: key);

  @override
  State<ConfissoesPage> createState() => _ConfissoesPageState();
}

class _ConfissoesPageState extends State<ConfissoesPage> {
  late final Future<List<Map<String, dynamic>>> _confissoesFuture;

  @override
  void initState() {
    super.initState();
    _confissoesFuture = _carregarConfissoes();
  }

  Future<List<Map<String, dynamic>>> _carregarConfissoes() async {
    final client = Modular.get<StrapiClient>();
    final response = await client.get(
      ApiConfig.confissoes,
      queryParameters: {'sort': 'ordem:asc'},
    );
    final List data = response.data['data'] ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: t2,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Imagem de fundo
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Blur e overlay configuráveis
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: confissoesBlurIntensity,
              sigmaY: confissoesBlurIntensity,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withOpacity(confissoesOverlayOpacity),
            ),
          ),
          // Conteúdo da página
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _confissoesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro ao carregar confissões.',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              }

              final confissoes = snapshot.data ?? [];

              return SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...confissoes.map((item) => _buildSecao(item)).toList(),
                    SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecao(Map<String, dynamic> item) {
    final titulo = item['titulo'] ?? 'Título não encontrado';
    final texto = item['texto'] ?? 'Texto não encontrado.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          titulo,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontFamily: 'Raleway',
          ),
        ),
        SizedBox(height: 12),
        RichTextMarkdown(
          markdownText: texto,
          fontSize: 18,
          textColor: Colors.white,
          fontFamily: 'Raleway',
        ),
        SizedBox(height: 40),
      ],
    );
  }
}
