# 04 - Decisoes Arquiteturais

**Escopo**: Registro das principais decisoes arquiteturais do projeto e seus impactos tecnicos  
**Ultima Atualizacao**: 2026-06-13  
**Responsavel**: Equipe Tecnica do Projeto

## Contexto

O aplicativo da Paroquia Sao Lourenco evoluiu para um ecossistema Flutter multiplataforma com backend cloud e modulos de dominio. Este documento consolida as decisoes arquiteturais centrais para manter consistencia tecnica entre implementacao, documentacao e evolucao futura.

## Decisoes Arquiteturais

### Decisao: adotar Flutter multiplataforma

- **Rationale**: compartilhamento de codigo entre Android, iOS e Web, com menor custo operacional.
- **Alternativas Consideradas**: desenvolvimento nativo por plataforma.
- **Impactos**: acelera entregas e manutencao; exige disciplina de compatibilidade entre plataformas.

### Decisao: usar Firebase como backend principal

- **Rationale**: autenticacao, persistencia e sincronizacao em tempo real com menor overhead de infraestrutura.
- **Alternativas Consideradas**: backend REST customizado, provedores cloud alternativos.
- **Impactos**: simplifica operacao e escala; aumenta acoplamento com servicos Firebase.

### Decisao: usar Flutter Modular para composicao por modulos e rotas

- **Rationale**: organizacao clara de binds e rotas por modulo funcional.
- **Alternativas Consideradas**: service locator puro sem estrutura modular.
- **Impactos**: melhora separacao de responsabilidades; requer padronizacao de convencoes por modulo.

### Decisao: usar MobX para estado reativo

- **Rationale**: modelo observavel direto para controllers e atualizacao da UI.
- **Alternativas Consideradas**: Redux, Bloc, Provider puro.
- **Impactos**: boa produtividade para estado local e assincrono; exige controle de complexidade em controllers.

### Decisao: adotar OneSignal para notificacoes push

- **Rationale**: segmentacao de audiencia e operacao multicanal simplificada.
- **Alternativas Consideradas**: FCM puro para todos os cenarios.
- **Impactos**: melhora campanhas e engajamento; adiciona dependencia externa no pipeline de notificacoes.

### Decisao: tratar Graphify como fonte auxiliar

- **Rationale**: acelerar descoberta de relacoes tecnicas sem comprometer confiabilidade documental.
- **Alternativas Consideradas**: promover inferencias automaticamente para fatos arquiteturais.
- **Impactos**: documentacao permanece ancorada em codigo e docs primarias; exige curadoria manual continua.

## Relacoes e Dependencias

| Topico Relacionado            | Tipo de Relacao | Natureza                                                            |
| ----------------------------- | --------------- | ------------------------------------------------------------------- |
| `01-VISAO-CONTEXTO.md`        | Alinhamento     | Decisoes sustentam fronteiras, atores e plataformas                 |
| `02-MODULOS-COMPONENTES.md`   | Dependencia     | Padroes de modularizacao, DI e estado refletem decisoes registradas |
| `03-INTEGRAÇÕES-DADOS.md`     | Dependencia     | Integracoes Firebase/OneSignal derivam das escolhas de arquitetura  |
| `ANEXO-GRAPHIFY-CURADORIA.md` | Governanca      | Confirma uso do Graphify como apoio e nao como fonte normativa      |

## Impactos e Rastreabilidade

- **Afeta Modulos**: `lib/app/modules/*`, `lib/app/shared/*`, inicializacao global do app.
- **Referencias no Codigo**: `lib/main.dart`, `lib/app/app_module.dart`, `lib/app/app_controller.dart`, `pubspec.yaml`.
- **Documentacao Relacionada**: `docs/arquitetura/INDICE.md`, `docs/arquitetura/COBERTURA-MINIMA.md`, `docs/IMPLEMENTACAO_ONESIGNAL.md`.
- **Evidencia**: validacao cruzada com estrutura de `lib/app/modules` e `graphify-out/*`.

## Notas de Atualizacao

Este documento foi validado contra:

- ✓ Estrutura real do repositorio em 2026-06-13
- ✓ Modulos existentes em `lib/app/modules/`
- ✓ Composicao global em `lib/app/app_module.dart`
- ✓ Integracoes e bootstrap em `lib/main.dart`
- ✓ Curadoria registrada em `ANEXO-GRAPHIFY-CURADORIA.md`

**Proxima revisao**: sempre que houver mudancas em modularizacao, estrategia de estado, integracoes externas ou plataforma alvo.
