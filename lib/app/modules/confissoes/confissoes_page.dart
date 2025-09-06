import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui'; // Para ImageFilter
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';
import 'package:paroquia_sao_lourenco/app/shared/widgets/rich_text_markdown.dart';

class ConfissoesPage extends StatefulWidget {
  final String title;
  const ConfissoesPage({Key? key, this.title = "Confissões"}) : super(key: key);

  @override
  State<ConfissoesPage> createState() => _ConfissoesPageState();
}

class _ConfissoesPageState extends State<ConfissoesPage> {
  final List<String> documentIds = [
    'primeira_secao',
    'segunda_secao',
    'terceira_secao',
    'quarta_secao'
  ];

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
          SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Renderiza as 4 seções
                ...documentIds.map((docId) => _buildSecao(docId)).toList(),
                SizedBox(height: 20), // Espaçamento final
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecao(String documentId) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('confissoes')
          .doc(documentId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingSection();
        }

        if (snapshot.hasError) {
          return _buildErrorSection(documentId, snapshot.error.toString());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return _buildNotFoundSection(documentId);
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final titulo = data['titulo'] ?? 'Título não encontrado';
        final texto = data['texto'] ?? 'Texto não encontrado.';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Título da seção
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
            
            // Texto da seção em Markdown
            RichTextMarkdown(
              markdownText: texto,
              fontSize: 18,
              textColor: Colors.white,
              fontFamily: 'Raleway',
            ),
            
            SizedBox(height: 40), // Espaçamento entre seções
          ],
        );
      },
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Carregando seção...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontFamily: 'Raleway',
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildErrorSection(String documentId, String error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Erro ao carregar seção',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.red[300],
            fontFamily: 'CinzelDecorative',
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Não foi possível carregar a seção "$documentId". Erro: $error',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontFamily: 'Raleway',
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildNotFoundSection(String documentId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seção não encontrada',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.orange[300],
            fontFamily: 'CinzelDecorative',
          ),
        ),
        SizedBox(height: 8),
        Text(
          'O documento "$documentId" não foi encontrado na coleção confissoes.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontFamily: 'Raleway',
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
