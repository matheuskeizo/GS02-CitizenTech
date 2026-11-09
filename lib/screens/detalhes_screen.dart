import 'package:flutter/material.dart';

import '../models/rua.dart';
import '../widgets/risco_chip.dart';

class DetalhesScreen extends StatelessWidget {
  final Rua rua;

  const DetalhesScreen({super.key, required this.rua});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(rua.nome)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(Icons.water_drop, size: 64, color: Colors.blue),
                  const SizedBox(height: 12),
                  RiscoChip(risco: rua.risco),
                  const SizedBox(height: 12),
                  Text(
                    rua.nome,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(rua.cidade),
                ],
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.umbrella),
              title: const Text('Chuva prevista hoje'),
              subtitle: Text(rua.chuvaFormatada),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Situação atual'),
              subtitle: Text(rua.descricao),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.rule),
              title: const Text('Como o risco é calculado'),
              subtitle: Text(
                'Atenção: a partir de ${Rua.limiteAtencao.toInt()} mm.\n'
                'Alto risco: a partir de ${Rua.limiteAlto.toInt()} mm.\n'
                'Dados: Open-Meteo.',
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }
}
