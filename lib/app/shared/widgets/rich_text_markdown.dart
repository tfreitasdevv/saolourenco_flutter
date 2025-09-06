import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';

/// Widget reutilizável para renderizar texto com formatação Markdown
/// 
/// Permite exibir texto com formatação rica vindo do Firebase:
/// - **Negrito**
/// - *Itálico*
/// - # Títulos
/// - Listas com bullet points
/// - E outras funcionalidades do Markdown
class RichTextMarkdown extends StatelessWidget {
  final String markdownText;
  final double? fontSize;
  final Color? textColor;
  final String? fontFamily;
  final TextAlign? textAlign;

  const RichTextMarkdown({
    Key? key,
    required this.markdownText,
    this.fontSize = 16,
    this.textColor,
    this.fontFamily = 'Raleway',
    this.textAlign = TextAlign.justify,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: markdownText,
      styleSheet: MarkdownStyleSheet(
        // Configurações gerais de texto
        p: TextStyle(
          fontSize: fontSize,
          color: textColor ?? Colors.black87,
          fontFamily: fontFamily,
          height: 1.6,
        ),
        
        // Títulos
        h1: TextStyle(
          fontSize: (fontSize ?? 16) * 1.8,
          fontWeight: FontWeight.bold,
          color: textColor ?? t2,
          fontFamily: 'CinzelDecorative',
          height: 1.4,
        ),
        h2: TextStyle(
          fontSize: (fontSize ?? 16) * 1.5,
          fontWeight: FontWeight.bold,
          color: textColor ?? t2,
          fontFamily: 'CinzelDecorative',
          height: 1.3,
        ),
        h3: TextStyle(
          fontSize: (fontSize ?? 16) * 1.3,
          fontWeight: FontWeight.bold,
          color: textColor ?? t2,
          fontFamily: fontFamily,
          height: 1.2,
        ),
        
        // Texto em negrito
        strong: TextStyle(
          fontWeight: FontWeight.bold,
          color: textColor ?? Colors.black87,
          fontFamily: fontFamily,
        ),
        
        // Texto em itálico
        em: TextStyle(
          fontStyle: FontStyle.italic,
          color: textColor ?? Colors.black87,
          fontFamily: fontFamily,
        ),
        
        // Listas
        listBullet: TextStyle(
          fontSize: fontSize,
          color: textColor ?? t2,
          fontFamily: fontFamily,
        ),
        
        // Links (se houver)
        a: TextStyle(
          color: textColor ?? t2,
          decoration: TextDecoration.underline,
          fontFamily: fontFamily,
        ),
        
        // Citações (blockquote)
        blockquote: TextStyle(
          color: textColor?.withOpacity(0.8) ?? Colors.black54,
          fontStyle: FontStyle.italic,
          fontSize: fontSize,
          fontFamily: fontFamily,
        ),
        
        // Código inline
        code: TextStyle(
          backgroundColor: textColor != null ? Colors.white.withOpacity(0.2) : Colors.grey[200],
          color: textColor ?? Colors.black87,
          fontSize: (fontSize ?? 16) * 0.9,
          fontFamily: 'monospace',
        ),
      ),
      
      // Configurações adicionais
      selectable: true, // Permite seleção do texto
      shrinkWrap: true,
    );
  }
}
