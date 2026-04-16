import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/auth/local_user.dart';
import '../../shared/constants/constants.dart';
import '../../shared/widgets/acesso_membros_button.dart';
import '../../shared/widgets/pastoral_page.dart';

class MusicaPage extends StatelessWidget {
  final String title;
  const MusicaPage({Key? key, this.title = "Pastoral da Música"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localUser = Modular.get<LocalUser>();

    return PastoralPage(
      title: title,
      documentId: 'musica',
      bottomWidget: Center(
        child: AcessoMembrosButton(funcao: () {
          if (!localUser.isLoggedIn()) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return PopScope(
                  canPop: false,
                  child: AlertDialog(
                    scrollable: true,
                    titleTextStyle: TextStyle(
                      color: t1,
                      fontWeight: FontWeight.bold,
                      fontSize:
                          MediaQuery.of(context).size.width > 400 ? 20 : 18,
                    ),
                    elevation: 8,
                    contentTextStyle: TextStyle(
                      color: t1,
                      fontSize:
                          MediaQuery.of(context).size.width > 400 ? 16 : 14,
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Modular.to.pushReplacementNamed('/login',
                              arguments: {
                                'redirectTo': '/musica/membros_musica'
                              });
                        },
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            color: t1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Modular.to.pushReplacementNamed('/signup');
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "CRIAR USUÁRIO",
                          style: TextStyle(
                            color: t1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "VOLTAR",
                          style: TextStyle(
                            color: t1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    title: Text(
                      "ACESSO RESTRITO A MEMBROS CADASTRADOS",
                      textAlign: TextAlign.center,
                    ),
                    content: Text(
                      "Esta área é de acesso restrito a membros cadastrados no aplicativo.\n\nCaso você já possua cadastro, basta fazer o Login.\n\nCaso você ainda não possua, basta criar o seu cadastro.",
                    ),
                  ),
                );
              },
            );
          } else {
            Modular.to.pushNamed('/musica/membros_musica');
          }
        }),
      ),
    );
  }
}
