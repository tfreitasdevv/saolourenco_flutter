---
name: error-hero
description: "Monitora erros do desenvolvimento do projeto, registra falhas relatadas pelo usuario no prompt e erros encontrados pelo agente do Copilot durante analise, build, teste ou validacao, e atualiza a base de conhecimento em docs/error-hero com causa, solucao, validacao e origem da evidencia."
argument-hint: "Descreva o erro, contexto, comando executado e saida relevante"
user-invocable: true
disable-model-invocation: false
---

# Error Hero

Skill para consolidar uma base de conhecimento de erros do projeto em `docs/error-hero`.

## Quando usar

Use esta skill quando houver qualquer erro tecnico durante o desenvolvimento, incluindo:

- erros explicitados pelo usuario no prompt
- erros encontrados pelo agente do Copilot ao executar comandos, builds, testes, validacoes ou leitura de logs
- falhas recorrentes que precisem de historico de causa raiz e passos de recuperacao
- necessidade de transformar incidentes soltos em documentacao reutilizavel

## Objetivo

Ao ser acionada, esta skill deve:

1. Capturar o erro com o maximo de contexto util sem inventar informacao.
2. Classificar claramente a origem da evidencia.
3. Registrar a causa raiz confirmada ou a melhor hipotese validada.
4. Documentar a solucao aplicada ou recomendada.
5. Atualizar a base de conhecimento em `docs/error-hero/BASE_DE_CONHECIMENTO.md` e criar ou manter um arquivo detalhado por incidente em `docs/error-hero/incidentes/`.

## Regra obrigatoria de classificacao da origem

Todo erro registrado deve conter um campo `Origem da evidencia` com um destes valores:

- `Usuario`: quando o erro foi informado explicitamente pelo usuario no prompt, anexos, logs ou capturas
- `Agente Copilot`: quando o erro foi encontrado pelo agente ao executar comandos, builds, testes, validacoes ou analises
- `Usuario + Agente Copilot`: quando o usuario relatou o erro e o agente tambem o observou, reproduziu ou validou no fluxo

Nunca misture as origens sem declarar isso no documento.

## Procedimento

1. Ler o prompt atual e extrair mensagens de erro, comando executado, plataforma, arquivo envolvido e contexto.
2. Inspecionar saidas de terminal, erros de build, problemas de compilacao e resultados de validacao gerados durante o trabalho do agente.
3. Deduplicar erros ja documentados antes de criar nova entrada.
4. Atualizar `docs/error-hero/BASE_DE_CONHECIMENTO.md` como indice da base.
5. Criar ou atualizar um arquivo detalhado por incidente em `docs/error-hero/incidentes/`, preferindo iniciar pelo modelo `docs/error-hero/incidentes/TEMPLATE_INCIDENTE.md`.
6. Em cada registro detalhado, preencher no minimo:
   - `ID`
   - `Titulo`
   - `Categoria`
   - `Origem da evidencia`
   - `Contexto`
   - `Sintoma`
   - `Causa raiz`
   - `Solucao`
   - `Validacao`
   - `Arquivos envolvidos`
   - `Status`
7. Manter no indice apenas resumo, origem, status e apontador para o arquivo detalhado.
8. Nomear novos incidentes com o proximo ID livre no formato `EH-NNN` e arquivo `EH-NNN-slug-descritivo.md`.
9. Classificar cada incidente em uma categoria funcional, preferindo `Android`, `Web`, `Firebase`, `Build`, `Infra`, `Dados`, `UI` ou `Outros`.
10. Se a causa raiz nao estiver confirmada, marcar isso explicitamente em vez de especular.
11. Quando houver comandos de recuperacao, registrar uma sequencia pronta para reaplicacao.

## Regras de qualidade

- Nao registrar erros hipoteticos.
- Nao ocultar se o erro veio do usuario ou do agente.
- Preferir causa raiz a solucao superficial.
- Reutilizar entradas existentes quando for o mesmo problema com nova evidencia.
- Manter o texto objetivo e util para futuras recuperacoes.

## Estrutura esperada da base

O arquivo principal da base de conhecimento deve ser `docs/error-hero/BASE_DE_CONHECIMENTO.md`, funcionando como indice.

Cada incidente deve ter um arquivo proprio em `docs/error-hero/incidentes/`.

O template base para novos registros deve ser `docs/error-hero/incidentes/TEMPLATE_INCIDENTE.md`.

Novos incidentes devem seguir o padrao sequencial `EH-NNN` e nome de arquivo `EH-NNN-slug-descritivo.md`.

Cada incidente deve seguir este formato:

```markdown
## EH-000 - Titulo do erro

- Categoria: Android | Web | Firebase | Build | Infra | Dados | UI | Outros
- Origem da evidencia: Usuario | Agente Copilot | Usuario + Agente Copilot
- Contexto: onde e quando aconteceu
- Sintoma: mensagem principal do erro
- Causa raiz: causa confirmada ou hipotese validada
- Solucao: alteracao aplicada ou procedimento recomendado
- Validacao: como foi confirmado que a correcao funcionou
- Arquivos envolvidos: caminhos relevantes
- Status: resolvido | mitigado | em investigacao
```

## Resultado esperado

Ao final, `docs/error-hero/BASE_DE_CONHECIMENTO.md` deve funcionar como indice consultavel de incidentes do projeto, enquanto os detalhes ficam em arquivos separados dentro de `docs/error-hero/incidentes/`, sempre deixando explicito o que foi relatado pelo usuario e o que foi observado pelo agente do Copilot.
