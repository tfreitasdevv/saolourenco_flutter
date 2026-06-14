## Context

A documentacao arquitetural do projeto ja existe em Markdown dentro de `docs/arquitetura`, com indice, conteudos tematicos e anexo de curadoria Graphify. O problema atual nao e de conteudo, e sim de consumo: a leitura depende de abrir varios arquivos, o que dificulta navegacao, compartilhamento e revisao rapida.

Esta change transforma o material existente em uma publicacao HTML completa, preservando os arquivos Markdown como fonte normativa e gerando uma visao unica, navegavel e detalhada da arquitetura.

## Goals / Non-Goals

**Goals:**

- Gerar uma saida HTML completa a partir da documentacao em `docs/arquitetura`.
- Manter rastreabilidade para os arquivos Markdown originais.
- Oferecer navegacao clara entre indice, secoes e anexos.
- Preservar cobertura dos topicos arquiteturais ja documentados.

**Non-Goals:**

- Reescrever a documentacao de arquitetura em outro formato fonte.
- Alterar o conteudo tecnico base dos artefatos Markdown.
- Introduzir um CMS ou dependencia pesada de runtime para servir a documentacao.
- Refatorar o app Flutter de producao.

## Decisions

### Decisao: gerar HTML estatico a partir dos Markdown existentes

- **Rationale**: a documentacao ja esta consolidada; a melhor forma de entregar valor rapido e renderiza-la em HTML sem duplicar a autoria do conteudo.
- **Alternatives Considered**: manter apenas Markdown, ou criar uma nova doc interna manualmente em HTML.
- **Impacts**: reduz custo de manutencao e evita divergencia entre formatos.

### Decisao: preservar Markdown como fonte normativa

- **Rationale**: o repositorio ja usa Markdown como fonte oficial dos artefatos OpenSpec e da documentacao arquitetural.
- **Alternatives Considered**: transformar HTML em fonte primaria.
- **Impacts**: o HTML vira uma camada de publicacao, nao de autoria.

### Decisao: incluir indice, links entre secoes e ancoras internas

- **Rationale**: o principal ganho da versao HTML e a navegacao contextual entre contexto, modulos, integracoes, decisoes e curadoria.
- **Alternatives Considered**: pagina unica sem ancoras ou espelhamento 1:1 dos arquivos sem navegação unificada.
- **Impacts**: melhora a experiencia de leitura e revisao, principalmente em telas maiores.

### Decisao: manter o conteudo totalmente offline-friendly

- **Rationale**: a documentacao deve ser consultavel mesmo sem dependencia de backend ou autenticacao.
- **Alternatives Considered**: hospedar via app dinamico com dados carregados em runtime.
- **Impacts**: facilita distribuicao, arquivamento e revisao local no navegador.

### Decisao: gerar saida sem alterar o conteudo tecnico existente

- **Rationale**: a change e de publicacao, nao de revisao de arquitetura.
- **Alternatives Considered**: atualizar simultaneamente o texto base de todos os documentos.
- **Impacts**: reduz risco e isola o escopo.

## Risks / Trade-offs

- [Risco] A saida HTML ficar desatualizada se os Markdown forem alterados sem regeneracao → Mitigacao: documentar o HTML como artefato derivado e exigir regeneracao no fluxo de revisao.
- [Risco] Conteudo extenso pode gerar pagina longa e pesada → Mitigacao: usar indice fixo, secoes colapsaveis e estrutura por capitulos.
- [Risco] Duplicacao de formatos pode confundir autores → Mitigacao: explicitar que Markdown continua sendo a fonte normativa.
- [Risco] A navegacao pode perder fidelidade se ancoras nao refletirem os titulos reais → Mitigacao: gerar ancoras a partir da estrutura canonica atual dos documentos.

## Migration Plan

1. Ler os artefatos Markdown atuais em `docs/arquitetura` como base de conteudo.
2. Definir o layout HTML, indexacao interna e a relacao entre secoes.
3. Gerar a versao HTML completa como artefato derivado.
4. Validar se a navegacao preserva a cobertura dos topicos existentes.
5. Registrar o fluxo de regeneracao para futuras atualizacoes da documentacao.

Rollback:

- Se a geracao HTML nao ficar satisfatoria, manter a documentacao Markdown como entrega principal e descartar apenas a saida derivada, sem impacto no conteudo normativo.

## Open Questions

- A saida HTML deve ser um unico arquivo consolidado ou um conjunto de paginas interligadas?
- O artefato HTML deve ficar versionado em `docs/arquitetura` ou em uma pasta separada de publicacao?
- Deve existir um comando/script de regeneracao automatica vinculado ao fluxo de atualizacao arquitetural?
