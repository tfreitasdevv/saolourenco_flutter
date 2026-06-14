## Context

O projeto Flutter da Paróquia São Lourenço possui múltiplos módulos de domínio, integrações com Firebase e scripts de build/deploy para web e mobile, porém sem um pacote arquitetural centralizado em `docs/arquitetura`.
Hoje, informações de arquitetura estão dispersas entre código-fonte, guias em `docs/` e artefatos analíticos em `graphify-out`.
Isso reduz previsibilidade em mudanças, dificulta onboarding técnico e torna revisão arquitetural mais reativa.

## Goals / Non-Goals

**Goals:**

- Definir uma estrutura canônica de documentação arquitetural em `docs/arquitetura`.
- Garantir cobertura mínima de visão de contexto, visão de componentes/módulos, integrações externas, dados e decisões arquiteturais.
- Estabelecer processo de atualização da documentação vinculado a mudanças relevantes no código.
- Aproveitar `graphify-out` como insumo opcional de descoberta para acelerar e aumentar completude da documentação.

**Non-Goals:**

- Refatorar código de produção (Flutter, Android, iOS, web) nesta mudança.
- Alterar comportamento funcional do aplicativo.
- Substituir documentação funcional já existente em `docs/` fora do escopo arquitetural.

## Decisions

1. Documentação arquitetural será organizada por tópicos em `docs/arquitetura`.
   Racional: facilita navegação, revisão incremental e manutenção por áreas.
   Alternativas consideradas:

- Arquivo único monolítico: descartado por baixa escalabilidade e alto custo de edição concorrente.
- Documentar apenas em wiki externa: descartado por perder versionamento junto ao código.

2. O conteúdo terá um índice mestre e convenções explícitas.
   Racional: garante consistência entre autores e reduz deriva estrutural ao longo do tempo.
   Alternativas consideradas:

- Convenção implícita sem template: descartado por gerar heterogeneidade.

3. `graphify-out` será usado como fonte auxiliar, não normativa.
   Racional: melhora produtividade e descoberta de relações, mas pode conter inferências ambíguas; a fonte de verdade final continua sendo o código e os docs oficiais.
   Alternativas consideradas:

- Ignorar Graphify: descartado por perder ganho de velocidade em mapeamento inicial.
- Tornar Graphify obrigatório e autoritativo: descartado por risco de documentar inferências incorretas.

4. Atualização arquitetural será tratada como requisito de processo em mudanças relevantes.
   Racional: evita obsolescência da documentação após evolução de módulos, integrações ou fluxos críticos.
   Alternativas consideradas:

- Atualização eventual e manual sem gatilho: descartado por histórico de desatualização.

## Risks / Trade-offs

- [Risco] Documentação inicial ficar incompleta em módulos menos conhecidos.
  → Mitigação: checklist de cobertura mínima e validação cruzada com estrutura real do repositório e Graphify.
- [Risco] Obsolescência após novas features.
  → Mitigação: incluir tarefa explícita de atualização arquitetural em mudanças que afetem módulos/camadas.
- [Trade-off] Maior esforço inicial para criar baseline documental.
  → Mitigação: dividir por artefatos menores e priorizar visão executiva + componentes críticos primeiro.
- [Trade-off] Uso de fonte auxiliar (`graphify-out`) exige curadoria humana.
  → Mitigação: registrar no processo que inferências devem ser confirmadas no código antes de publicação.

## Migration Plan

1. Criar estrutura base em `docs/arquitetura` com índice e documentos nucleares.
2. Preencher baseline com visão de contexto, camadas e módulos principais.
3. Mapear integrações e fluxos de dados críticos com validação manual.
4. Revisar consistência e cobertura mínima.
5. Em mudanças futuras, atualizar os artefatos arquiteturais impactados no mesmo ciclo de entrega.

Rollback:

- Se o padrão adotado não funcionar, manter os arquivos já criados e ajustar apenas estrutura/nomenclatura em revisão posterior, sem impacto de runtime.

## Open Questions

- Quais diagramas (por exemplo, C4 nível 1/2) devem ser padrão obrigatório na primeira versão?
- Qual periodicidade mínima de revisão arquitetural além de mudanças pontuais (mensal/trimestral)?
- Quais responsáveis por domínio (módulos) serão aprovadores técnicos da documentação?
