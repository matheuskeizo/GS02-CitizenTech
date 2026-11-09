import 'local.dart';

enum Risco { seguro, atencao, alto }

class Rua {
  static const double limiteAtencao = 10;
  static const double limiteAlto = 30;

  final String id;
  final String nome;
  final String cidade;
  final double chuvaMm;

  const Rua({
    required this.id,
    required this.nome,
    required this.cidade,
    required this.chuvaMm,
  });

  factory Rua.fromJson(Map<String, dynamic> json, Local local) {
    final chuva = (json['daily']['precipitation_sum'][0] as num?)?.toDouble();
    return Rua(
      id: local.id,
      nome: local.nome,
      cidade: local.cidade,
      chuvaMm: chuva ?? 0.0,
    );
  }

  Risco get risco {
    if (chuvaMm >= limiteAlto) {
      return Risco.alto;
    }
    if (chuvaMm >= limiteAtencao) {
      return Risco.atencao;
    }
    return Risco.seguro;
  }

  String get chuvaFormatada {
    return '${chuvaMm.toStringAsFixed(1).replaceAll('.', ',')} mm';
  }

  String get descricao {
    if (risco == Risco.alto) {
      return 'Chuva forte prevista hoje: $chuvaFormatada';
    }
    if (risco == Risco.atencao) {
      return 'Chuva moderada prevista hoje: $chuvaFormatada';
    }
    return 'Pouca chuva prevista hoje: $chuvaFormatada';
  }
}
