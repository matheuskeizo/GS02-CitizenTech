import 'package:flutter/material.dart';

import 'meus_relatos_screen.dart';

class PerfilScreen extends StatelessWidget {
  final VoidCallback aoAlterarRelatos;

  const PerfilScreen({super.key, required this.aoAlterarRelatos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          const Center(
            child: CircleAvatar(
              radius: 44,
              child: Icon(Icons.person, size: 48),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Cidadão Alaga Não',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Colaborador da comunidade',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Meus relatos'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MeusRelatosScreen(),
                  ),
                );
                aoAlterarRelatos();
              },
            ),
          ),
        ],
      ),
    );
  }
}
