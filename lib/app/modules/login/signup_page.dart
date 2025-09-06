import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:paroquia_sao_lourenco/app/shared/auth/auth_repository.dart';
import 'package:paroquia_sao_lourenco/app/shared/constants/constants.dart';
import '../../shared/auth/local_user.dart';

class SignupPage extends StatefulWidget {
  final String title;
  const SignupPage({Key? key, this.title = "Criar usuário"}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final firebase = FirebaseFirestore.instance;
  final localUser = Modular.get<LocalUser>();
  final authRepo = Modular.get<AuthRepository>();
  final TextInputFormatter mascaraCelular = MaskTextInputFormatter(
      mask: '(##) # ####-####', filter: {'#': RegExp(r'[0-9]')});
  final TextInputFormatter mascaraData = MaskTextInputFormatter(
      mask: '##/##/####', filter: {'#': RegExp(r'[0-9]')});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _nascimentoController = TextEditingController();
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  String? _estadoController;
  String? _sexoController;

  @override
  Widget build(BuildContext context) {
    final double espacos = MediaQuery.of(context).size.width > 400 ? 12 : 10;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: t1,
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(bg), fit: BoxFit.cover)),
              child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Theme(
                  data: Theme.of(context).copyWith(
                      primaryColor: Colors.white, hintColor: Colors.white),
                  child: Column(
                    children: <Widget>[
                      _buildRotulo("Dados pessoais"),
                      _buildTextFormField(
                          texto: "Nome",
                          onChanged: (value) {
                            _nomeController.text = value;
                          },
                          controllerCampo: _nomeController,
                          tipoTeclado: TextInputType.text,
                          autofillHints: [AutofillHints.name],
                          textInputAction: TextInputAction.next,
                          validacao: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Campo obrigatório";
                            } else if (value.length < 5) {
                              return "Nome deve conter pelo menos 6 caracteres";
                            }
                            return null;
                          },
                          obscure: false),
                      SizedBox(height: espacos),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width * 0.63,
                              child: _buildTextFormField(
                                  texto: "Nascimento",
                                  onChanged: (value) {
                                    _nascimentoController.text = value;
                                  },
                                  controllerCampo: _nascimentoController,
                                  tipoTeclado: TextInputType.datetime,
                                  mascara: [mascaraData],
                                  onTap: null,
                                  validacao: (String? value) {
                                    DateTime max = DateTime(2020);
                                    DateTime min = DateTime(1900);
                                    if (value == null || value.isEmpty) {
                                      return "Campo obrigatório";
                                    }
                                    DateTime? aux;
                                    try {
                                      aux = DateFormat("dd/MM/yyyy").parseStrict(value);
                                    } catch (_) {
                                      return "Data inválida - dd/mm/yyyy";
                                    }
                                    String toOriginalFormatString(DateTime dateTime) {
                                      final d = dateTime.day.toString().padLeft(2, '0');
                                      final m = dateTime.month.toString().padLeft(2, '0');
                                      final y = dateTime.year.toString().padLeft(4, '0');
                                      return "$d/$m/$y";
                                    }
                                    bool isValidDate(String input) {
                                      final originalFormatString = toOriginalFormatString(aux!);
                                      return input == originalFormatString;
                                    }
                                    bool validacaoDataPossivel = isValidDate(value);
                                    if (aux.isAfter(max) || aux.isBefore(min)) {
                                      return "Data inválida - dd/mm/yyyy";
                                    } else if (!validacaoDataPossivel) {
                                      return "Data inválida - dd/mm/yyyy";
                                    }
                                    return null;
                                  },
                                  obscure: false)),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.29,
                              child: _buildDropdown(
                                  context: context,
                                  fatorTela: 0.37,
                                  itens: <String>['F', 'M'],
                                  titulo: "Sexo",
                                  onChanged: (value) {
                                    setState(() {
                                      _sexoController = value;
                                    });
                                  },
                                  validacao: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Campo obrigatório";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _sexoController = value;
                                  }))
                        ],
                      ),
                      SizedBox(height: espacos * 2.5),
                      _buildRotulo("Dados de contato e informações para Login"),
                      _buildTextFormField(
                          texto: "E-mail",
                          onChanged: (value) {
                            _emailController.text = value;
                          },
                          controllerCampo: _emailController,
                          tipoTeclado: TextInputType.emailAddress,
                          autofillHints: [AutofillHints.email],
                          textInputAction: TextInputAction.next,
                          validacao: (String? value) {
                            if (value == null ||
                                value.isEmpty ||
                                !value.contains("@") ||
                                !value.contains(".")) {
                              return "Digite um e-mail válido";
                            }
                            return null;
                          },
                          obscure: false),
                      SizedBox(height: espacos),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.47,
                            child: _buildTextFormField(
                                texto: "Senha",
                                onChanged: (value) {
                                  _senhaController.text = value;
                                },
                                controllerCampo: _senhaController,
                                tipoTeclado: TextInputType.text,
                                obscure: true,
                                validacao: (String? value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 6) {
                                    return "A senha precisa conter no mínimo 6 caracteres";
                                  }
                                  return null;
                                }),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.47,
                              child: _buildTextFormField(
                                  texto: "Celular",
                                  onChanged: (value) {
                                    _celularController.text = value;
                                  },
                                  controllerCampo: _celularController,
                                  mascara: [mascaraCelular],
                                  tipoTeclado: TextInputType.phone,
                                  autofillHints: [AutofillHints.telephoneNumber],
                                  textInputAction: TextInputAction.next,
                                  validacao: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Campo obrigatório";
                                    } else if (value.length < 16) {
                                      return "Número inválido";
                                    }
                                    return null;
                                  },
                                  obscure: false))
                        ],
                      ),
                      SizedBox(height: espacos * 2.5),
                      _buildRotulo("Endereço"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.68,
                            child: _buildTextFormField(
                                texto: "Logradouro",
                                onChanged: (value) {
                                  _logradouroController.text = value;
                                },
                                controllerCampo: _logradouroController,
                                tipoTeclado: TextInputType.text,
                                autofillHints: [AutofillHints.streetAddressLine1],
                                textInputAction: TextInputAction.next,
                                validacao: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return "Campo obrigatório";
                                  }
                                  return null;
                                },
                                obscure: false),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: _buildTextFormField(
                                  texto: "Nº",
                                  onChanged: (value) {
                                    _numeroController.text = value;
                                  },
                                  controllerCampo: _numeroController,
                                  tipoTeclado: TextInputType.number,
                                  onTap: null,
                                  validacao: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Campo obrigatório";
                                    }
                                    return null;
                                  },
                                  obscure: false))
                        ],
                      ),
                      SizedBox(height: espacos),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: _buildTextFormField(
                                  texto: "Complemento",
                                  onChanged: (value) {
                                    _complementoController.text = value;
                                  },
                                  controllerCampo: _complementoController,
                                  tipoTeclado: TextInputType.text,
                                  onTap: null,
                                  validacao: (String? value) {
                                    return null;
                                  },
                                  obscure: false)),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.43,
                              child: _buildTextFormField(
                                  texto: "Bairro",
                                  onChanged: (value) {
                                    _bairroController.text = value;
                                  },
                                  controllerCampo: _bairroController,
                                  tipoTeclado: TextInputType.text,
                                  onTap: null,
                                  validacao: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Campo obrigatório";
                                    }
                                    return null;
                                  },
                                  obscure: false))
                        ],
                      ),
                      SizedBox(height: espacos),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width * 0.63,
                              child: _buildTextFormField(
                                  texto: "Cidade",
                                  onChanged: (value) {
                                    _cidadeController.text = value;
                                  },
                                  controllerCampo: _cidadeController,
                                  tipoTeclado: TextInputType.text,
                                  autofillHints: [AutofillHints.addressCity],
                                  textInputAction: TextInputAction.next,
                                  onTap: null,
                                  validacao: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Campo obrigatório";
                                    }
                                    return null;
                                  },
                                  obscure: false)),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: _buildDropdown(
                                  context: context,
                                  fatorTela: 0.4,
                                  itens: <String>[
                                    'AC',
                                    'AL',
                                    'AP',
                                    'AM',
                                    'BA',
                                    'CE',
                                    'DF',
                                    'ES',
                                    'GO',
                                    'MA',
                                    'MT',
                                    'MS',
                                    'MG',
                                    'PA',
                                    'PB',
                                    'PR',
                                    'PE',
                                    'PI',
                                    'RJ',
                                    'RN',
                                    'RS',
                                    'RO',
                                    'RR',
                                    'SC',
                                    'SP',
                                    'SE',
                                    'TO'
                                  ],
                                  titulo: "UF",
                                  onChanged: (value) {
                                    setState(() {
                                      _estadoController = value;
                                    });
                                  },
                                  validacao: (String? value) {
                                    if (value == null || value.isEmpty || value == "") {
                                      return "Campo obrigatório";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _estadoController = value;
                                  })),
                        ],
                      ),
                      SizedBox(height: espacos * 2.5),
                      Observer(builder: (_) {
                        if (localUser.isLoading)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              DateTime dataAux = DateFormat("dd/MM/yyyy")
                                  .parse(_nascimentoController.text)
                                  .add(Duration(hours: 3));
                              Timestamp tsAux = Timestamp.fromDate(dataAux);
                              Map<String, dynamic> dadosUsuario = {
                                "nome": _nomeController.text.trim(),
                                "email":
                                    _emailController.text.toLowerCase().trim(),
                                "celular": _celularController.text,
                                "nascimento": tsAux,
                                "sexo": _sexoController,
                                "endereco": {
                                  "bairro": _bairroController.text.trim(),
                                  "cidade": _cidadeController.text.trim(),
                                  "complemento":
                                      _complementoController.text.trim(),
                                  "estado": _estadoController,
                                  "logradouro":
                                      _logradouroController.text.trim(),
                                  "numero": _numeroController.text.trim()
                                }
                              };

                              authRepo.criarUsuario(
                                  dadosUsuario: dadosUsuario,
                                  senha: _senhaController.text,
                                  onSuccess: _onSuccess,
                                  onFail: _onFail);

                              print("Validado corretamente");
                              print(_nomeController.text);
                            } else {
                              print("Erro de validação");
                              return null;
                            }
                          },
                          child: Text(
                            "CRIAR USUÁRIO",
                            style: TextStyle(
                                color: t2,
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                          ),
                        );
                      })
                    ],  // Column
                  ),  // Theme
                ),    // Form  
              ),      // SingleChildScrollView
            ),        // Container
          ),          // SizedBox
        ),            // SafeArea
        ),            // Extra
    );                // Scaffold
  }

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container(
        padding: EdgeInsets.all(18),
        child: Text(
          "Usuário criado com sucesso!",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 4),
    ));
    Future.delayed(Duration(seconds: 4)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    String? tipoErro = localUser.erroAoCriarUsuario;
    String mensagemErro = "*Falha ao criar usuário*";
    switch (tipoErro) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "auth/email-already-in-use":
        mensagemErro = "E-mail já cadastrado no sistema";
        break;
      case "ERROR_INVALID_EMAIL":
      case "auth/invalid-email":
        mensagemErro = "Formato de e-mail inválido";
        break;
      default:
        mensagemErro = "Consulte o administrador do sistema";
        break;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container(
        padding: EdgeInsets.all(18),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Falha ao criar usuário",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                mensagemErro,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 5),
    ));
    print("Erro ao criar usuário");
  }

  Container _buildDropdown({
    required BuildContext context,
    required double fatorTela,
    required List<String> itens,
    required Function(String?) onChanged,
    required Function(String?) onSaved,
    required String titulo,
    required String? Function(String?) validacao,
  }) {
    return Container(
        width: MediaQuery.of(context).size.width * fatorTela,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: t1,
            brightness: Brightness.dark,
          ),
          child: DropdownButtonFormField<String>(
            items: itens.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(child: Text(value), value: value);
            }).toList(),
            onChanged: onChanged,
            validator: validacao,
            onSaved: onSaved,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: false,
              contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(18),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(18),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(18),
              ),
              labelText: titulo,
              labelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width > 400 ? 12 : 10),
            ),
          ),
        ));
  }

  _buildRotulo(String texto) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
          padding: EdgeInsets.fromLTRB(16, 0, 0, 12),
          child: Text(
            texto,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width > 400 ? 12 : 10),
          )),
    );
  }

  _buildTextFormField({
    required String texto,
    required TextEditingController controllerCampo,
    required String? Function(String?) validacao,
    required TextInputType tipoTeclado,
    required bool obscure,
    Function(String)? onChanged,
    Function()? onTap,
    Function(String)? editado,
    List<TextInputFormatter>? mascara,
    List<String>? autofillHints,
    TextInputAction? textInputAction,
  }) {
    return TextFormField(
      controller: controllerCampo,
      inputFormatters: mascara ?? [],
      validator: validacao,
      onChanged: onChanged,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      onTap: onTap,
      onFieldSubmitted: editado,
      obscureText: obscure,
      autofillHints: autofillHints,
      textInputAction: textInputAction ?? TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(18),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(18),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 3),
          borderRadius: BorderRadius.circular(18),
        ),
        labelText: texto,
        labelStyle: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width > 400 ? 12 : 10),
      ),
      keyboardType: tipoTeclado,
    );
  }
}