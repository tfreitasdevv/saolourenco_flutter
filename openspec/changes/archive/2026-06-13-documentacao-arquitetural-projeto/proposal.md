## Why

O projeto possui uma base Flutter ampla e modular, com múltiplos módulos funcionais, integrações Firebase e artefatos de build/deploy, mas sem uma documentação arquitetural consolidada em `docs/arquitetura`.
A ausência dessa visão dificulta onboarding, tomada de decisão técnica e evolução segura da aplicação.

## What Changes

- Criar um conjunto estruturado de documentação arquitetural em `docs/arquitetura` cobrindo visão de contexto, camadas, módulos, dados e integrações.
- Definir um padrão de documentação com seções, nomenclatura e critérios de atualização para manter consistência ao longo do tempo.
- Estabelecer uso opcional e orientado de insumos do `graphify-out` para acelerar descoberta de componentes e relações do código.
- Incluir rastreabilidade entre documentação e elementos reais do repositório (pastas, módulos, integrações e fluxos principais).

## Capabilities

### New Capabilities

- `arquitetura-documentada`: Processo e artefatos padronizados para produzir e manter documentação arquitetural do projeto em `docs/arquitetura`, com cobertura mínima obrigatória e uso opcional de evidências do Graphify.

### Modified Capabilities

- Nenhuma.

## Impact

- Affected docs: `docs/arquitetura/**`.
- Affected process: fluxo de manutenção da documentação técnica e revisão em mudanças arquiteturais.
- Affected systems: sem mudanças de runtime no app; impacto principal em governança técnica e comunicação entre equipes.
- Dependencies: aproveitamento de `graphify-out/GRAPH_REPORT.md`, `graphify-out/graph.json` e `graphify-out/manifest.json` como insumos auxiliares de mapeamento.
