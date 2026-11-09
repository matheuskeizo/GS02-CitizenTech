import 'package:flutter/material.dart';

import '../models/rua.dart';
import 'risco_chip.dart';

class RuaCard extends StatelessWidget {
  final Rua rua;
  final VoidCallback aoTocar;

  const RuaCard({super.key, required this.rua, required this.aoTocar});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: aoTocar,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rua.nome,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      rua.cidade,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(rua.descricao, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              RiscoChip(risco: rua.risco),
            ],
          ),
        ),
      ),
    );
  }
}
