import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/locais_data.dart';
import '../models/rua.dart';

class ApiService {
  Future<List<Rua>> buscarRuas() async {
    final latitudes = locais.map((local) => local.latitude).join(',');
    final longitudes = locais.map((local) => local.longitude).join(',');

    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$latitudes&longitude=$longitudes'
      '&daily=precipitation_sum&forecast_days=1&timezone=America/Sao_Paulo',
    );

    final resposta = await http.get(url).timeout(const Duration(seconds: 10));

    if (resposta.statusCode != 200) {
      throw Exception('Erro ao buscar os dados: ${resposta.statusCode}');
    }

    final dados = json.decode(resposta.body) as List;

    final ruas = <Rua>[];
    for (var i = 0; i < locais.length; i++) {
      ruas.add(Rua.fromJson(dados[i], locais[i]));
    }

    ruas.sort((a, b) => b.chuvaMm.compareTo(a.chuvaMm));
    return ruas;
  }
}
