# Changelog

Todas as mudancas relevantes deste projeto devem ser registradas neste arquivo.

Este documento segue a ideia de organizacao do Keep a Changelog, adaptada ao contexto do projeto.

## [Unreleased]

### Added

- Estrutura inicial do changelog criada para registrar mudancas relevantes do projeto com padrao consistente.
- Camada de abstracao para o Strapi CMS (Fase 2 da migracao Firebase → Strapi):
  - `lib/app/shared/config/api_config.dart` — configuracao centralizada de endpoints e URL base da API.
  - `lib/app/shared/services/strapi_client.dart` — cliente HTTP com Dio, interceptor JWT automatico e gerenciamento de token via flutter_secure_storage.
  - `lib/app/shared/auth/strapi_auth_service.dart` — servico de autenticacao Strapi (login, registro, logout, perfil).
- Novas dependencias: `dio` e `flutter_secure_storage` para comunicacao HTTP e armazenamento seguro de tokens.
- Variavel `STRAPI_URL` adicionada ao `.env` do Flutter.
- `StrapiClient` e `StrapiAuthService` registrados como singletons no `AppModule` (Flutter Modular DI).
- Documentacao completa de setup do CMS em novo computador via WSL (secao 9.1 do guia de migracao).

### Changed

- Documentacao da migracao Firebase → Strapi reorganizada: documento unico `docs/MIGRACAO_FIREBASE_STRAPI.md` dividido em 7 arquivos tematicos em `docs/migracao-strapi/` (README, arquitetura, colecoes, padroes, plano, setup e progresso). O documento original agora redireciona para o novo diretorio.
- Decisao de autenticacao atualizada: a autenticacao sera **implementada do zero** com Strapi Users & Permissions, sem herdar ou adaptar o codigo Firebase Auth existente. Motivacao: acoplamento forte ao Firebase, endpoints JWT nativos do Strapi ja disponiveis, e StrapiAuthService ja criado na Fase 2.
- Diretrizes do Copilot atualizadas para tornar obrigatoria a manutencao do `CHANGELOG.md`.
- **Fase 3 da migracao Firebase → Strapi (modulos 3.1 a 3.6):**
  - **Horarios (3.1):** modulo `horarios` migrado do Firestore para a API Strapi (`GET /api/horario-missas`). Dados carregados via `StrapiClient` em vez de `FirebaseFirestore`. Compativel com Android, iOS e Web.
  - **Confissoes (3.2):** modulo `confissoes` migrado do Firestore para a API Strapi (`GET /api/confissoes`). Multiplas requisicoes individuais por documento substituidas por uma unica chamada paginada e ordenada.
  - **Avisos (3.3):** modulo `avisos` migrado do Firestore para a API Strapi (`GET /api/avisos`). Widgets `AvisoCard` e `AvisoCardMarkdown` agora recebem `Map<String, dynamic>` em vez de `DocumentSnapshot`. Imagens populadas via campo de media do Strapi (ImageKit).
  - **Como Ajudar (3.4):** modulo `como_ajudar` migrado do Firestore para a API Strapi (`GET /api/como-ajudars`). Widget `ComoAjudarCard` atualizado para trabalhar com dados JSON do Strapi.
  - **Eventos (3.5):** modulo `eventos` migrado do Firestore para a API Strapi (`GET /api/eventos`). `EventosRepository` convertido de Streams (Firestore real-time) para Futures (HTTP sob demanda). `EventoModel.fromDocument` substituido por `EventoModel.fromJson`. `EventosController` simplificado — removidas StreamSubscriptions e metodo `dispose`.
  - **PastoralPage (3.6):** widget centralizado `PastoralPage` migrado do Firestore para a API Strapi (`GET /api/pastoral-conteudos`). Impacta 23 modulos de pastorais simultaneamente. Extracao de secoes adaptada do formato de maps dinamicos do Firestore para o componente repetivel `secoes` do Strapi. Widget convertido de `StatelessWidget` para `StatefulWidget` para inicializacao do Future no `initState`.
  - **Avisos Musica (3.7a):** sub-modulo `avisos_musica` do modulo Musica migrado do Firestore para a API Strapi (`GET /api/aviso-musicas`). Widget `AvisoMusicaCard` atualizado de `DocumentSnapshot` para `Map<String, dynamic>`. Timestamp convertido de `Timestamp.seconds` para `DateTime.parse` (ISO 8601).
  - **Clero (3.7b):** modulo `sobre/tabs/clero.dart` migrado do Firestore para a API Strapi (`GET /api/cleros`). Widget convertido de `StatelessWidget` para `StatefulWidget` com Future no `initState`. Imagem extraida do objeto media populado do Strapi.
  - **Confissoes Controller (3.7c):** `confissoes_controller.dart` migrado de Firestore para StrapiClient por consistencia (era dead code — nao importado por nenhum modulo).

### Removed

- `lib/app/shared/widgets/firebase_markdown_text.dart` removido — widget de dead code (nunca importado por nenhum arquivo do projeto).

### Fixed

- Corrigido o build Android no WSL ao remover configuracao de `org.gradle.java.home` com caminho Windows.
- Corrigido o caminho da keystore Android para um caminho Linux compativel com WSL.
- Corrigidos travamentos de caches Kotlin e artefatos Java no build Android por meio de limpeza de caches locais e recompilacao.
