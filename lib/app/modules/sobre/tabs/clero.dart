import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';

class Clero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(bg), fit: BoxFit.cover)),
        child: FutureBuilder<DocumentSnapshot>(
            future:
                FirebaseFirestore.instance.collection('clero').doc('paroco').get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                    child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ));
              } else {
                String _historia = snapshot.data!['historia'];
                String _historiaF = _historia.replaceAll("\\n", "\n");
                return SafeArea(
                  child: SingleChildScrollView(
                    // Adiciona padding inferior para evitar sobreposição com a barra de navegação
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            snapshot.data!['imagem'],
                            height: MediaQuery.of(context).size.width / 2,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          child: Text(
                            snapshot.data!['nome'],
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
                                snapshot.data!['data_ordenacao'],
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
