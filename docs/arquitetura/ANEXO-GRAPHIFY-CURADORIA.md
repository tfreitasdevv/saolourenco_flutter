# Anexo - Curadoria de Insumos Graphify

**Escopo**: Registro das inferências arquiteturais levantadas a partir de `graphify-out/` e validadas manualmente contra código-fonte e documentação primária do repositório  
**Última Atualização**: 2026-06-13  
**Responsável**: Equipe Técnica do Projeto

## Contexto

Os artefatos em `graphify-out/` foram usados como apoio para descoberta inicial de relações entre bootstrap da aplicação, composição modular e integrações externas.
Este anexo registra apenas os pontos que passaram por validação manual.

## Fontes Consultadas

### Fontes auxiliares

- `graphify-out/GRAPH_REPORT.md`
- `graphify-out/graph.json`
- `graphify-out/manifest.json`

### Fontes primárias de validação

- `lib/main.dart`
- `lib/app/app_module.dart`
- `docs/IMPLEMENTACAO_ONESIGNAL.md`
- `docs/FLUTTER_WEB_SETUP_CONCLUIDO.md`
- `web/index_secure.html`

## Inferências levantadas e curadas

| Item                                                            | Sinal inicial do Graphify                                                                        | Validação manual                                                                                                                                          | Status                |
| --------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| Bootstrap Firebase no startup                                   | Community hub `firebase options env.dart main.dart` em `GRAPH_REPORT.md`                         | `lib/main.dart` inicializa `Firebase.initializeApp` com `DefaultFirebaseOptions.currentPlatform`                                                          | Validado              |
| Inicialização de push notifications no startup                  | Referência conjunta a `main.dart` e `PushNotificationService` em `graph.json` e buscas derivadas | `lib/main.dart` instancia `PushNotificationService` e executa `initialize()` antes de `runApp`                                                            | Validado              |
| AppModule como ponto central de DI e rotas globais              | Community hubs `app module.dart AppModule binds` e `home module.dart binds routes`               | `lib/app/app_module.dart` registra `LocalUser`, `AuthRepository`, `PushNotificationService`, `AppController` e rotas globais                              | Validado              |
| Pipeline documental de OneSignal                                | Hyperedge `hyperedge_onesignal_delivery_pipeline` com confiança `EXTRACTED` em `graph.json`      | `docs/IMPLEMENTACAO_ONESIGNAL.md` consolida setup, testes e segurança da integração OneSignal já presente no app                                          | Validado              |
| Relação entre bootstrap web seguro e documentação de setup/CORS | Hyperedge `hyperedge_web_bootstrap_security_cors` com confiança `INFERRED` em `graph.json`       | `web/index_secure.html` contém placeholders e guarda de configuração Firebase; `docs/FLUTTER_WEB_SETUP_CONCLUIDO.md` descreve o fluxo de configuração web | Validado com ressalva |

## Ressalvas de curadoria

- Itens marcados como `INFERRED` no Graphify não foram promovidos automaticamente a fatos arquiteturais.
- Relações ambíguas ou estritamente visuais, como conexões entre ícones, assets e branding, foram descartadas por não agregarem valor à arquitetura funcional.
- Hiperarestas documentais foram aceitas apenas quando o conteúdo primário do repositório confirmou a relação operacional descrita.

## Decisões Arquiteturais

### Decisão: usar Graphify apenas para descoberta assistida

- **Rationale**: o grafo acelera a identificação de pontos de acoplamento e documentação relacionada, mas mistura evidências extraídas com inferências probabilísticas.
- **Alternativas Consideradas**: promover automaticamente hubs e hyperedges a fatos arquiteturais foi descartado por risco de registrar relações não verificadas.
- **Impactos**: a documentação arquitetural permanece lastreada em fontes primárias, com Graphify atuando como apoio de investigação.

## Relações e Dependências

| Tópico Relacionado          | Tipo de Relação        | Natureza                                                        |
| --------------------------- | ---------------------- | --------------------------------------------------------------- |
| `02-MODULOS-COMPONENTES.md` | Evidência complementar | Curadoria de composição modular e ponto central de DI           |
| `03-INTEGRAÇÕES-DADOS.md`   | Evidência complementar | Curadoria de bootstrap Firebase, push notifications e fluxo web |
| `INDICE.md`                 | Governança             | Reforça o uso controlado de fontes auxiliares                   |

## Impactos e Rastreabilidade

- **Afeta Módulos**: inicialização global, autenticação compartilhada e notificações
- **Referências no Código**: `lib/main.dart`, `lib/app/app_module.dart`, `web/index_secure.html`
- **Documentação Relacionada**: `docs/IMPLEMENTACAO_ONESIGNAL.md`, `docs/FLUTTER_WEB_SETUP_CONCLUIDO.md`
- **Evidência**: `graphify-out/GRAPH_REPORT.md`, `graphify-out/graph.json`, `graphify-out/manifest.json`

## Notas de Atualização

Este documento foi validado contra:

- ✓ Estrutura real do repositório em 2026-06-13
- ✓ Código-fonte analisado em `lib/main.dart` e `lib/app/app_module.dart`
- ✓ Documentação técnica existente sobre OneSignal e setup web
- ✓ Insumos de Graphify curados manualmente antes do registro

**Próxima revisão**: sempre que novos relatórios do Graphify forem usados para sustentar atualização arquitetural.
