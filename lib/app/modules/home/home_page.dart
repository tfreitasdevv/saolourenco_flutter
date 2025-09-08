import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/home/widgets/app_bar_home.dart';
import 'package:paroquia_sao_lourenco/app/modules/home/widgets/button_home.dart';
import 'package:paroquia_sao_lourenco/app/modules/home/widgets/icons_home.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared/auth/local_user.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = "Home"}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //use 'controller' variable to access controller
  final localUser = Modular.get<LocalUser>();

  @override
  void initState() {
    super.initState();
    bool web = kIsWeb;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setEnabledSystemUIMode(
        web == false ? SystemUiMode.edgeToEdge : SystemUiMode.edgeToEdge);
    // Tornar a barra de status transparente
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    bool web = kIsWeb;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: t2,
            image: DecorationImage(image: AssetImage(bg), fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AppBarHome(),
              SizedBox(height: alturaTela * 0.008333),
              Expanded(child: _buildListaBotoes(alturaTela)),
              SizedBox(height: alturaTela * 0.008333),
              _buildIconesBottom(alturaTela, web),
              SizedBox(height: 8), // Espaçamento inferior adicional
            ],
          ),
        ),
      ),
    );
  }

  Container _buildIconesBottom(double alturaTela, bool web) {
    return Container(
      height: alturaTela * 0.08,
      padding: EdgeInsets.symmetric(vertical: 8), // Adiciona padding interno
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconsHome(
              icone: instagram,
              funcao: () {
                _instagram();
              },
              web: web),
          IconsHome(
              icone: youtube,
              funcao: () {
                _youtube();
              },
              web: web),
          IconsHome(
              icone: telefone,
              funcao: () {
                _telefone();
              },
              web: web),
          IconsHome(
              icone: mapa,
              funcao: () {
                _map();
              },
              web: web),
        ],
      ),
    );
  }

  void _instagram() async {
    final Uri url = Uri.parse("https://www.instagram.com/paroquia_sl_nit/");
    await launchUrl(url);
  }

  void _telefone() async {
    final Uri url = Uri.parse("tel:02126215742");
    await launchUrl(url);
  }

  void _map() async {
    final Uri url = Uri.parse("https://maps.app.goo.gl/3KzX2KxvfMrD3fQy8");
    await launchUrl(url);
  }

  void _youtube() async {
    final Uri url = Uri.parse("https://www.youtube.com/channel/UCl7QjDbKSR5CXQE732ihoRg");
    await launchUrl(url);
  }

  void _cnbb() async {
    final Uri url = Uri.parse("https://www.cnbb.org.br/liturgia-diaria/");
    await launchUrl(url);
  }

  Widget _buildListaBotoes(double alturaTela) {
    double _alturaSizedBox = MediaQuery.of(context).size.width > 400
        ? alturaTela * 0.6 * 0.03
        : alturaTela * 0.3 * 0.03;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ButtonHome(
            texto: "Pastorais e Movimentos",
            funcao: () {
              Modular.to.pushNamed('/pastorais');
            },
          ),
          SizedBox(
            height: _alturaSizedBox,
          ),
          ButtonHome(
            texto: "Avisos Paroquiais",
            funcao: () {
              Modular.to.pushNamed('/avisos');
            },
          ),
          SizedBox(
            height: _alturaSizedBox,
          ),
          ButtonHome(
            texto: "Eventos",
            funcao: () {
              Modular.to.pushNamed('/eventos');
            },
          ),
          SizedBox(
            height: _alturaSizedBox,
          ),
          ButtonHome(
            texto: "Horários das Missas",
            funcao: () {
              Modular.to.pushNamed('/horarios');
            },
          ),
          SizedBox(height: _alturaSizedBox),
          ButtonHome(
            texto: "Confissões",
            funcao: () {
              Modular.to.pushNamed('/confissoes');
            },
          ),
          SizedBox(height: _alturaSizedBox),
          ButtonHome(
            texto: "Sobre a Paróquia",
            funcao: () {
              Modular.to.pushNamed('/sobre');
            },
          ),
          SizedBox(height: _alturaSizedBox),
          ButtonHome(
            texto: "Capelas",
            funcao: () {
              Modular.to.pushNamed('/capelas');
            },
          ),
          SizedBox(height: _alturaSizedBox),
          ButtonHome(
            texto: "Liturgia Diária (CNBB)",
            funcao: () {
              _cnbb();
            },
          ),
          SizedBox(height: 16), // Espaçamento final para o scroll
        ],
      ),
    );
  }
}
