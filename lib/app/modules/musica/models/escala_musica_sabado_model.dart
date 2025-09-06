import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EscalaMusicaSabadoModel {
  late String id;
  late int quantidadeSabados;
  late String mes;

  // Missa 1
  late String dataMissa1;
  late String grupoH1M1;
  late String horarioH1M1;

  // Missa 2
  late String dataMissa2;
  late String grupoH1M2;
  late String horarioH1M2;

  // Missa 3
  late String dataMissa3;
  late String grupoH1M3;
  late String horarioH1M3;

  // Missa 4
  late String dataMissa4;
  late String grupoH1M4;
  late String horarioH1M4;

  // Missa 5
  late String dataMissa5;
  late String grupoH1M5;
  late String horarioH1M5;

  EscalaMusicaSabadoModel.fromDocument(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    quantidadeSabados = data['quantidade'];
    mes = data['mes'];

    String _timestampToString(Timestamp timestamp) {
      DateTime dataDT = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
      return DateFormat('dd/MM/yyyy').format(dataDT);
    }

    // DATAS
    dataMissa1 = _timestampToString(data['missa1']['data']);
    dataMissa2 = _timestampToString(data['missa2']['data']);
    dataMissa3 = _timestampToString(data['missa3']['data']);
    dataMissa4 = _timestampToString(data['missa4']['data']);
    if (quantidadeSabados > 4 && data.containsKey('missa5')) {
      dataMissa5 = _timestampToString(data['missa5']['data']);
    } else {
      dataMissa5 = "";
    }

    // GRUPOS
    grupoH1M1 = data['missa1']['horario1']['grupo'];
    grupoH1M2 = data['missa2']['horario1']['grupo'];
    grupoH1M3 = data['missa3']['horario1']['grupo'];
    grupoH1M4 = data['missa4']['horario1']['grupo'];
    if (quantidadeSabados > 4 && data.containsKey('missa5')) {
      grupoH1M5 = data['missa5']['horario1']['grupo'];
    } else {
      grupoH1M5 = "";
    }

    // HORARIOS
    horarioH1M1 = data['missa1']['horario1']['horario'];
    horarioH1M2 = data['missa2']['horario1']['horario'];
    horarioH1M3 = data['missa3']['horario1']['horario'];
    horarioH1M4 = data['missa4']['horario1']['horario'];
    if (quantidadeSabados > 4 && data.containsKey('missa5')) {
      horarioH1M5 = data['missa5']['horario1']['horario'];
    } else {
      horarioH1M5 = "";
    }
  }

  late Map<String, dynamic> escalaMapa;

  EscalaMusicaSabadoModel.toMap(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    escalaMapa = {
      "mes": data['mes'],
      "quantidade": data['quantidade'],
      "missa1": {
        "data": data['missa1']['data'],
        "quantidade": data['missa1']['quantidade'],
        "horario1": {
          "grupo": data['missa1']['horario1']['grupo'],
          "horario": data['missa1']['horario1']['horario'],
        }
      },
      "missa2": {
        "data": data['missa2']['data'],
        "quantidade": data['missa2']['quantidade'],
        "horario1": {
          "grupo": data['missa2']['horario1']['grupo'],
          "horario": data['missa2']['horario1']['horario'],
        }
      },
      "missa3": {
        "data": data['missa3']['data'],
        "quantidade": data['missa3']['quantidade'],
        "horario1": {
          "grupo": data['missa3']['horario1']['grupo'],
          "horario": data['missa3']['horario1']['horario'],
        }
      },
      "missa4": {
        "data": data['missa4']['data'],
        "quantidade": data['missa4']['quantidade'],
        "horario1": {
          "grupo": data['missa4']['horario1']['grupo'],
          "horario": data['missa4']['horario1']['horario'],
        }
      },
      "missa5": {
        "data": data['missa5']['data'],
        "quantidade": data['missa5']['quantidade'],
        "horario1": {
          "grupo": data['missa5']['horario1']['grupo'],
          "horario": data['missa5']['horario1']['horario'],
        }
      }
    };
  }
}