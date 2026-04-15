import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/como_ajudar/widgets/como_ajudar_card.dart';
import 'package:paroquia_sao_lourenco/app/shared/config/api_config.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';
import 'package:paroquia_sao_lourenco/app/shared/services/strapi_client.dart';

class ComoAjudarPage extends StatefulWidget {
  final String title;
  const ComoAjudarPage({Key? key, this.title = "Como Ajudar"})
      : super(key: key);

  @override
  State<ComoAjudarPage> createState() => _ComoAjudarPageState();
}

class _ComoAjudarPageState extends State<ComoAjudarPage> {
  late final Future<List<Map<String, dynamic>>> _comoAjudarFuture;

  @override
  void initState() {
    super.initState();
    _comoAjudarFuture = _carregarComoAjudar();
  }

  Future<List<Map<String, dynamic>>> _carregarComoAjudar() async {
    final client = Modular.get<StrapiClient>();
    final response = await client.get(
      ApiConfig.comoAjudar,
      queryParameters: {
        'sort': 'ordem:asc',
        'populate': 'imagem',
      },
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(bg), fit: BoxFit.cover),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _comoAjudarFuture,
          builder: (context, snapshot) {
            // Carregando
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              );
            }

            // Erro ao carregar
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    "Erro ao carregar os dados. Tente novamente mais tarde.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              );
            }

            final items = snapshot.data ?? [];

            // Sem documentos cadastrados - empty state
            if (items.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.volunteer_activism,
                            size: 64,
                            color: t4,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Para saber como doar nas pastorais e movimentos da "
                            "paróquia, procure a Secretaria Paroquial ou visite "
                            "a seção de Pastorais e Movimentos no aplicativo",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: t3,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            // Lista de cards
            return ListView(
              addAutomaticKeepAlives: true,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 100),
              children: items.map((item) {
                return ComoAjudarCard(data: item);
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
