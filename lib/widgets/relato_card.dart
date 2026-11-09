import 'package:flutter/material.dart';

import '../models/relato.dart';
import 'risco_chip.dart';

class RelatoCard extends StatelessWidget {
  final Relato relato;
  final Widget? acao;

  const RelatoCard({super.key, required this.relato, this.acao});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.campaign),
        title: Text(relato.endereco),
        subtitle: Text(
          'Relato da comunidade: ${relato.nivelAgua}\n${relato.dataFormatada}',
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RiscoChip(risco: relato.risco),
            if (acao != null) acao!,
          ],
        ),
      ),
    );
  }
}
