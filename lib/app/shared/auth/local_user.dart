import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

part 'local_user.g.dart';

class LocalUser = _LocalUserBase with _$LocalUser;

abstract class _LocalUserBase with Store {
  _LocalUserBase() {
    init();
  }

  @action
  init() async {
    if (firebaseUser == null) {
      firebaseUser = FirebaseAuth.instance.currentUser;
    }
    if (firebaseUser != null) {
      DocumentSnapshot docUser = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(firebaseUser!.uid)
          .get();
      final data = docUser.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('nome')) {
        mudarNome(data['nome']);
      }
    }
  }

  @observable
  User? firebaseUser;
@action
setFirebaseUser(User? value) async {
  firebaseUser = value;
  if (value != null) {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(value.uid)
        .get();
    final data = doc.data() as Map<String, dynamic>?;
    String nomeAux = data?['nome'] ?? '';
    await mudarNome(nomeAux);
  }
}

  @action
  bool isLoggedIn() {
    return firebaseUser != null;
  }

  @observable
  bool isLoading = false;
  @action
  setIsLoadingTrue() => isLoading = true;
  @action
  setIsLoadingFalse() => isLoading = false;

  @observable
  String? nome;
  @action
  mudarNome(String value) => nome = value;

  @observable
  String? email;
  @action
  mudarEmail(String value) => email = value;

  @observable
  String? erroAoCriarUsuario;
  @action
  mudarErroAoCriarUsuario(String value) {
    erroAoCriarUsuario = value;
  }

  @observable
  String? erroAoLogar;
  @action
  mudarErroAoLogar(String value) {
    erroAoLogar = value;
  }
}