# Resumo da Migração Firebase → Strapi

> Última atualização: 15 de abril de 2026
>
> Este documento é um resumo de leitura rápida de tudo que foi feito e do que falta.
> Para detalhes técnicos completos, consulte `progresso.md` e `plano-migracao.md`.

---

## O que é essa migração?

O aplicativo da Paróquia São Lourenço usava **Firebase** (Firestore, Auth, Storage) como backend.
Estamos migrando para o **Strapi v5** — um CMS headless open-source com painel administrativo próprio,
banco PostgreSQL e hospedagem independente.

**Motivo**: ter controle total dos dados, painel admin amigável para o conteúdo da paróquia,
e eliminar a dependência do Firebase.

---

## O que já foi feito

### Fase 1 — Backend Strapi criado ✅

- Projeto Strapi v5.42.0 criado em `/home/tfreitas/projetos/saolourenco-cms`
- 10 coleções (Content Types) criadas, espelhando as coleções do Firestore
- 2 componentes reutilizáveis (seção pastoral, endereço)
- Banco de dados PostgreSQL 16 rodando via Docker no WSL
- ImageKit configurado como provedor de mídia (imagens dinâmicas)
- Permissões públicas de leitura configuradas automaticamente no bootstrap
- Dados iniciais populados manualmente pelo painel admin

### Fase 2 — Camada de abstração no Flutter ✅

- `StrapiClient` — cliente HTTP centralizado (Dio) com interceptor JWT automático
- `StrapiAuthService` — serviço de autenticação (login, registro, logout, perfil)
- `ApiConfig` — configuração centralizada de URLs e endpoints
- Tudo registrado como singleton no Flutter Modular (injeção de dependência)
- Variável `STRAPI_URL` no `.env`

### Fase 3 — Módulos do app migrados ✅

Todos os módulos do app que consumiam dados do Firebase foram reescritos para usar a API REST do Strapi:

| #    | Módulo                | O que mudou                                      |
| ---- | --------------------- | ------------------------------------------------ |
| 3.1  | Horários das Missas   | Firestore → `GET /api/horario-missas`            |
| 3.2  | Confissões            | 4 queries individuais → 1 chamada paginada       |
| 3.3  | Avisos Paroquiais     | Firestore → Strapi + imagens via ImageKit        |
| 3.4  | Como Ajudar           | Firestore → Strapi + imagens via ImageKit        |
| 3.5  | Eventos               | Streams (real-time) → Futures (HTTP sob demanda) |
| 3.6  | 23 Pastorais          | Widget centralizado migrado de uma vez           |
| 3.7a | Avisos da Música      | Firestore → Strapi                               |
| 3.7b | Clero (Sobre)         | Firestore → Strapi + imagem do pároco            |
| 3.7c | Confissões Controller | Dead code migrado por consistência               |
| 3.8  | **Login/Auth**        | **Reescrito do zero** com JWT do Strapi          |
| 3.9  | **Imagens estáticas** | 35 URLs do Firebase Storage → **assets locais**  |
| 3.10 | **Home**              | Validado — sem dependências Firebase             |

### Decisões importantes tomadas

- **Autenticação reescrita do zero** — não herdou nada do Firebase Auth
- **Imagens estáticas como assets locais** — pastorais, capelas, ícones e sobre agora são bundled no app (funcionam offline)
- **Imagens dinâmicas (avisos, eventos, etc.)** — servidas pelo Strapi via ImageKit
- **Sem real-time** — dados buscados sob demanda (sem streams)
- **Módulo Música (escalas)** — deliberadamente adiado (coleção `musica_mes_corrente` não migrada)

---

## O que falta fazer

### Testes pendentes (prioridade alta)

1. **Teste funcional da autenticação** — login, registro, logout e edição de perfil nas 3 plataformas (Android, iOS, Web). O código foi migrado mas ainda não foi testado em tempo de execução.
2. **Teste visual das imagens locais** — verificar que todas as 35 imagens carregam corretamente nas 3 plataformas.
3. **Teste geral dos módulos** — navegar por todas as telas do app e verificar que os dados do Strapi aparecem corretamente.

### Fase 4 — Limpeza do Firebase (prioridade média)

Remover as dependências do Firebase que não são mais necessárias:

**O que remover do `pubspec.yaml`:**

- `firebase_storage` — já substituído por assets locais
- `firebase_analytics` — avaliar se quer manter analytics ou não

**O que NÃO remover ainda:**

- `firebase_core`, `firebase_auth`, `cloud_firestore` — **ainda usados pelo módulo Música** (4 arquivos de escalas que foram adiados)

**Arquivos para deletar na Fase 4:**

- `lib/scripts/criar_confissoes_firebase.dart` (script legado)
- `lib/firebase_options_env.dart` e `.template.dart` (após remoção completa do Firebase)

**Atualizar:**

- `lib/main.dart` — quando o Firebase puder ser removido completamente, tirar `Firebase.initializeApp()`

### Módulo Música (prioridade baixa)

4 arquivos ainda usam Firestore diretamente (escalas de sábado e domingo). Foram deliberadamente adiados porque a coleção `musica_mes_corrente` é complexa e de baixo impacto.

### Deploy (sessão separada)

- Deploy do Strapi no Render.com (PostgreSQL + Web Service)
- Deploy do app atualizado (Android/iOS/Web)

---

## Arquitetura atual (após migração)

```
┌─────────────────────┐      ┌──────────────────────┐
│   App Flutter        │      │   Strapi v5 CMS      │
│                      │ HTTP │                      │
│  StrapiClient (Dio) ├──────►  API REST             │
│  StrapiAuthService   │ JWT  │  PostgreSQL 16       │
│  LocalUser (MobX)    │      │  ImageKit (mídia)    │
│                      │      │  Painel Admin        │
│  Assets locais       │      │                      │
│  (pastorais, ícones) │      │  localhost:1337      │
└─────────────────────┘      └──────────────────────┘
```

**Repositórios:**

- `saolourenco_flutter` — app Flutter (este repositório)
- `saolourenco-cms` — backend Strapi (repositório separado)

**Branch da migração:** `preparacao-migracao-strapi`

---

## Onde encontrar mais detalhes

| Preciso de...                      | Consulte                   |
| ---------------------------------- | -------------------------- |
| Histórico detalhado de cada fase   | `progresso.md`             |
| Plano completo com fases e tabelas | `plano-migracao.md`        |
| Padrões de código já aplicados     | `padroes-strapi.md`        |
| Coleções originais do Firestore    | `colecoes-firestore.md`    |
| Arquitetura original do Flutter    | `arquitetura-flutter.md`   |
| Setup do CMS em máquina nova       | `setup-cms.md`             |
| Setup completo (Flutter + CMS)     | `SETUP_NOVO_COMPUTADOR.md` |
