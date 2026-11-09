import 'package:flutter/material.dart';

import '../models/rua.dart';

class RiscoChip extends StatelessWidget {
  final Risco risco;

  const RiscoChip({super.key, required this.risco});

  @override
  Widget build(BuildContext context) {
    String texto = 'SEGURO';
    Color cor = Colors.green.shade700;

    if (risco == Risco.atencao) {
      texto = 'ATENÇÃO';
      cor = Colors.orange.shade800;
    } else if (risco == Risco.alto) {
      texto = 'ALTO RISCO';
      cor = Colors.red.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
