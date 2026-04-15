import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/musica/widgets/aviso_musica_card.dart';
import 'package:paroquia_sao_lourenco/app/shared/config/api_config.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';
import 'package:paroquia_sao_lourenco/app/shared/services/strapi_client.dart';

class AvisosMusicaPage extends StatefulWidget {
  @override
  _AvisosMusicaPageState createState() => _AvisosMusicaPageState();
}

class _AvisosMusicaPageState extends State<AvisosMusicaPage> {
  late final Future<List<Map<String, dynamic>>> _avisosFuture;

  @override
  void initState() {
    super.initState();
    final strapi = Modular.get<StrapiClient>();
    _avisosFuture = strapi
        .get(ApiConfig.avisosMusica,
            queryParameters: {'sort': 'data:desc'})
        .then((r) => List<Map<String, dynamic>>.from(r.data['data'] ?? []));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: t2,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _avisosFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white)));
                  } else {
                    return ListView(
                      addAutomaticKeepAlives: true,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 100),
                      children: (snapshot.data ?? []).map((item) {
                        return AvisoMusicaCard(data: item);
                      }).toList(),
                    );
                  }
                },
              )),
        ));
  }
}
