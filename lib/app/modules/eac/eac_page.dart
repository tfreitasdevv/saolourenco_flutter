import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared/constants/constants.dart';

class EacPage extends StatefulWidget {
  final String title;
  const EacPage({Key? key, this.title = "EAC"})
      : super(key: key);

  @override
  _EacPageState createState() => _EacPageState();
}

class _EacPageState extends State<EacPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: t2,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(bg), fit: BoxFit.cover)),
        child: SafeArea(
          child: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('conteudo_pagina_pastoral')
                  .doc('eac')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                String contato = snapshot.data!["contato"];
                String contatoF = contato.replaceAll("\\n", "\n");
                String texto = snapshot.data!["texto"];
                String textoF = texto.replaceAll("\\n", "\n");
                return Container(
                  padding: EdgeInsets.all(28),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          textoF,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width > 400
                                  ? 18
                                  : 16,
                              color: Colors.white),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(height: 22),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Coordenação",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width > 400
                                          ? 22
                                          : 20,
                                  color: Colors.white),
                            ),
                            Text(
                              snapshot.data!["coordenacao"],
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 400
                                          ? 18
                                          : 16,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Contato",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width > 400
                                          ? 22
                                          : 20,
                                  color: Colors.white),
                            ),
                            Text(
                              contatoF,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 400
                                          ? 18
                                          : 16,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 22),
                    ],
                  ),
                );
              }),
          ),
        ),
      ),
    );
  }
}
