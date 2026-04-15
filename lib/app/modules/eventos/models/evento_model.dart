/// Modelo que representa um evento da paróquia
/// Cada evento contém informações básicas como título, descrição, 
/// data de realização e opcionalmente uma imagem e link
class EventoModel {
  /// ID único do documento (documentId do Strapi)
  late String id;
  
  /// Data e hora do evento
  late DateTime data;
  
  /// Título do evento (compatível com markdown)
  late String titulo;
  
  /// Descrição detalhada do evento (opcional, compatível com markdown)
  String? descricao;
  
  /// URL da imagem do evento (opcional)
  String? imagem;
  
  /// Link externo relacionado ao evento (opcional)
  String? link;

  /// Construtor que cria um EventoModel a partir de um Map da API Strapi v5
  EventoModel.fromJson(Map<String, dynamic> json) {
    id = json['documentId'] ?? json['id'].toString();
    
    final String? dataStr = json['data'] as String?;
    if (dataStr != null) {
      data = DateTime.parse(dataStr);
    } else {
      data = DateTime.now();
    }
    
    titulo = json['titulo'] as String? ?? '';
    descricao = json['descricao'] as String?;
    
    // Imagem pode ser um objeto populado ou null
    final imagemData = json['imagem'];
    if (imagemData is Map<String, dynamic>) {
      imagem = imagemData['url'] as String?;
    } else if (imagemData is String) {
      imagem = imagemData;
    }
    
    link = json['link'] as String?;
  }

  /// Converte o EventoModel para JSON para enviar à API
  Map<String, dynamic> toJson() {
    return {
      'data': data.toIso8601String(),
      'titulo': titulo,
      'descricao': descricao,
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
