import 'rua.dart';

class Relato {
  static const List<String> niveisAgua = [
    'Água na calçada',
    'Na altura do joelho',
    'Impossível passar',
  ];

  final String id;
  final String endereco;
  final String nivelAgua;
  final DateTime dataHora;

  const Relato({
    required this.id,
    required this.endereco,
    required this.nivelAgua,
    required this.dataHora,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'endereco': endereco,
      'nivelAgua': nivelAgua,
      'dataHora': dataHora.toIso8601String(),
    };
  }

  factory Relato.fromJson(Map<String, dynamic> json) {
    return Relato(
      id: json['id'],
      endereco: json['endereco'],
      nivelAgua: json['nivelAgua'],
      dataHora: DateTime.parse(json['dataHora']),
    );
  }

  Risco get risco {
    if (nivelAgua == niveisAgua[0]) {
      return Risco.atencao;
    }
    return Risco.alto;
  }

  String get dataFormatada {
    String doisDigitos(int numero) => numero.toString().padLeft(2, '0');
    return '${doisDigitos(dataHora.day)}/${doisDigitos(dataHora.month)}/'
        '${dataHora.year} ${doisDigitos(dataHora.hour)}:'
        '${doisDigitos(dataHora.minute)}';
  }
}
