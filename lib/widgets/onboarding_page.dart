import 'package:flutter/material.dart';

import '../models/pagina_intro.dart';

class OnboardingPage extends StatelessWidget {
  final PaginaIntro pagina;

  const OnboardingPage({super.key, required this.pagina});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(pagina.icone, size: 100, color: Colors.blue),
            const SizedBox(height: 32),
            Text(
              pagina.titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              pagina.descricao,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
