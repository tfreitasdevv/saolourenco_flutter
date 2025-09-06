import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'confissoes_controller.g.dart';

class ConfissoesController = _ConfissoesBase with _$ConfissoesController;

abstract class _ConfissoesBase with Store {
  @observable
  String textoConfissoes = '';

  @observable
  bool isLoading = true;

  @action
  Future<void> carregarTextoConfissoes() async {
    isLoading = true;
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('confissoes')
          .doc('texto_confissoes')
          .get();
      
      if (doc.exists) {
        textoConfissoes = doc.get('texto') ?? '';
      } else {
        textoConfissoes = 'Texto não encontrado.';
      }
    } catch (e) {
      textoConfissoes = 'Erro ao carregar o texto: $e';
    }
    isLoading = false;
  }
}
