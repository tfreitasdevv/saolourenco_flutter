import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/shared/config/api_config.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';
import 'package:paroquia_sao_lourenco/app/shared/services/strapi_client.dart';

class Clero extends StatefulWidget {
  @override
  State<Clero> createState() => _CleroState();
}

class _CleroState extends State<Clero> {
  late final Future<Map<String, dynamic>> _cleroFuture;

  @override
  void initState() {
    super.initState();
    final strapi = Modular.get<StrapiClient>();
    _cleroFuture = strapi
        .get(ApiConfig.cleros,
            queryParameters: {
              'filters[funcao][\$eq]': 'paroco',
              'populate': 'imagem',
            })
        .then((r) {
      final lista = List<Map<String, dynamic>>.from(r.data['data'] ?? []);
      if (lista.isEmpty) throw Exception('Clero não encontrado');
      return lista.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(bg), fit: BoxFit.cover)),
        child: FutureBuilder<Map<String, dynamic>>(
            future: _cleroFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                    child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ));
              } else {
                final data = snapshot.data!;
                String _historia = data['historia'] ?? '';
                String _historiaF = _historia.replaceAll("\\n", "\n");
                final imagem = data['imagem'];
                final imagemUrl = imagem is Map ? imagem['url'] ?? '' : '';
                return SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: MediaQuery.of(context).padding.bottom + 16,
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            "Pároco",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'CinzelDecorative',
                                fontSize:
                                    MediaQuery.of(context).size.width > 400
                                        ? 32
                                        : 24),
                          ),
                        ),
                        SizedBox(height: 16),
                        if (imagemUrl.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              imagemUrl,
                              height: MediaQuery.of(context).size.width / 2,
                            ),
                          ),
                        SizedBox(height: 8),
                        Container(
                          child: Text(
                            data['nome'] ?? '',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width > 400
                                        ? 24
                                        : 18),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Data de ordenação: ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width > 400
                                            ? 20
                                            : 14),
                              ),
                              Text(
                                data['data_ordenacao'] ?? '',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width > 400
                                            ? 20
                                            : 16),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          child: Text(
                            _historiaF,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width > 400
                                        ? 18
                                        : 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }));
  }
}
