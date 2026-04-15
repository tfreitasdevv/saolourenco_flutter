import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/horarios/widgets/horario_tile.dart';
import 'package:paroquia_sao_lourenco/app/shared/config/api_config.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';
import 'package:paroquia_sao_lourenco/app/shared/services/strapi_client.dart';

class HorariosPage extends StatefulWidget {
  final String title;
  const HorariosPage({Key? key, this.title = "Horários das Missas"})
      : super(key: key);

  @override
  State<HorariosPage> createState() => _HorariosPageState();
}

class _HorariosPageState extends State<HorariosPage> {
  late final Future<List<Map<String, dynamic>>> _horariosFuture;

  @override
  void initState() {
    super.initState();
    _horariosFuture = _carregarHorarios();
  }

  Future<List<Map<String, dynamic>>> _carregarHorarios() async {
    final client = Modular.get<StrapiClient>();
    final response = await client.get(
      ApiConfig.horariosMissa,
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
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(bg), fit: BoxFit.cover)),
      child: SafeArea(
        child: _buildScrollView(context),
      ),
    );
  }

  SingleChildScrollView _buildScrollView(BuildContext context) {
    return SingleChildScrollView(
        child: FutureBuilder<List<Map<String, dynamic>>>(
      future: _horariosFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ));
        } else {
          return Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: snapshot.data!.map((item) {
                final List missas = item["missas"] ?? [];
                return Column(
                  children: <Widget>[
                    SizedBox(height: 8),
                    Text(
                      item["titulo"] ?? '',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              MediaQuery.of(context).size.width < 400 ? 18 : 22,
                          fontFamily: 'CinzelDecorative'),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      addAutomaticKeepAlives: true,
                      shrinkWrap: true,
                      itemCount: missas.length,
                      itemBuilder: (context, index) {
                        return HorarioTile(horario: missas[index].toString());
                      },
                    ),
                    SizedBox(height: 30)
                  ],
                );
              }).toList(),
            ),
          );
        }
      },
    ));
  }
}
