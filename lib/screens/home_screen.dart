import 'package:flutter/material.dart';

import '../models/estado_tela.dart';
import '../models/relato.dart';
import '../models/rua.dart';
import '../repositories/relato_repository.dart';
import '../services/api_service.dart';
import '../widgets/mensagem_view.dart';
import '../widgets/relato_card.dart';
import '../widgets/rua_card.dart';
import 'detalhes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final RelatoRepository _relatoRepository = RelatoRepository();
  final TextEditingController _buscaController = TextEditingController();

  EstadoTela _estado = EstadoTela.inicial;
  List<Rua> _ruas = [];
  List<Rua> _ruasFiltradas = [];
  List<Relato> _relatos = [];
  List<Relato> _relatosFiltrados = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    setState(() {
      _estado = EstadoTela.carregando;
    });

    try {
      final ruas = await _apiService.buscarRuas();
      final relatos = await _relatoRepository.listar();
      if (!mounted) return;

      setState(() {
        _ruas = ruas;
        _relatos = relatos;
        _filtrar(_buscaController.text);
        _estado = EstadoTela.sucesso;
      });
    } catch (erro) {
      if (!mounted) return;
      setState(() {
        _estado = EstadoTela.erro;
      });
    }
  }

  Future<void> carregarRelatos() async {
    final relatos = await _relatoRepository.listar();
    if (!mounted) return;

    _buscaController.clear();
    setState(() {
      _relatos = relatos;
      _filtrar('');
    });
  }

  void _filtrar(String texto) {
    final busca = texto.toLowerCase();

    _ruasFiltradas = _ruas.where((rua) {
      return rua.nome.toLowerCase().contains(busca) ||
          rua.cidade.toLowerCase().contains(busca);
    }).toList();

    _relatosFiltrados = _relatos.where((relato) {
      return relato.endereco.toLowerCase().contains(busca);
    }).toList();
  }

  void _abrirDetalhes(Rua rua) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetalhesScreen(rua: rua)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ruas Monitoradas'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _estado == EstadoTela.carregando ? null : _carregar,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _construirCorpo(),
    );
  }

  Widget _construirCorpo() {
    if (_estado == EstadoTela.inicial) {
      return const MensagemView(
        icone: Icons.water_drop,
        titulo: 'Alaga Não',
        mensagem: 'Preparando as informações...',
      );
    }

    if (_estado == EstadoTela.carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_estado == EstadoTela.erro) {
      return MensagemView(
        icone: Icons.cloud_off,
        titulo: 'Não foi possível carregar',
        mensagem: 'Verifique sua conexão com a internet e tente novamente.',
        textoBotao: 'Tentar novamente',
        aoPressionar: _carregar,
      );
    }

    final totalItens = _relatosFiltrados.length + _ruasFiltradas.length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _buscaController,
            onChanged: (texto) {
              setState(() {
                _filtrar(texto);
              });
            },
            decoration: const InputDecoration(
              hintText: 'Pesquisar rua ou cidade...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: totalItens == 0
              ? const MensagemView(
                  icone: Icons.search_off,
                  titulo: 'Nada encontrado',
                  mensagem: 'Nenhuma rua corresponde à sua busca.',
                )
              : ListView.builder(
                  itemCount: totalItens,
                  itemBuilder: (context, indice) {
                    if (indice < _relatosFiltrados.length) {
                      return RelatoCard(relato: _relatosFiltrados[indice]);
                    }

                    final rua =
                        _ruasFiltradas[indice - _relatosFiltrados.length];
                    return RuaCard(
                      rua: rua,
                      aoTocar: () => _abrirDetalhes(rua),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
