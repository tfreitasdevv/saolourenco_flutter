## Why

A documentacao arquitetural atual em `docs/arquitetura` e rica, mas ainda depende de leitura manual em arquivos Markdown separados. Esta change cria uma representacao HTML completa e navegavel para facilitar consulta, compartilhamento e revisao tecnica sem perder rastreabilidade com a fonte original.

## What Changes

- Gerar uma versao HTML detalhada da documentacao arquitetural existente em `docs/arquitetura`.
- Consolidar indice, navegacao entre secoes e links entre artefatos em uma experiencia unica de leitura.
- Preservar a documentacao Markdown como fonte normativa e tratar o HTML como saida de publicacao.
- Estruturar a saida HTML para refletir a cobertura atual: contexto, modulos, integracoes, dados, decisoes e curadoria Graphify.

## Capabilities

### New Capabilities

- `html-documentacao-arquitetural`: publicacao de uma versao HTML completa, detalhada e navegavel da documentacao arquitetural em `docs/arquitetura`.

### Modified Capabilities

- Nenhuma.

## Impact

- Affected docs: `docs/arquitetura/**`.
- Affected code/artifacts: geracao de saida HTML, estrutura de navegacao e assets de publicacao associados.
- Affected systems: processo de revisao tecnica e distribuicao da documentacao.
- Dependencies: conteudo Markdown existente em `docs/arquitetura`, com rastreabilidade para `openspec/changes/archive/2026-06-13-documentacao-arquitetural-projeto` e artefatos relacionados.
