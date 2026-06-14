# Template: Documentação Arquitetural

Este documento define o template mínimo para artefatos de documentação arquitetural do projeto.

## Estrutura Mínima Obrigatória

Cada documento arquitetural DEVE incluir as seguintes seções:

### 1. Identificação do Tópico

```
# [Título do Tópico Arquitetural]

**Escopo**: Descrição breve do escopo e abrangência
**Última Atualização**: Data no formato YYYY-MM-DD
**Responsável**: Quem mantém este artefato
```

### 2. Contexto

```
## Contexto

Explicar por que este tópico é relevante arquiteturalmente.
Incluir histórico, motivação e decisões que levaram à atual organização.
```

### 3. Componentes ou Tópicos Principais

```
## Componentes / Tópicos Principais

Descrever os principais elementos, módulos ou fluxos.
Organizar hierarquicamente e incluir responsabilidades.

### [Componente A]
- Responsabilidade: ...
- Relações: ...
- Referência no código: `lib/path/to/component`

### [Componente B]
- Responsabilidade: ...
```

### 4. Decisões Arquiteturais

```
## Decisões Arquiteturais

### Decisão: [Título]
- **Rationale**: Por que foi tomada
- **Alternativas Consideradas**: Opções rejeitadas e por quê
- **Impactos**: Efeitos técnicos, de manutenção, de performance
```

### 5. Relações e Dependências

```
## Relações e Dependências

Descrever como este tópico se relaciona com outros artefatos arquiteturais.

| Tópico Relacionado | Tipo de Relação | Natureza |
|---|---|---|
| [Outro Módulo] | Dependência | Sincronismo crítico em fluxos X |
| [Serviço Externo] | Integração | REST API com retry |
```

### 6. Impactos e Rastreabilidade

```
## Impactos e Rastreabilidade

- **Afeta Módulos**: Listar módulos impactados
- **Referências no Código**: Caminhos específicos (ex: `lib/features/auth/**`)
- **Documentação Relacionada**: Links para outras docs técnicas ou specs
- **Evidência**: Apontamentos para evidências no repositório (ex: Graphify, análises)
```

### 7. Abordagem de Validação

```
## Notas de Atualização

Este documento foi validado contra:
- ✓ Estrutura real do repositório em data X
- ✓ Código-fonte analisado até commit HASH
- ✓ Graphify report data Y (se aplicável)
- ✓ Classificação explícita entre fonte normativa e fonte auxiliar
- [ ] Revisão por especialista em domínio

**Próxima revisão**: Agendar se houver mudanças relevantes em módulos, integrações ou camadas.
```

## Critérios Objetivos de Cobertura Mínima

Para cada tópico arquitetural principal, deve-se verificar:

| Aspecto                   | Critério                                          | Checklist                                                                                                                                                                              |
| ------------------------- | ------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Visão de Contexto**     | Sistema, fronteiras, atores externos              | [ ] Diagrama ou descrição executiva<br/>[ ] Principais módulos funcio nais<br/>[ ] Integrações externas (Firebase, OneSignal, etc)                                                     |
| **Módulos e Componentes** | Organização por camadas, responsabilidades        | [ ] Mapa hierárquico de módulos<br/>[ ] Responsabilidades claras por camada<br/>[ ] Relações entre componentes<br/>[ ] Referências a código-fonte                                      |
| **Integrações Externas**  | Serviços, protocolos, fluxos críticos             | [ ] Lista de integrações (ex: Firebase Auth, Firestore)<br/>[ ] Protocolo e frequência de interação<br/>[ ] Fluxos críticos (autenticação, sincronização)<br/>[ ] Tratamento de falhas |
| **Dados**                 | Modelo, fluxos, integridade em nível arquitetural | [ ] Fluxos de dados críticos<br/>[ ] Persistência (local vs remoto)<br/>[ ] Sincronização e consistência<br/>[ ] Proteção de dados sensíveis                                           |

## Exemplo Mínimo de Documento

```markdown
# Visão de Contexto - Paróquia São Lourenço

**Escopo**: Sistema Flutter completo (mobile, web, admin)  
**Última Atualização**: 2026-06-13  
**Responsável**: Equipe Técnica

## Contexto

O aplicativo da Paróquia São Lourenço é um sistema mobile/web que permite...

## Principais Fronteiras e Atores

- **Usuário Fiel**: Acesso via app mobile (iOS/Android)
- **Gestor Paroquial**: Acesso via web admin
- **Backend Firebase**: Autenticação, dados em tempo real, armazenamento
- ...

## Decisões Arquiteturais

### Decisão: Usar Firebase como backend

- Rationale: Escalabilidade, real-time, autenticação gerenciada
- Alternativas: Backend REST customizado (descartado por overhead operacional)

## Validação

- ✓ Estrutura do repositório revisada em 2026-06-13
- ✓ Code analisado até main
- ✓ Graphify validado
```

---

**Uso**: Copie esta estrutura ao criar novos artefatos em `docs/arquitetura/`.  
Adapte seções conforme necessário, mas mantenha as obrigatórias (Identificação, Contexto, Decisões, Validação).
Quando usar Graphify, registre explicitamente quais pontos foram apenas levantados, quais foram confirmados e quais foram descartados.
