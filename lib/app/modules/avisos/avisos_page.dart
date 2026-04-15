import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/avisos/widgets/aviso_card.dart';
import 'package:paroquia_sao_lourenco/app/shared/config/api_config.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';
import 'package:paroquia_sao_lourenco/app/shared/services/strapi_client.dart';

class AvisosPage extends StatefulWidget {
  final String title;
  const AvisosPage({Key? key, this.title = "Avisos Paroquiais"})
      : super(key: key);

  @override
  State<AvisosPage> createState() => _AvisosPageState();
}

class _AvisosPageState extends State<AvisosPage> {
  late final Future<List<Map<String, dynamic>>> _avisosFuture;

  @override
  void initState() {
    super.initState();
    _avisosFuture = _carregarAvisos();
  }

  Future<List<Map<String, dynamic>>> _carregarAvisos() async {
    final client = Modular.get<StrapiClient>();
    final response = await client.get(
      ApiConfig.avisos,
      queryParameters: {
        'sort': 'data:desc',
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
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(bg), fit: BoxFit.cover)),
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
                      children: snapshot.data!.map((item) {
                        return AvisoCard(data: item);
                      }).toList(),
                    );
                  }
                },
              )),
        ));
  }
}
