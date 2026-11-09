# Alaga Não

Aplicativo mobile feito em Flutter que mostra o risco de alagamento em ruas de algumas cidades, usando a previsão de chuva de uma API pública. O usuário também pode enviar relatos de alagamento.

## Integrantes

| RM | Nome completo |
|----|---------------|
| 557834 | Matheus Keizo Hangui |
| 554924 | Bruno Itikawa |
| 558945 | Gabriel Shoiti |

## Links

- GitHub: [COLE AQUI O LINK DO REPOSITÓRIO]
- Vídeo pitch: [COLE AQUI O LINK DO VÍDEO]

## Tema da Global Solution

CitizenTech

## Descrição da solução

Alagamentos atrapalham o trânsito e colocam pessoas em risco. O Alaga Não ajuda o cidadão a saber antes de sair de casa se a rua está com risco de alagar.

O app tem uma lista de ruas monitoradas. Para cada rua ele consulta a chuva prevista para o dia e classifica o risco em **Seguro**, **Atenção** ou **Alto risco**. O usuário pode pesquisar ruas, ver os detalhes e enviar relatos de alagamento, que ficam salvos no celular.

## Fluxo de telas

1. **Splash**: mostra o logo e verifica no SharedPreferences se o usuário já viu a introdução.
2. **Onboarding**: 3 páginas explicando o app, com a opção "Não mostrar novamente". Se o usuário já marcou a opção, o app vai direto para a tela principal.
3. **Tela principal**: barra de navegação inferior com três abas:
   - **Início**: lista com os relatos enviados pelo usuário (no topo) e as ruas monitoradas (dados da API). Ao tocar em uma rua abre a tela de **Detalhes**.
   - **Reportar**: formulário para enviar um relato. Depois de enviar, o app volta para a aba Início, onde o relato aparece no topo da lista.
   - **Perfil**: tem o atalho para **Meus Relatos**, onde também é possível excluir relatos (o app pede confirmação antes de apagar).


## API utilizada

**Open-Meteo** (https://open-meteo.com): API REST pública e gratuita, sem chave.

- Endpoint: `GET https://api.open-meteo.com/v1/forecast`
- Parâmetros: `latitude`, `longitude` (todas as ruas na mesma chamada), `daily=precipitation_sum`, `forecast_days=1` e `timezone=America/Sao_Paulo`
- A resposta é uma lista com um item para cada rua. Exemplo de um item:

```json
{
  "daily": {
    "time": ["2026-11-08"],
    "precipitation_sum": [12.5]
  }
}
```

O JSON é convertido para o model `Rua` (`Rua.fromJson`). O risco é calculado pela quantidade de chuva prevista:

| Chuva prevista hoje | Risco |
|---|---|
| menos de 10 mm | Seguro |
| de 10 mm até 30 mm | Atenção |
| 30 mm ou mais | Alto risco |

A tela inicial trata os 4 estados com o enum `EstadoTela`:

- **inicial**: antes de carregar
- **carregando**: mostra o indicador de progresso
- **sucesso**: mostra a lista
- **erro**: mostra uma mensagem e o botão "Tentar novamente"

## Arquitetura

```
lib/
  main.dart
  data/           dados fixos (lista de ruas monitoradas)
  models/         Rua, Local, Relato, PaginaIntro, EstadoTela
  services/       ApiService (http) e PreferencesService (SharedPreferences)
  repositories/   RelatoRepository (salva os relatos no aparelho)
  widgets/        RuaCard, RelatoCard, RiscoChip, MensagemView, OnboardingPage
  screens/        Splash, Onboarding, MainNavigator, Home, Detalhes,
                  Reportar, Perfil, MeusRelatos
```

- **screens**: telas do app. Cuidam da interface e do estado, usando `StatefulWidget` e `setState`. Telas sem estado (Detalhes e Perfil) são `StatelessWidget`.
- **models**: classes de dados. A regra que transforma a chuva em risco fica no model `Rua`.
- **services**: `ApiService` faz a requisição HTTP e `PreferencesService` guarda a preferência do onboarding.
- **repositories**: `RelatoRepository` salva e lê os relatos (em JSON) no SharedPreferences.
- **widgets**: componentes criados por nós e reutilizados em mais de uma tela (`RiscoChip` aparece na lista, nos detalhes e nos relatos; `RelatoCard` é usado na tela inicial e em Meus Relatos; `MensagemView` é usado nos estados de erro e de lista vazia).
- **Atualização da tela inicial**: o `MainNavigator` guarda uma `GlobalKey` da Home. Quando um relato é enviado ou excluído, ele chama `carregarRelatos()` da Home, que lê os relatos de novo e atualiza a lista com `setState`.

## Funcionalidades

- Splash com logo, transição automática e verificação do SharedPreferences
- Onboarding com 3 páginas, botões avançar/voltar e "Não mostrar novamente"
- Navegação com `Navigator` (push, pushReplacement e pop), passagem de parâmetro (`DetalhesScreen(rua: rua)`) e barra de navegação inferior
- Consumo de API REST com o pacote `http`
- Busca de ruas e relatos, ver detalhes da rua, atualizar a lista, enviar relato e excluir relato (com confirmação)
- Relatos enviados aparecem no topo da lista da tela inicial
- Formulário com validação

## Como executar

```
flutter pub get
flutter run
```
