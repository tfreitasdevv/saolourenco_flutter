import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo que representa um evento da paróquia
/// Cada evento contém informações básicas como título, descrição, 
/// data de realização e opcionalmente uma imagem e link
class EventoModel {
  /// ID único do documento no Firestore
  late String id;
  
  /// Data e hora do evento
  late DateTime data;
  
  /// Título do evento (compatível com markdown)
  late String titulo;
  
  /// Descrição detalhada do evento (opcional, compatível com markdown)
  String? descricao;
  
  /// URL da imagem do evento armazenada no Firebase Storage (opcional)
  String? imagem;
  
  /// Link externo relacionado ao evento (opcional)
  String? link;

  /// Construtor que cria um EventoModel a partir de um DocumentSnapshot do Firestore
  EventoModel.fromDocument(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    
    id = snapshot.id;
    
    // Converte o timestamp do Firestore para DateTime
    final Timestamp timestamp = data['data'] as Timestamp;
    this.data = timestamp.toDate();
    
    titulo = data['titulo'] as String;
    descricao = data['descricao'] as String?;
    imagem = data['imagem'] as String?;
    link = data['link'] as String?;
  }

  /// Construtor que cria um EventoModel a partir de um Map
  EventoModel.fromMap(Map<String, dynamic> data, String documentId) {
    id = documentId;
    
    // Converte o timestamp para DateTime
    if (data['data'] is Timestamp) {
      this.data = (data['data'] as Timestamp).toDate();
    } else if (data['data'] is DateTime) {
      this.data = data['data'] as DateTime;
    } else {
      throw ArgumentError('Campo data deve ser Timestamp ou DateTime');
    }
    
    titulo = data['titulo'] as String;
    descricao = data['descricao'] as String?;
    imagem = data['imagem'] as String?;
    link = data['link'] as String?;
  }

  /// Converte o EventoModel para um Map para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'data': Timestamp.fromDate(data),
      'titulo': titulo,
      'descricao': descricao,
      'imagem': imagem,
      'link': link,
    };
  }

  /// Verifica se o evento tem uma imagem
  bool get temImagem => imagem != null && imagem!.isNotEmpty;

  /// Verifica se o evento tem um link
  bool get temLink => link != null && link!.isNotEmpty;

  /// Verifica se o evento tem descrição
  bool get temDescricao => descricao != null && descricao!.isNotEmpty;

  /// Verifica se o evento já passou (baseado na data atual)
  bool get jaPassou => data.isBefore(DateTime.now());

  /// Verifica se o evento é hoje
  bool get eHoje {
    final agora = DateTime.now();
    return data.year == agora.year && 
           data.month == agora.month && 
           data.day == agora.day;
  }

  /// Verifica se o evento é nos próximos 7 dias
  bool get eProximo {
    final agora = DateTime.now();
    final seteAnos = agora.add(const Duration(days: 7));
    return data.isAfter(agora) && data.isBefore(seteAnos);
  }

  @override
  String toString() {
    return 'EventoModel{id: $id, data: $data, titulo: $titulo, descricao: $descricao, imagem: $imagem, link: $link}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventoModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
