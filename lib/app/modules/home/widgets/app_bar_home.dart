import 'package:flutter/material.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';

class AppBarHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaTela = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          SizedBox(height: 8), // Pequeno espaçamento superior
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Color.fromARGB(0, 120, 32, 80),
                width: larguraTela * 0.69,
                height: alturaTela * 0.18,
                child: FittedBox(
                  child: Container(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      "Paróquia \nSão Lourenço",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'CinzelDecorative',
                          fontSize: 28),
                    ),
                  ),
                ),
              ),
              Container(
                color: Color.fromARGB(0, 120, 132, 180),
                width: larguraTela * 0.31,
                height: alturaTela * 0.15,
                child: Image.asset(tercoBranco),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
