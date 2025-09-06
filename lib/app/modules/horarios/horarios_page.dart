import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paroquia_sao_lourenco/app/modules/horarios/widgets/horario_tile.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';

class HorariosPage extends StatefulWidget {
  final String title;
  const HorariosPage({Key? key, this.title = "Horários das Missas"})
      : super(key: key);

  @override
  State<HorariosPage> createState() => _HorariosPageState();
}

class _HorariosPageState extends State<HorariosPage> {
  //use 'controller' variable to access controller

  bool web = kIsWeb;

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
        child: FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('horarios_missas')
          .orderBy('ordem')
          .get(),
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
              children: snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>?;
                List missas = data?["missas"] ?? [];
                return Column(
                  children: <Widget>[
                    SizedBox(height: 8),
                    Text(
                      doc["titulo"],
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
                        return HorarioTile(horario: missas[index]);
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
