import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Utilitários para abrir URLs de forma robusta em diferentes plataformas
class UrlLauncherUtils {
  /// Abre uma URL tentando diferentes modos de lançamento para maior compatibilidade
  static Future<bool> abrirUrl(String url, {BuildContext? context}) async {
    try {
      debugPrint('🔗 Tentando abrir URL: $url');
      
      final Uri uri = Uri.parse(url);
      
      // Validar se a URL é válida
      if (uri.scheme.isEmpty) {
        // Se não tem esquema, assumir https para URLs web
        final urlComScheme = url.startsWith('www.') ? 'https://$url' : 'https://$url';
        debugPrint('🔗 URL sem esquema, corrigindo para: $urlComScheme');
        return await abrirUrl(urlComScheme, context: context);
      }
      
      debugPrint('🔗 URI válida. Scheme: ${uri.scheme}, Host: ${uri.host}');
      
      // Para telefones, usar modo externo diretamente
      if (uri.scheme == 'tel' || uri.scheme == 'sms') {
        debugPrint('🔗 Tentando abrir telefone/SMS');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          debugPrint('✅ Telefone/SMS aberto com sucesso');
          return true;
        } else {
          debugPrint('❌ Não foi possível verificar se o telefone/SMS pode ser aberto');
          return false;
        }
      }
      
      // Para emails, usar modo externo
      if (uri.scheme == 'mailto') {
        debugPrint('🔗 Tentando abrir email');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          debugPrint('✅ Email aberto com sucesso');
          return true;
        } else {
          debugPrint('❌ Não foi possível verificar se o email pode ser aberto');
          return false;
        }
      }
      
      // Para URLs web, tentar diferentes modos
      debugPrint('🔗 Verificando se a URL pode ser aberta...');
      if (await canLaunchUrl(uri)) {
        debugPrint('✅ URL pode ser aberta, tentando diferentes modos...');
        
        // Lista de modos para tentar
        final modos = [
          LaunchMode.externalApplication,
          LaunchMode.inAppBrowserView,
          LaunchMode.platformDefault,
        ];
        
        for (int i = 0; i < modos.length; i++) {
          final modo = modos[i];
          try {
            debugPrint('🔗 Tentativa ${i + 1}: ${modo.toString()}');
            await launchUrl(uri, mode: modo);
            debugPrint('✅ Link aberto com sucesso no modo: ${modo.toString()}');
            return true;
          } catch (e) {
            debugPrint('❌ Falha no modo ${modo.toString()}: $e');
            if (i == modos.length - 1) {
              // Se é a última tentativa, mostrar erro
              debugPrint('❌ Todas as tentativas falharam');
            }
          }
        }
      } else {
        debugPrint('❌ canLaunchUrl retornou false para: $url');
      }
      
      if (context != null) {
        _mostrarErroLink(context, url);
      }
      
      return false;
    } catch (e) {
      debugPrint('💥 Erro ao processar URL "$url": $e');
      if (context != null) {
        _mostrarErroLink(context, url);
      }
      return false;
    }
  }
  
  /// Mostra uma mensagem de erro quando não é possível abrir o link
  static void _mostrarErroLink(BuildContext context, String url) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Não foi possível abrir o link: ${Uri.tryParse(url)?.host ?? url}'),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
  
  /// Abre um telefone
  static Future<bool> abrirTelefone(String telefone, {BuildContext? context}) async {
    // Limpar formatação do telefone
    final telefoneNormalizado = telefone.replaceAll(RegExp(r'[^\d+]'), '');
    return await abrirUrl('tel:$telefoneNormalizado', context: context);
  }
  
  /// Abre um email
  static Future<bool> abrirEmail(String email, {String? assunto, String? corpo, BuildContext? context}) async {
    String url = 'mailto:$email';
    
    final params = <String>[];
    if (assunto != null) params.add('subject=${Uri.encodeComponent(assunto)}');
    if (corpo != null) params.add('body=${Uri.encodeComponent(corpo)}');
    
    if (params.isNotEmpty) {
      url += '?${params.join('&')}';
    }
    
    return await abrirUrl(url, context: context);
  }
  
  /// Abre WhatsApp
  static Future<bool> abrirWhatsApp(String telefone, {String? mensagem, BuildContext? context}) async {
    // Limpar formatação do telefone (remove tudo exceto dígitos)
    var telefoneNormalizado = telefone.replaceAll(RegExp(r'[^\d]'), '');

    // Adicionar código do país Brasil (55) se não estiver presente.
    // Números brasileiros sem código: 10 dígitos (fixo) ou 11 dígitos (celular).
    if (telefoneNormalizado.length <= 11) {
      telefoneNormalizado = '55$telefoneNormalizado';
    }

    String url = 'https://wa.me/$telefoneNormalizado';
    
    if (mensagem != null) {
      url += '?text=${Uri.encodeComponent(mensagem)}';
    }
    
    return await abrirUrl(url, context: context);
  }
  
  /// Abre localização no Google Maps
  static Future<bool> abrirMapa(String endereco, {BuildContext? context}) async {
    final enderecoEncodado = Uri.encodeComponent(endereco);
    return await abrirUrl('https://maps.google.com/?q=$enderecoEncodado', context: context);
  }
}
