import 'package:flutter/material.dart';

class MensagemView extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String mensagem;
  final String? textoBotao;
  final VoidCallback? aoPressionar;

  const MensagemView({
    super.key,
    required this.icone,
    required this.titulo,
    required this.mensagem,
    this.textoBotao,
    this.aoPressionar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(mensagem, textAlign: TextAlign.center),
            if (aoPressionar != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: aoPressionar,
                child: Text(textoBotao ?? 'OK'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
