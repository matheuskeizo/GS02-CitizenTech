import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'perfil_screen.dart';
import 'reportar_screen.dart';

class MainNavigatorScreen extends StatefulWidget {
  const MainNavigatorScreen({super.key});

  @override
  State<MainNavigatorScreen> createState() => _MainNavigatorScreenState();
}

class _MainNavigatorScreenState extends State<MainNavigatorScreen> {
  final GlobalKey<HomeScreenState> _homeKey = GlobalKey<HomeScreenState>();

  int _indiceAtual = 0;

  void _atualizarRelatos() {
    _homeKey.currentState?.carregarRelatos();
  }

  void _aoEnviarRelato() {
    _atualizarRelatos();
    setState(() {
      _indiceAtual = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final telas = [
      HomeScreen(key: _homeKey),
      ReportarScreen(aoEnviar: _aoEnviarRelato),
      PerfilScreen(aoAlterarRelatos: _atualizarRelatos),
    ];

    return Scaffold(
      body: IndexedStack(index: _indiceAtual, children: telas),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (indice) {
          setState(() {
            _indiceAtual = indice;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo),
            label: 'Reportar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
