import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared/constants/constants.dart';
import '../../shared/widgets/rich_text_markdown.dart';

class EacPage extends StatefulWidget {
  final String title;
  const EacPage({Key? key, this.title = "EAC"}) : super(key: key);

  @override
  _EacPageState createState() => _EacPageState();
}

class _EacPageState extends State<EacPage> {
  /// Extrai as seções do documento Firebase e ordena pelo campo "ordem"
  List<Map<String, dynamic>> _extrairSecoes(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>? ?? {};
    final secoes = <Map<String, dynamic>>[];

    for (final entry in data.entries) {
      if (entry.value is Map) {
        final map = entry.value as Map<String, dynamic>;
        secoes.add({
          'titulo': entry.key,
          'texto': (map['texto'] ?? '').toString(),
          'ordem': (map['ordem'] ?? 999) is int
              ? map['ordem']
              : int.tryParse(map['ordem'].toString()) ?? 999,
        });
      }
    }

    secoes.sort((a, b) => (a['ordem'] as int).compareTo(b['ordem'] as int));
    return secoes;
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 400;

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

                final secoes = _extrairSecoes(snapshot.data!);

                if (secoes.isEmpty) {
                  return Container(
                    padding: EdgeInsets.all(28),
                    child: Center(
                      child: Text(
                        'Nenhum conteúdo disponível.',
                        style: TextStyle(
                          fontSize: isWide ? 18 : 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }

                return Container(
                  padding: EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < secoes.length; i++) ...[
                        if (secoes[i]['titulo'] != '_') ...[
                          Text(
                            secoes[i]['titulo'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isWide ? 22 : 20,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                        RichTextMarkdown(
                          markdownText: secoes[i]['texto'],
                          fontSize: isWide ? 18 : 16,
                          textColor: Colors.white,
                          textAlign: TextAlign.justify,
                        ),
                        if (i < secoes.length - 1) SizedBox(height: 22),
                      ],
                      SizedBox(height: 22),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
