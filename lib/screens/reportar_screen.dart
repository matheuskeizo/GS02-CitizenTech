import 'package:flutter/material.dart';

import '../models/relato.dart';
import '../repositories/relato_repository.dart';

class ReportarScreen extends StatefulWidget {
  final VoidCallback aoEnviar;

  const ReportarScreen({super.key, required this.aoEnviar});

  @override
  State<ReportarScreen> createState() => _ReportarScreenState();
}

class _ReportarScreenState extends State<ReportarScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _enderecoController = TextEditingController();
  final RelatoRepository _repository = RelatoRepository();

  String? _nivelAgua;

  @override
  void dispose() {
    _enderecoController.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;

    final agora = DateTime.now();
    final relato = Relato(
      id: agora.millisecondsSinceEpoch.toString(),
      endereco: _enderecoController.text.trim(),
      nivelAgua: _nivelAgua!,
      dataHora: agora,
    );

    await _repository.adicionar(relato);
    if (!mounted) return;

    _formKey.currentState!.reset();
    setState(() {
      _nivelAgua = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Relato enviado com sucesso!')),
    );

    widget.aoEnviar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enviar Relato'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Viu um alagamento? Avise a comunidade.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _enderecoController,
                  decoration: const InputDecoration(
                    labelText: 'Endereço',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().length < 3) {
                      return 'Informe o endereço';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Nível da água',
                    border: OutlineInputBorder(),
                  ),
                  items: Relato.niveisAgua
                      .map(
                        (nivel) =>
                            DropdownMenuItem(value: nivel, child: Text(nivel)),
                      )
                      .toList(),
                  onChanged: (valor) {
                    setState(() {
                      _nivelAgua = valor;
                    });
                  },
                  validator: (valor) {
                    if (valor == null) return 'Selecione o nível da água';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _enviar,
                    child: const Text('ENVIAR'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
