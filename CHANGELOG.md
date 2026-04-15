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

- Diretrizes do Copilot atualizadas para tornar obrigatoria a manutencao do `CHANGELOG.md`.

### Fixed

- Corrigido o build Android no WSL ao remover configuracao de `org.gradle.java.home` com caminho Windows.
- Corrigido o caminho da keystore Android para um caminho Linux compativel com WSL.
- Corrigidos travamentos de caches Kotlin e artefatos Java no build Android por meio de limpeza de caches locais e recompilacao.
