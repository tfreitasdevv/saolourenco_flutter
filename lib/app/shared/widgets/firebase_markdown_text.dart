import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';
import 'package:paroquia_sao_lourenco/app/shared/widgets/rich_text_markdown.dart';

/// Widget para exibir texto dinâmico do Firebase com formatação Markdown
/// 
/// Uso: FirebaseMarkdownText(
///   collection: 'confissoes',
///   document: 'texto_confissoes', 
///   field: 'texto'
/// )
class FirebaseMarkdownText extends StatefulWidget {
  final String collection;
  final String document;
  final String field;
  final String? title;
  final double? fontSize;
  final Color? textColor;
  final String? fontFamily;
  final String errorMessage;
  final String loadingMessage;

  const FirebaseMarkdownText({
    Key? key,
    required this.collection,
    required this.document,
    required this.field,
    this.title,
    this.fontSize = 16,
    this.textColor,
    this.fontFamily = 'Raleway',
    this.errorMessage = 'Erro ao carregar o conteúdo.',
    this.loadingMessage = 'Carregando...',
  }) : super(key: key);

  @override
  State<FirebaseMarkdownText> createState() => _FirebaseMarkdownTextState();
}

class _FirebaseMarkdownTextState extends State<FirebaseMarkdownText> {
  String _texto = '';
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _carregarTexto();
  }

  Future<void> _carregarTexto() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(widget.collection)
          .doc(widget.document)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        _texto = data?[widget.field] ?? widget.errorMessage;
      } else {
        _texto = 'Documento não encontrado.';
        _hasError = true;
      }
    } catch (e) {
      _texto = '${widget.errorMessage} Erro: $e';
      _hasError = true;
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(t2),
            ),
            SizedBox(height: 16),
            Text(
              widget.loadingMessage,
              style: TextStyle(
                color: Colors.white,
                fontFamily: widget.fontFamily,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título (se fornecido)
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: t2,
              fontFamily: 'CinzelDecorative',
            ),
          ),
          SizedBox(height: 20),
        ],
        
        // Conteúdo com Markdown
        RichTextMarkdown(
          markdownText: _texto,
          fontSize: widget.fontSize,
          textColor: widget.textColor,
          fontFamily: widget.fontFamily,
        ),
        
        // Botão de recarregar se houver erro
        if (_hasError) ...[
          SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: _carregarTexto,
              icon: Icon(Icons.refresh),
              label: Text('Tentar novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: t2,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
