import 'package:flutter/material.dart';
import 'package:paroquia_sao_lourenco/app/modules/musica/models/escala_musica_sabado_model.dart';
import 'package:paroquia_sao_lourenco/app/modules/musica/repositories/escala_musica_repository.dart';

import '../../../../shared/constants/constants.dart';

class EscalaMusicaSabadoPage extends StatefulWidget {
  final EscalaMusicaRepository repository;

  const EscalaMusicaSabadoPage({Key? key, required this.repository}) : super(key: key);

  @override
  _EscalaMusicaSabadoPageState createState() => _EscalaMusicaSabadoPageState();
}

class _EscalaMusicaSabadoPageState extends State<EscalaMusicaSabadoPage>
    with AutomaticKeepAliveClientMixin<EscalaMusicaSabadoPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Container(
        color: t2,
        child: Column(
          children: <Widget>[
            _buildEscalaSabadoCorrente(),
            _buildEscalaSabadoProximo()
          ],
        ),
      ),
    );
  }

  FutureBuilder<EscalaMusicaSabadoModel> _buildEscalaSabadoCorrente() {
    return FutureBuilder<EscalaMusicaSabadoModel>(
      future: widget.repository.obterEscalaSabadoMesCorrente(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white)),
            ),
          );
        } else {
          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 6),
                  color: t6,
                  child: Text(data.mes,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CinzelDecorative')),
                ),
                _buildListaMissa1(data),
                _buildListaMissa2(data),
                _buildListaMissa3(data),
                _buildListaMissa4(data),
                data.quantidadeSabados > 4
                    ? _buildListaMissa5(data)
                    : Container(),
              ],
            ),
          );
        }
      },
    );
  }

  FutureBuilder<EscalaMusicaSabadoModel> _buildEscalaSabadoProximo() {
    return FutureBuilder<EscalaMusicaSabadoModel>(
      future: widget.repository.obterEscalaSabadoMesProximo(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Container();
        } else {
          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 6),
                  color: t6,
                  child: Text(data.mes,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CinzelDecorative')),
                ),
                _buildListaMissa1(data),
                _buildListaMissa2(data),
                _buildListaMissa3(data),
                _buildListaMissa4(data),
                data.quantidadeSabados > 4
                    ? _buildListaMissa5(data)
                    : Container(),
              ],
            ),
          );
        }
      },
    );
  }

  ListView _buildListaMissa1(EscalaMusicaSabadoModel data) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      addAutomaticKeepAlives: true,
      shrinkWrap: true,
      children: <Widget>[
        _buildListTileData(data.dataMissa1),
        _buildListTileItems2(data.horarioH1M1, data.grupoH1M1),
      ],
    );
  }

  ListView _buildListaMissa2(EscalaMusicaSabadoModel data) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      addAutomaticKeepAlives: true,
      shrinkWrap: true,
      children: <Widget>[
        _buildListTileData(data.dataMissa2),
        _buildListTileItems2(data.horarioH1M2, data.grupoH1M2),
      ],
    );
  }

  ListView _buildListaMissa3(EscalaMusicaSabadoModel data) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      addAutomaticKeepAlives: true,
      shrinkWrap: true,
      children: <Widget>[
        _buildListTileData(data.dataMissa3),
        _buildListTileItems2(data.horarioH1M3, data.grupoH1M3),
      ],
    );
  }

  ListView _buildListaMissa4(EscalaMusicaSabadoModel data) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      addAutomaticKeepAlives: true,
      shrinkWrap: true,
      children: <Widget>[
        _buildListTileData(data.dataMissa4),
        _buildListTileItems2(data.horarioH1M4, data.grupoH1M4),
      ],
    );
  }

  ListView _buildListaMissa5(EscalaMusicaSabadoModel data) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      addAutomaticKeepAlives: true,
      shrinkWrap: true,
      children: <Widget>[
        _buildListTileData(data.dataMissa5),
        _buildListTileItems2(data.horarioH1M5, data.grupoH1M5),
      ],
    );
  }

  Widget _buildListTileData(String data) {
    return Container(
      padding: EdgeInsets.only(bottom: 12, top: 12),
      child: ListTile(
        dense: true,
        leading: Icon(
          Icons.date_range,
          color: Colors.white,
          size: 30,
        ),
        title: Text(data,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildListTileItems2(String horario, String grupo) {
    return Container(
      padding: EdgeInsets.only(left: 32, bottom: 8),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.access_time,
            color: Colors.white,
            size: 20,
          ),
          SizedBox(width: 16),
          Text(horario, style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(width: 8),
          Text("-", style: TextStyle(color: Colors.white)),
          SizedBox(width: 8),
          Flexible(
            child: Text(grupo,
                style: TextStyle(color: Colors.white, fontSize: 16)),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}