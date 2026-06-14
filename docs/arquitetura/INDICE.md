# Documentação Arquitetural - Paróquia São Lourenço

Índice de navegação para os artefatos arquiteturais do projeto Flutter.

## Estrutura Canônica

Esta documentação está organizada por tópicos arquiteturais com cobertura mínima obrigatória:

### 1. Visão de Contexto

- [01-VISAO-CONTEXTO.md](01-VISAO-CONTEXTO.md) - Visão executiva, fronteiras do sistema e integrações externas

### 2. Organização Modular

- [02-MODULOS-COMPONENTES.md](02-MODULOS-COMPONENTES.md) - Organização por camadas, módulos e responsabilidades

### 3. Integrações Externas

- [03-INTEGRAÇÕES-DADOS.md](03-INTEGRAÇÕES-DADOS.md) - Integrações com serviços externos e fluxos de dados críticos

### 4. Decisões Arquiteturais

- [04-DECISOES-ARQUITETURAIS.md](04-DECISOES-ARQUITETURAIS.md) - Decisões, trade-offs e rationale arquitetural

### 5. Curadoria de Fontes Auxiliares

- [ANEXO-GRAPHIFY-CURADORIA.md](ANEXO-GRAPHIFY-CURADORIA.md) - Registro das inferências levantadas com Graphify e da validação contra fontes primárias

## Convenções de Navegação

- **Estrutura**: Documentos nomeados numericamente com identificação clara de tópico
- **Atualização**: Mudanças com impacto arquitetural DEVEM incluir revisão dos artefatos pertinentes
- **Rastreabilidade**: Referências para código-fonte, estrutura do repositório e decisões técnicas
- **Validação**: Insumos de ferramentas analíticas (ex: Graphify) DEVEM ser validados contra código e docs oficiais antes de publicação
- **Hierarquia de fontes**: Código-fonte e documentação técnica do repositório são fontes normativas; Graphify é apoio investigativo

## Insumos Auxiliares

Este projeto aproveita dados analíticos como insumo de descoberta:

- `graphify-out/GRAPH_REPORT.md` - Análise de dependências e componentes
- `graphify-out/graph.json` - Grafo de relações (formato estruturado)
- `graphify-out/manifest.json` - Metadados do projeto
- `ANEXO-GRAPHIFY-CURADORIA.md` - Curadoria das inferências efetivamente aceitas na documentação arquitetural

⚠️ **Nota Importante**: Graphify é fonte **auxiliar**, não **normativa**. Todas as inferências DEVEM ser confirmadas no código-fonte antes de serem registradas na documentação.

## Processo de Atualização Contínua

### Gatilho de Revisão Arquitetural

Revisar e atualizar artefatos em `docs/arquitetura` quando mudanças impactarem:

- ✓ Módulos ou componentes principais
- ✓ Integrações com serviços externos
- ✓ Camadas ou padrões de comunicação
- ✓ Fluxos de dados críticos

### Checklist de Revisão em Mudanças

Ao trabalhar em mudanças com potencial impacto arquitetural:

- [ ] Identificar se a mudança afeta módulos, camadas ou integrações documentadas
- [ ] Se sim, atualizar artefatos pertinentes em `docs/arquitetura` no mesmo ciclo de entrega
- [ ] Se Graphify for usado, registrar quais inferências foram apenas levantadas e quais foram confirmadas em fontes primárias
- [ ] Validar rastreabilidade entre documentação e implementação
- [ ] Revisar consistência com Graphify e fontes oficiais

## Cobertura Mínima Obrigatória

A documentação arquitetural DEVE cobrir:

1. **Visão de Contexto**: Sistema, fronteiras e atores externos
2. **Módulos e Componentes**: Organização, responsabilidades e relações
3. **Integrações Externas**: Serviços, protocolos e fluxos críticos
4. **Dados**: Modelo e fluxos em nível arquitetural

---

**Última atualização**: 2026-06-13
**Responsável**: Equipe Técnica do Projeto
