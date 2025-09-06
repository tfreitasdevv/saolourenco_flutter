import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paroquia_sao_lourenco/app/modules/sobre/tabs/clero.dart';
import 'package:paroquia_sao_lourenco/app/modules/sobre/tabs/historia.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';

class SobrePage extends StatefulWidget {
  final String title;
  const SobrePage({Key? key, this.title = "Sobre a Paróquia"}) : super(key: key);

  @override
  _SobrePageState createState() => _SobrePageState();
}

class _SobrePageState extends State<SobrePage> {
  
  @override
  void initState() {
    super.initState();
    // Configurar a cor da barra de navegação do sistema como t2
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: t2, // Define a cor t2 para a barra de navegação
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: t2,
          title: Text(widget.title),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
            Tab(
              child: Text("História", textAlign: TextAlign.center),
            ),
            Tab(
              child: Text("Clero", textAlign: TextAlign.center),
            ),
          ]),
        ),
        body: TabBarView(children: [Historia(), Clero()]),
      ),
    );
  }
}
