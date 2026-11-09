import 'package:flutter/material.dart';

import '../models/pagina_intro.dart';
import '../services/preferences_service.dart';
import '../widgets/onboarding_page.dart';
import 'main_navigator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  final PreferencesService _preferences = PreferencesService();

  final List<PaginaIntro> _paginas = const [
    PaginaIntro(
      icone: Icons.notifications_active,
      titulo: 'Alertas locais',
      descricao:
          'Acompanhe a previsão de chuva e o risco de alagamento '
          'nas ruas da sua cidade.',
    ),
    PaginaIntro(
      icone: Icons.alt_route,
      titulo: 'Aviso prévio',
      descricao:
          'Saiba antes de sair de casa se a sua rota pode estar '
          'alagada.',
    ),
    PaginaIntro(
      icone: Icons.groups,
      titulo: 'Comunidade',
      descricao:
          'Envie relatos de alagamentos e ajude outras pessoas '
          'no trânsito.',
    ),
  ];

  int _paginaAtual = 0;
  bool _naoMostrarNovamente = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _avancar() {
    if (_paginaAtual == _paginas.length - 1) {
      _finalizar();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _voltar() {
    _controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finalizar() async {
    await _preferences.salvarOnboarding(_naoMostrarNovamente);
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigatorScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finalizar,
                child: const Text('PULAR'),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (indice) {
                  setState(() {
                    _paginaAtual = indice;
                  });
                },
                children: _paginas
                    .map((pagina) => OnboardingPage(pagina: pagina))
                    .toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_paginas.length, (indice) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: indice == _paginaAtual
                        ? Colors.blue
                        : Colors.grey.shade300,
                  ),
                );
              }),
            ),
            CheckboxListTile(
              value: _naoMostrarNovamente,
              onChanged: (valor) {
                setState(() {
                  _naoMostrarNovamente = valor ?? false;
                });
              },
              title: const Text('Não mostrar novamente'),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _paginaAtual == 0 ? null : _voltar,
                    child: const Text('VOLTAR'),
                  ),
                  ElevatedButton(
                    onPressed: _avancar,
                    child: Text(
                      _paginaAtual == _paginas.length - 1
                          ? 'COMEÇAR'
                          : 'AVANÇAR',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
