import 'package:flutter/material.dart';

import '../models/relato.dart';
import '../repositories/relato_repository.dart';
import '../widgets/mensagem_view.dart';
import '../widgets/relato_card.dart';

class MeusRelatosScreen extends StatefulWidget {
  const MeusRelatosScreen({super.key});

  @override
  State<MeusRelatosScreen> createState() => _MeusRelatosScreenState();
}

class _MeusRelatosScreenState extends State<MeusRelatosScreen> {
  final RelatoRepository _repository = RelatoRepository();

  List<Relato> _relatos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final relatos = await _repository.listar();
    if (!mounted) return;

    setState(() {
      _relatos = relatos;
      _carregando = false;
    });
  }

  Future<void> _excluir(Relato relato) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir relato?'),
        content: Text('O relato de "${relato.endereco}" será removido.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('EXCLUIR'),
          ),
        ],
      ),
    );

    if (confirmou != true) return;

    await _repository.remover(relato.id);
    await _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Relatos'), centerTitle: true),
      body: _construirCorpo(),
    );
  }

  Widget _construirCorpo() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_relatos.isEmpty) {
      return const MensagemView(
        icone: Icons.history,
        titulo: 'Nenhum relato ainda',
        mensagem: 'Use a aba Reportar para avisar sobre um alagamento.',
      );
    }

    return ListView.builder(
      itemCount: _relatos.length,
      itemBuilder: (context, indice) {
        final relato = _relatos[indice];
        return RelatoCard(
          relato: relato,
          acao: IconButton(
            onPressed: () => _excluir(relato),
            icon: const Icon(Icons.delete_outline),
          ),
        );
      },
    );
  }
}
