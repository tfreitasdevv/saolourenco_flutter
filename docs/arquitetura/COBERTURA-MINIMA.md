# Critérios de Cobertura Mínima Arquitetural

Este documento define os critérios objetivos para cobertura mínima de documentação arquitetural.

## Verificação de Completude

Após produzir a documentação baseline, verificar se os seguintes elementos estão presentes:

### ✓ Cobertura: Visão de Contexto

A documentação DEVE incluir:

- [ ] **Definição executiva do sistema**: O que é, qual é seu propósito principal
- [ ] **Atores principais**: Usuários, sistemas externos, dependências críticas
- [ ] **Fronteiras arquiteturais**: O que está dentro do escopo, o que está fora
- [ ] **Integração com sistemas externos**: Firebase, OneSignal, APIs, serviços de pagamento, etc
- [ ] **Plataformas suportadas**: Web, iOS, Android, admin, público

**Artefato**: `01-VISAO-CONTEXTO.md`

### ✓ Cobertura: Módulos e Componentes

A documentação DEVE incluir:

- [ ] **Mapa hierárquico de módulos**: Estrutura de pastas em `lib/` com identificação clara
- [ ] **Responsabilidades por camada**:
  - [ ] Camada de apresentação (UI/screens)
  - [ ] Camada de negócios (services, providers, bloc)
  - [ ] Camada de dados (repositories, models, local storage)
  - [ ] Camada de integração (APIs, Firebase)
- [ ] **Componentes reutilizáveis**: Widgets, helpers, utilities
- [ ] **Padrões de comunicação**: Como componentes se relacionam (Provider, Bloc, callbacks)
- [ ] **Referências no código**: Caminhos específicos (`lib/features/`, `lib/core/`, etc)

**Artefato**: `02-MODULOS-COMPONENTES.md`

### ✓ Cobertura: Integrações Externas e Dados

A documentação DEVE incluir:

- [ ] **Serviços Firebase**:
  - [ ] Firebase Authentication (sign-up, sign-in, sign-out)
  - [ ] Cloud Firestore (modelo de dados, coleções)
  - [ ] Storage (armazenamento de arquivos)
  - [ ] Analytics
  - [ ] Hosting (distribuição web)
- [ ] **Serviços de terceiros**:
  - [ ] OneSignal (notificações push)
  - [ ] Outros (pagamento, SMS, maps, etc)
- [ ] **Fluxos de dados críticos**:
  - [ ] Autenticação e autorização
  - [ ] Sincronização de dados
  - [ ] Persistência local vs remota
  - [ ] Tratamento offline
- [ ] **Segurança e proteção de dados sensíveis**: Como credenciais, dados pessoais e tokens são tratados
- [ ] **Tratamento de falhas**: Retry, fallback, circuit breaker

**Artefato**: `03-INTEGRAÇÕES-DADOS.md`

### ✓ Cobertura: Decisões Arquiteturais

A documentação DEVE incluir:

- [ ] **Decisões principais tomadas**:
  - Framework (Flutter)
  - Gerenciamento de estado (Provider, Bloc)
  - Persistência local (sqflite, shared_preferences)
  - Padrões de divisão de responsabilidades
- [ ] **Rationale**: Por que cada decisão foi tomada
- [ ] **Alternativas consideradas e descartadas**: Contexto de rejeição
- [ ] **Impactos técnicos**: Manutenção, performance, escalabilidade

**Artefato**: `04-DECISOES-ARQUITETURAIS.md`

## Processo de Validação

Para cada artefato produzido, verificar:

1. **Contra código-fonte**:
   - Estrutura de pastas (`lib/`) corresponde à hierarquia documentada
   - Componentes listados existem e estão localizáveis
   - Responsabilidades descritas refletem o que está implementado

2. **Contra Graphify** (se aplicável):
   - Relações documentadas coincidem com dependências reais
   - Componentes importantes não foram omitidos
   - Insumos de Graphify foram validados manualmente

- Inferências aceitas foram registradas com evidência primária e inferências rejeitadas não foram promovidas a fatos arquiteturais

3. **Contra documentação oficial**:
   - Referências a Flutter, Firebase, OneSignal, etc estão de acordo com versões usadas no projeto
   - Não há contradições com docs existentes em `docs/`

## Checklist de Conclusão

- [ ] Visão de Contexto documentada e validada
- [ ] Módulos e Componentes mapeados
- [ ] Integrações Externas e Fluxos de Dados descritos
- [ ] Decisões Arquiteturais registradas
- [ ] Todos os artefatos referenciam código-fonte real
- [ ] Graphify foi consultado e insumos foram curados
- [ ] Há registro explícito da distinção entre fonte auxiliar e fonte normativa
- [ ] Nenhuma contradição entre artefatos
- [ ] Índice de navegação está atualizado
