import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/relato.dart';

class RelatoRepository {
  static const String _chave = 'relatos';

  Future<List<Relato>> listar() async {
    final prefs = await SharedPreferences.getInstance();
    final textos = prefs.getStringList(_chave) ?? [];
    final relatos = textos.map((texto) => Relato.fromJson(json.decode(texto)));
    return relatos.toList().reversed.toList();
  }

  Future<void> adicionar(Relato relato) async {
    final prefs = await SharedPreferences.getInstance();
    final textos = List<String>.from(prefs.getStringList(_chave) ?? []);
    textos.add(json.encode(relato.toJson()));
    await prefs.setStringList(_chave, textos);
  }

  Future<void> remover(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final textos = List<String>.from(prefs.getStringList(_chave) ?? []);
    textos.removeWhere((texto) => json.decode(texto)['id'] == id);
    await prefs.setStringList(_chave, textos);
  }
}
