# 01 - Visão de Contexto: Paróquia São Lourenço

**Escopo**: Aplicação multiplataforma (iOS, Android, Web) que serve a comunidade e gestão da Paróquia São Lourenço  
**Última Atualização**: 2026-06-13  
**Responsável**: Equipe Técnica do Projeto

## Contexto

O aplicativo da Paróquia São Lourenço é um sistema digital integrado para comunicação e organização de atividades paroquiais. Oferece uma plataforma unificada para membros da comunidade (fiéis, gestores, pastoralistas) acessarem informações institucionais, participarem de eventos, receberem notificações e gerenciarem atividades das diversas pastorais.

O projeto foi inicialmente desenvolvido como versão 1.x e evoluiu para a versão 2.0+, expandindo cobertura de funcionalidades, integrações e suporte a plataformas.

## Fronteiras do Sistema

### Dentro do Escopo (Sistema)

- ✓ Interface mobile (iOS/Android) via Flutter
- ✓ Interface web (PWA/SPA) via Flutter Web
- ✓ Lógica de negócio de pastorais, eventos, avisos
- ✓ Autenticação e autorização de usuários
- ✓ Armazenamento e sincronização de dados
- ✓ Notificações push para mobile
- ✓ Gerenciamento de conteúdo paroquial

### Fora do Escopo (Sistemas Externos)

- ✗ Email pessoal dos usuários (dependência, não implementação)
- ✗ Redes sociais externas (integração pontual, não requisito principal)
- ✗ Sistemas financeiros (ex: processamento de pagamento de dízimos)
- ✗ Sistemas paroquiais legados (ex: controle de missas/eucaristia em sistemas anteriores)

## Atores Principais

| Ator                            | Descrição                          | Plataformas                | Responsabilidades                                                                  |
| ------------------------------- | ---------------------------------- | -------------------------- | ---------------------------------------------------------------------------------- |
| **Fiel/Usuário Comum**          | Membro da comunidade               | Mobile (iOS/Android), Web  | Consultar avisos, eventos, horários; participar de pastorais; receber notificações |
| **Gestor Paroquial**            | Administrador do app               | Web (preferencial), Mobile | Gerenciar avisos, eventos, conteúdo; configurar pastorais; monitorar atividades    |
| **Pastoralista/Coordenador**    | Coordenador de pastoral específica | Web, Mobile                | Atualizar informações de sua pastoral, registrar participantes, gerir atividades   |
| **Clero**                       | Padres e diáconos                  | Mobile, Web                | Acesso a agenda litúrgica, dados de paroquianos, informações de sacramento         |
| **Sistema Externo (Firebase)**  | Backend unificado                  | Cloud                      | Autenticação, persistência, notificações, armazenamento                            |
| **Sistema Externo (OneSignal)** | Serviço de notificações            | Cloud                      | Envio de notificações push                                                         |

## Principais Integrações Externas

### Firebase (Backend Centralizado)

- **Firebase Authentication**: Autenticação de usuários com múltiplos provedores (email/senha, Google, Apple)
- **Cloud Firestore**: Banco de dados NoSQL em tempo real com coleções para avisos, eventos, pastorais, usuários
- **Firebase Storage**: Armazenamento de mídia (imagens, documentos)
- **Firebase Analytics**: Análise de uso e comportamento de usuários
- **Firebase Hosting**: Distribuição da versão web

### OneSignal

- **Notificações Push**: Comunicação direta com usuários mobile (iOS/Android)
- **Gerenciamento de Campanhas**: Segmentação de audiência por pastoral, localização, demográficos

### Outros Serviços

- **Google Maps** (possível): Localização de capelas e endereços
- **URL Launcher**: Abertura de links externos (sites, telefone, email)

## Plataformas Suportadas

| Plataforma       | Status     | Distribuição      | Tecnologia             |
| ---------------- | ---------- | ----------------- | ---------------------- |
| **Android**      | ✓ Produção | Google Play Store | Flutter, Java 17       |
| **iOS**          | ✓ Produção | Apple App Store   | Flutter, Swift runtime |
| **Web**          | ✓ Produção | Firebase Hosting  | Flutter Web, PWA       |
| **Admin/Gestão** | ✓ Produção | Web-only          | Flutter Web            |

## Fluxos Críticos em Nível Arquitetural

### Fluxo 1: Autenticação e Sessão

```
Usuário
  ↓ (credenciais)
App Flutter
  ↓ (Firebase SDK)
Firebase Authentication
  ↓ (token + perfil)
App + Local Storage
  ↓ (sessão persistida)
Funcionalidades desbloqueadas
```

**Impacto**: Acesso a todas as funcionalidades depende de autenticação bem-sucedida. Perda de conexão requer retry e pode impactar UX.

### Fluxo 2: Sincronização de Dados em Tempo Real

```
Backend Firestore (source of truth)
  ↓ (listeners)
App Mobile/Web
  ↓ (mudanças em tempo real)
UI atualizada dinamicamente
  ↓ (dados offline-first locais)
Sincronização em background quando reconectado
```

**Impacto**: Múltiplos clientes podem estar sincronizando simultaneamente; otimista UI importante para UX responsiva.

### Fluxo 3: Notificações Push

```
Gestor publica aviso/evento
  ↓ (trigger em Firestore)
Cloud Function (possível)
  ↓ (chama OneSignal)
OneSignal
  ↓ (APNs, FCM)
Dispositivo usuário
  ↓ (notificação)
Usuário acessa app via notificação
```

**Impacto**: Notificações devem ser confiáveis e relevantes; falha de delivery afeta engajamento.

## Principais Modules/Domínios Funcionais

Organizados em `lib/app/modules/`:

| Módulo                      | Tipo           | Responsabilidade                           |
| --------------------------- | -------------- | ------------------------------------------ |
| **home**                    | Core           | Dashboard principal, entrada do app        |
| **login**                   | Core           | Autenticação de usuários                   |
| **avisos**                  | Domínio        | Gerenciamento e exibição de avisos         |
| **eventos**                 | Domínio        | Calendário e detalhes de eventos           |
| **horarios**                | Domínio        | Horários de missas e atividades litúrgicas |
| **pastorais**               | Domínio        | Portal de pastorais e movimentos           |
| **catequese**               | Pastoral       | Gestão de turmas de catequese              |
| **crisma**                  | Pastoral       | Acompanhamento de crisma                   |
| **batismo**                 | Pastoral       | Informações de batismo                     |
| **ejc**                     | Pastoral       | Encontro de Jovens com Cristo              |
| **mej**                     | Pastoral       | Movimento Eucarístico Jovem                |
| **saude**                   | Pastoral       | Pastoral da Saúde                          |
| **rua**                     | Pastoral       | Pastoral da Rua                            |
| **grupo_de_oracao**         | Pastoral       | Encontros de oração                        |
| **conferencia_sao_vicente** | Pastoral       | Conferência São Vicente de Paulo           |
| **musica/cor/coroinhas**    | Pastoral       | Atividades musicais e litúrgicas           |
| **notifications**           | Core           | Gerenciamento de notificações push         |
| **shared**                  | Infraestrutura | Serviços compartilhados, utilitários       |

## Características Técnicas

### Arquitetura

- **Padrão**: Modular com injeção de dependências (Flutter Modular)
- **Gerenciamento de Estado**: MobX com repositórios e controllers
- **Persistência Local**: Sqflite (SQLite), SharedPreferences
- **Offline-first**: Sincronização bidirecional com Firestore

### Camadas

1. **Apresentação (UI)**: Widgets Flutter, Material Design, telas por módulo
2. **Lógica de Negócio**: Controllers (MobX), Services, Providers
3. **Dados**: Repositories, Models, Local storage (sqflite)
4. **Integração**: Firebase SDK, OneSignal SDK, HTTP clients

### Dependências Principais

- `flutter_modular@6.3.4`: Modularização e roteamento
- `mobx@2.5.0`: Gerenciamento de estado reativo
- `firebase_core@3.6.0`: Inicialização Firebase
- `firebase_auth@5.3.1`: Autenticação
- `cloud_firestore@5.4.3`: Banco de dados
- `onesignal_flutter@5.2.5`: Notificações push

## Decisões Arquiteturais Principais

| Decisão                          | Rationale                                                                    | Alternativas Rejeitadas                                             |
| -------------------------------- | ---------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| **Usar Flutter multiplataforma** | Código compartilhado (Dart), release única, custo operacional reduzido       | Desenvolvimento nativo por plataforma                               |
| **Firebase como backend**        | Escalabilidade, real-time, autenticação gerenciada, sem overhead operacional | Backend REST customizado, AWS, Azure                                |
| **MobX para estado**             | Reatividade, simples com decoradores, bom para síncrono e assíncrono         | Redux (verboso), Provider puro (menos poderoso), Bloc (verboso)     |
| **Firestore como DB principal**  | NoSQL, real-time listeners, sincronização nativa, backup automático          | SQL (Firebase Realtime DB abandonda), GraphQL, REST puro            |
| **Modular para injeção de deps** | Modularização clara, lazy loading, roteamento integrado                      | GetIt/Service Locator puro (menos estruturado)                      |
| **OneSignal para push**          | Segmentação avançada, multi-plataforma, UI gerenciada                        | Firebase Cloud Messaging puro (mais limitado), Pusher (custo maior) |

## Rastreabilidade

- **Código-fonte**: `lib/app/` contém módulos, `lib/app/modules/` contém domínios funcionais, `lib/app/shared/` contém infraestrutura
- **Configuração**: `pubspec.yaml` lista dependências, `firebase.json` configura hosting, `.env` contém secrets
- **Build**: `android/`, `ios/`, `web/` contêm configurações específicas de plataforma
- **Documentação de suporte**: [README.md](../../README.md), `docs/` contém guias adicionais

## Notas de Atualização

Este documento foi validado contra:

- ✓ Estrutura real do repositório em 2026-06-13
- ✓ Código-fonte analisado até branch main
- ✓ README.md, pubspec.yaml, firebase.json consultados
- ✓ Conversas técnicas com equipe

**Próxima revisão**: Agendar se houver:

- Novas plataformas ou integrações externas
- Mudanças em padrão de autenticação ou sincronização
- Alterações em estrutura de módulos principais
- Integração de novos backends ou serviços
