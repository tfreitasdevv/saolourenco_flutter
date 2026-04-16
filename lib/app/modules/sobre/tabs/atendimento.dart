import 'package:flutter/material.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';
import 'package:paroquia_sao_lourenco/app/shared/utils/url_launcher_utils.dart';

/// Aba de contato da paróquia
class Atendimento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(bg), fit: BoxFit.cover),
      ),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 32,
            bottom: MediaQuery.of(context).padding.bottom + 16,
          ),
          children: [
            // Título da seção
            Text(
              "Atendimento na Secretaria",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'CinzelDecorative',
                fontSize: MediaQuery.of(context).size.width > 400 ? 24 : 20,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),

            // Horários de atendimento
            _buildCardInfo(
              icone: Icons.access_time,
              titulo: "Horários",
              topicos: [
                "De terça a sexta, de 8h às 12h e 13h30 às 17h.",
                "Aos sábados de 8h às 12h.",
              ],
            ),
            SizedBox(height: 16),

            // Telefone
            _buildCardAcao(
              context: context,
              icone: Icons.phone,
              titulo: "Telefone",
              conteudo: "(21) 2621-5742",
              onTap: () {
                UrlLauncherUtils.abrirTelefone("02126215742", context: context);
              },
            ),
            SizedBox(height: 16),

            // WhatsApp
            _buildCardAcao(
              context: context,
              iconeWidget: Image.asset(
                whatsapp,
                width: 28,
                height: 28,
                color: t5,
              ),
              titulo: "WhatsApp",
              conteudo: "(21) 2621-5742",
              onTap: () {
                UrlLauncherUtils.abrirWhatsApp("552126215742",
                    context: context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Card informativo sem ação de toque
  Widget _buildCardInfo({
    required IconData icone,
    required String titulo,
    required List<String> topicos,
  }) {
    return Card(
      color: t2.withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icone, color: t5, size: 28),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  ...topicos.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("• ", style: TextStyle(color: Colors.white70, fontSize: 16)),
                            Expanded(
                              child: Text(
                                item,
                                style: TextStyle(color: Colors.white70, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Card com ação de toque (telefone, whatsapp)
  Widget _buildCardAcao({
    required BuildContext context,
    IconData? icone,
    Widget? iconeWidget,
    required String titulo,
    required String conteudo,
    required VoidCallback onTap,
  }) {
    return Card(
      color: t2.withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              iconeWidget ?? Icon(icone, color: t5, size: 28),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      conteudo,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}
