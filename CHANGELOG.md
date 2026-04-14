# Changelog

Todas as mudancas relevantes deste projeto devem ser registradas neste arquivo.

Este documento segue a ideia de organizacao do Keep a Changelog, adaptada ao contexto do projeto.

## [Unreleased]

### Added

- Estrutura inicial do changelog criada para registrar mudancas relevantes do projeto com padrao consistente.

### Changed

- Diretrizes do Copilot atualizadas para tornar obrigatoria a manutencao do `CHANGELOG.md`.

### Fixed

- Corrigido o build Android no WSL ao remover configuracao de `org.gradle.java.home` com caminho Windows.
- Corrigido o caminho da keystore Android para um caminho Linux compativel com WSL.
- Corrigidos travamentos de caches Kotlin e artefatos Java no build Android por meio de limpeza de caches locais e recompilacao.
