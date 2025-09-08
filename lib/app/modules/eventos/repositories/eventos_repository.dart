import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/evento_model.dart';

/// Repository responsável por gerenciar as operações de dados dos eventos
/// no Firestore Database
class EventosRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'eventos';

  /// Obtém todos os eventos ordenados por data (mais recentes primeiro)
  Stream<List<EventoModel>> obterEventos() {
    return _firestore
        .collection(_collection)
        .orderBy('data', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EventoModel.fromDocument(doc))
            .toList());
  }

  /// Obtém apenas os eventos futuros ordenados por data
  Stream<List<EventoModel>> obterEventosFuturos() {
    final agora = Timestamp.fromDate(DateTime.now());
    
    return _firestore
        .collection(_collection)
        .where('data', isGreaterThanOrEqualTo: agora)
        .orderBy('data', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EventoModel.fromDocument(doc))
            .toList());
  }

  /// Obtém apenas os eventos passados ordenados por data (mais recentes primeiro)
  Stream<List<EventoModel>> obterEventosPassados() {
    final agora = Timestamp.fromDate(DateTime.now());
    
    return _firestore
        .collection(_collection)
        .where('data', isLessThan: agora)
        .orderBy('data', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EventoModel.fromDocument(doc))
            .toList());
  }

  /// Obtém os próximos eventos (nos próximos 30 dias)
  Stream<List<EventoModel>> obterProximosEventos({int dias = 30}) {
    final agora = DateTime.now();
    final proximosPeriodo = agora.add(Duration(days: dias));
    
    return _firestore
        .collection(_collection)
        .where('data', isGreaterThanOrEqualTo: Timestamp.fromDate(agora))
        .where('data', isLessThanOrEqualTo: Timestamp.fromDate(proximosPeriodo))
        .orderBy('data', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EventoModel.fromDocument(doc))
            .toList());
  }

  /// Obtém um evento específico pelo ID
  Future<EventoModel?> obterEventoPorId(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      
      if (doc.exists) {
        return EventoModel.fromDocument(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar evento: $e');
    }
  }

  /// Busca eventos por título (case insensitive)
  Stream<List<EventoModel>> buscarEventosPorTitulo(String titulo) {
    return _firestore
        .collection(_collection)
        .orderBy('titulo')
        .startAt([titulo.toLowerCase()])
        .endAt([titulo.toLowerCase() + '\uf8ff'])
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EventoModel.fromDocument(doc))
            .toList());
  }

  /// Obtém eventos em um intervalo de datas específico
  Stream<List<EventoModel>> obterEventosPorPeriodo({
    required DateTime dataInicio,
    required DateTime dataFim,
  }) {
    return _firestore
        .collection(_collection)
        .where('data', isGreaterThanOrEqualTo: Timestamp.fromDate(dataInicio))
        .where('data', isLessThanOrEqualTo: Timestamp.fromDate(dataFim))
        .orderBy('data', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EventoModel.fromDocument(doc))
            .toList());
  }

  /// Obtém os eventos do mês atual
  Stream<List<EventoModel>> obterEventosDoMesAtual() {
    final agora = DateTime.now();
    final inicioMes = DateTime(agora.year, agora.month, 1);
    final fimMes = DateTime(agora.year, agora.month + 1, 0, 23, 59, 59);
    
    return obterEventosPorPeriodo(
      dataInicio: inicioMes,
      dataFim: fimMes,
    );
  }

  /// Obtém a contagem total de eventos
  Future<int> obterTotalEventos() async {
    try {
      final snapshot = await _firestore.collection(_collection).count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      throw Exception('Erro ao contar eventos: $e');
    }
  }

  /// Obtém a contagem de eventos futuros
  Future<int> obterTotalEventosFuturos() async {
    try {
      final agora = Timestamp.fromDate(DateTime.now());
      final snapshot = await _firestore
          .collection(_collection)
          .where('data', isGreaterThanOrEqualTo: agora)
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e) {
      throw Exception('Erro ao contar eventos futuros: $e');
    }
  }

  /// Métodos para administração (caso seja necessário no futuro)
  
  /// Adiciona um novo evento
  Future<String> adicionarEvento(EventoModel evento) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(evento.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Erro ao adicionar evento: $e');
    }
  }

  /// Atualiza um evento existente
  Future<void> atualizarEvento(EventoModel evento) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(evento.id)
          .update(evento.toMap());
    } catch (e) {
      throw Exception('Erro ao atualizar evento: $e');
    }
  }

  /// Remove um evento
  Future<void> removerEvento(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao remover evento: $e');
    }
  }
}
