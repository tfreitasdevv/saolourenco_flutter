import 'package:flutter/material.dart';
import 'package:paroquia_sao_lourenco/app/modules/musica/repositories/escala_musica_repository.dart';

import '../../../../shared/constants/constants.dart';
import '../../models/escala_musica_domingo_model.dart';

class EscalaMusicaPage extends StatefulWidget {
  final EscalaMusicaRepository repository;

  const EscalaMusicaPage({Key? key, required this.repository}) : super(key: key);

  @override
  _EscalaMusicaPageState createState() => _EscalaMusicaPageState();
}

class _EscalaMusicaPageState extends State<EscalaMusicaPage>
    with AutomaticKeepAliveClientMixin<EscalaMusicaPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Container(
        color: t2,
        child: Column(
          children: <Widget>[
            _buildEscalaDomingoCorrente(),
            _buildEscalaDomingoProximo()
          ],
        ),
      ),
    );
  }

  FutureBuilder<EscalaMusicaDomingoModel> _buildEscalaDomingoCorrente() {
    return FutureBuilder<EscalaMusicaDomingoModel>(
      future: widget.repository.obterEscalaDomingoMesCorrente(),
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
                data.quantidadeDomingos > 4
                    ? _buildListaMissa5(data)
                    : Container(),
              ],
            ),
          );
        }
      },
    );
  }

  FutureBuilder<EscalaMusicaDomingoModel> _buildEscalaDomingoProximo() {
    return FutureBuilder<EscalaMusicaDomingoModel>(
      future: widget.repository.obterEscalaDomingoMesProximo(),
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
                data.quantidadeDomingos > 4
                    ? _buildListaMissa5(data)
                    : Container(),
              ],
            ),
          );
        }
      },
    );
  }

  ListView _buildListaMissa1(EscalaMusicaDomingoModel data) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      addAutomaticKeepAlives: true,
      shrinkWrap: true,
      children: <Widget>[
        _buildListTileData(data.dataMissa1),
        _buildListTileItems2(data.horarioH1M1, data.grupoH1M1),
        _buildListTileItems2(data.horarioH2M1, data.grupoH2M1),
        _buildListTileItems2(data.horarioH3M1, data.grupoH3M1),
      ],
    );
  }

  ListView _buildListaMissa2(EscalaMusicaDomingoModel data) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      addAutomaticKeepAlives: true,
      shrinkWrap: true,
      children: <Widget>[
        _buildListTileData(data.dataMissa2),
        _buildListTileItems2(data.horarioH1M2, data.grupoH1M2),
        _buildListTileItems2(data.horarioH2M2, data.grupoH2M2),
        _buildListTileItems2(data.horarioH3M2, data.grupoH3M2),
      ],
    );
  }

  ListView _buildListaMissa3(EscalaMusicaDomingoModel data) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      addAutomaticKeepAlives: true,
      shrinkWrap: true,
      children: <Widget>[
        _buildListTileData(data.dataMissa3),
        _buildListTileItems2(data.horarioH1M3, data.grupoH1M3),
        _buildListTileItems2(data.horarioH2M3, data.grupoH2M3),
        _buildListTileItems2(data.horarioH3M3, data.grupoH3M3),
      ],
    );
  }

  ListView _buildListaMissa4(EscalaMusicaDomingoModel data) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      addAutomaticKeepAlives: true,
      shrinkWrap: true,
      children: <Widget>[
        _buildListTileData(data.dataMissa4),
        _buildListTileItems2(data.horarioH1M4, data.grupoH1M4),
        _buildListTileItems2(data.horarioH2M4, data.grupoH2M4),
        _buildListTileItems2(data.horarioH3M4, data.grupoH3M4),
      ],
    );
  }

  ListView _buildListaMissa5(EscalaMusicaDomingoModel data) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      addAutomaticKeepAlives: true,
      shrinkWrap: true,
      children: <Widget>[
        _buildListTileData(data.dataMissa5),
        _buildListTileItems2(data.horarioH1M5, data.grupoH1M5),
        _buildListTileItems2(data.horarioH2M5, data.grupoH2M5),
        _buildListTileItems2(data.horarioH3M5, data.grupoH3M5),
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