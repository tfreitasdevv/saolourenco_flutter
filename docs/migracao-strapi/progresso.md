# Registro de Progresso da Migração

> Registro detalhado de tudo já concluído. Atualizar ao final de cada sessão.

---

## ✅ Fase 1 — Concluída em 11/04/2026

### Projeto Strapi criado

- **Localização WSL**: `/home/tfreitas/projetos/saolourenco-cms`
- **Versão**: Strapi v5.42.0 (TypeScript)
- **Banco local**: PostgreSQL 16 via Docker (substituiu SQLite em 12/04)
- **Banco produção**: PostgreSQL (Render.com via `DATABASE_URL`)
- **Node.js**: v22.22.2

Comando usado:

```bash
npx --yes create-strapi@latest saolourenco-cms --quickstart --no-run --typescript
```

### Content Types criados (10 coleções via schema.json)

Todos os content types foram criados como arquivos de schema (versionáveis no Git), e **não** pelo painel admin. Cada API possui a estrutura padrão:

```
src/api/<nome>/
├── content-types/<nome>/schema.json
├── controllers/<nome>.ts
├── routes/<nome>.ts
└── services/<nome>.ts
```

| Coleção Firestore          | API Strapi          | Endpoint REST                 | Status    |
| -------------------------- | ------------------- | ----------------------------- | --------- |
| `avisos`                   | `aviso`             | `GET /api/avisos`             | ✅ Criado |
| `avisos_musica`            | `aviso-musica`      | `GET /api/aviso-musicas`      | ✅ Criado |
| `clero`                    | `clero`             | `GET /api/cleros`             | ✅ Criado |
| `como_ajudar`              | `como-ajudar`       | `GET /api/como-ajudars`       | ✅ Criado |
| `confissoes`               | `confissao`         | `GET /api/confissoes`         | ✅ Criado |
| `conteudo_pagina_pastoral` | `pastoral-conteudo` | `GET /api/pastoral-conteudos` | ✅ Criado |
| `eventos`                  | `evento`            | `GET /api/eventos`            | ✅ Criado |
| `horarios_missas`          | `horario-missa`     | `GET /api/horario-missas`     | ✅ Criado |
| `imagens_capelas`          | `imagem-capela`     | `GET /api/imagem-capelas`     | ✅ Criado |
| `administradores`          | `administrador`     | `GET /api/administradores`    | ✅ Criado |

### Components criados (2)

| Component               | Arquivo                                     | Uso                                                                                              |
| ----------------------- | ------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| `shared.secao-pastoral` | `src/components/shared/secao-pastoral.json` | Repeatable no PastoralConteudo (campos: titulo, tipo enum, texto, link, url_imagem media, ordem) |
| `shared.endereco`       | `src/components/shared/endereco.json`       | Single no Users & Permissions (campos: logradouro, numero, complemento, bairro, cidade, estado)  |

### ImageKit configurado

- Pacote instalado: `strapi-plugin-imagekit`
- Configuração: `config/plugins.ts` — usa variáveis `IMAGEKIT_PUBLIC_KEY`, `IMAGEKIT_PRIVATE_KEY`, `IMAGEKIT_URL_ENDPOINT`
- CSP middleware: `config/middlewares.ts` — permite `ik.imagekit.io` em `img-src` e `media-src`, `eml.imagekit.io` em `frame-src`
- Credenciais do ImageKit preenchidas no `.env` ✅

### Permissões públicas auto-configuradas

Arquivo `src/index.ts` contém bootstrap que cria automaticamente permissões `find` + `findOne` para o role **Public** nas 9 APIs de leitura pública:

- aviso, aviso-musica, clero, como-ajudar, confissao, pastoral-conteudo, evento, horario-missa, imagem-capela

Log confirmado no primeiro start:

```
✅ Permissão pública criada: api::aviso.aviso.find
✅ Permissão pública criada: api::aviso.aviso.findOne
... (18 permissões no total)
```

### População de dados

- **Modo**: manual, via painel admin do Strapi
- Dados iniciais populados via painel admin ✅

### Build e start validados

```
✔ Compiling TS (3388ms)
✔ Building build context (365ms)
✔ Building admin panel (36800ms)
✔ Strapi started successfully — http://localhost:1337/admin
```

### Arquivos de configuração do projeto Strapi

| Arquivo                 | Conteúdo                                                              |
| ----------------------- | --------------------------------------------------------------------- |
| `config/plugins.ts`     | Plugin ImageKit para upload de mídia                                  |
| `config/middlewares.ts` | CSP com ImageKit, CORS habilitado                                     |
| `config/database.ts`    | Suporte PostgreSQL (dev local + prod) e SQLite (fallback)             |
| `src/index.ts`          | Bootstrap de permissões públicas automáticas                          |
| `.env`                  | Secrets gerados + credenciais ImageKit + PostgreSQL local             |
| `.env.example`          | Template com PostgreSQL local (Docker) e produção (Render.com)        |
| `.gitignore`            | node_modules, .env, .tmp, serviceAccountKey.json                      |
| `docker-compose.yml`    | PostgreSQL 16 Alpine, porta 5432, volume persistente `strapi-pg-data` |
| `.dockerignore`         | Exclusões padrão (node_modules, build, dist, .tmp, .env)              |
| `package.json`          | Dependência `pg` adicionada (driver PostgreSQL para Node.js)          |

---

## ✅ Fase 1.5 — PostgreSQL local com Docker (12/04/2026)

**Motivação**: Paridade dev/prod — evitar diferenças de comportamento entre SQLite (dev) e PostgreSQL (prod no Render.com).

### Arquivos criados/alterados no `saolourenco-cms`:

| Arquivo              | Ação          | Detalhes                                                                                                                                                    |
| -------------------- | ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `docker-compose.yml` | ✅ Criado     | PostgreSQL 16 Alpine, container `strapi-pg`, porta 5432, volume `strapi-pg-data`, healthcheck com `pg_isready`                                              |
| `.dockerignore`      | ✅ Criado     | Exclui node_modules, build, dist, .tmp, .env                                                                                                                |
| `package.json`       | ✅ Atualizado | Dependência `pg` adicionada (`npm install pg`)                                                                                                              |
| `.env`               | ✅ Atualizado | `DATABASE_CLIENT=postgres`, `DATABASE_HOST=localhost`, `DATABASE_PORT=5432`, `DATABASE_NAME=strapi`, `DATABASE_USERNAME=strapi`, `DATABASE_PASSWORD=strapi` |
| `.env.example`       | ✅ Atualizado | Documentação de setup local (Docker) e produção (Render.com `DATABASE_URL`)                                                                                 |
| `config/database.ts` | Sem alteração | Já suportava PostgreSQL via variáveis de ambiente                                                                                                           |

### Dados anteriores (SQLite)

- O banco SQLite (`.tmp/data.db`) não é migrado — os dados devem ser re-inseridos pelo painel admin
- O pacote `better-sqlite3` foi mantido no `package.json` como fallback (sem conflito)

---

## ✅ Fase 1.6 — Migração para WSL e setup do ambiente (14/04/2026)

**Motivação**: Projetos migrados do Windows para o WSL (filesystem Linux) para melhor performance e compatibilidade.

| #   | Ação                                                                                                                 | Status   |
| --- | -------------------------------------------------------------------------------------------------------------------- | -------- |
| 1   | Projetos clonados no WSL (`/home/tfreitas/projetos/saolourenco_flutter` e `/home/tfreitas/projetos/saolourenco-cms`) | ✅ Feito |
| 2   | Docker Engine instalado nativamente no WSL (sem Docker Desktop) — Docker 29.4.0 + Compose v5.1.2                     | ✅ Feito |
| 3   | PostgreSQL 16 rodando via Docker Compose (`sudo docker compose up -d`)                                               | ✅ Feito |
| 4   | `.env` criado com secrets criptográficos + config PostgreSQL local                                                   | ✅ Feito |
| 5   | Build do Strapi com sucesso (`npm run build`)                                                                        | ✅ Feito |
| 6   | Strapi v5.42.0 iniciado com PostgreSQL e 18 permissões públicas criadas automaticamente                              | ✅ Feito |
| 7   | Painel admin acessível em `http://localhost:1337/admin`                                                              | ✅ Feito |

**Nota sobre Docker no WSL:**
O Docker Engine foi instalado diretamente no Ubuntu 24.04 do WSL (sem Docker Desktop).
Para usar sem `sudo`, o usuário foi adicionado ao grupo `docker` (`sudo usermod -aG docker $USER`).

### Pendências da Fase 1 concluídas (14/04/2026)

| #   | Pendência                                   | Status                                     |
| --- | ------------------------------------------- | ------------------------------------------ |
| 1   | Clonar projetos no WSL                      | ✅ Feito                                   |
| 2   | Subir Docker + testar Strapi com PostgreSQL | ✅ Feito                                   |
| 3   | Criar conta admin Strapi                    | ✅ Feito                                   |
| 4   | Credenciais ImageKit                        | ✅ Feito                                   |
| 5   | Popular dados manualmente                   | ✅ Feito (dados iniciais)                  |
| 6   | Verificar dados no painel                   | 🟡 Em andamento                            |
| 7   | Deploy no Render.com                        | 🟢 Baixa prioridade (pode ser após Fase 3) |

---

## ✅ Fase 2 — Camada de Abstração Flutter (concluída em 14/04/2026)

**Ambiente**: WSL (projetos no filesystem Linux)

### Arquivos criados

| Arquivo                                        | Propósito                                                     | Status    |
| ---------------------------------------------- | ------------------------------------------------------------- | --------- |
| `lib/app/shared/config/api_config.dart`        | URL base (via .env), constantes de endpoints Strapi           | ✅ Criado |
| `lib/app/shared/services/strapi_client.dart`   | Cliente HTTP com Dio, interceptor JWT, gerenciamento de token | ✅ Criado |
| `lib/app/shared/auth/strapi_auth_service.dart` | Login, registro, logout, getMe, updateProfile via Strapi      | ✅ Criado |

### Alterações

| Arquivo                   | Alteração                                                             |
| ------------------------- | --------------------------------------------------------------------- |
| `pubspec.yaml`            | Adicionado `dio: ^5.7.0` e `flutter_secure_storage: ^9.2.4`           |
| `.env`                    | Adicionado `STRAPI_URL=http://localhost:1337`                         |
| `lib/app/app_module.dart` | Registrado `StrapiClient` e `StrapiAuthService` como singletons no DI |

### Formato real da API Strapi v5 (validado)

O Strapi v5 usa formato **flat** — campos ficam direto em cada item de `data[]`, sem wrapper `attributes` (diferente do v4).

```json
// GET /api/avisos
{
  "data": [
    {
      "id": 2,
      "documentId": "zt5mfcuev7x1q8gq5ulyqdl1",
      "titulo": "Adora Jovem EAC",
      "descricao": "Descrição do evento Adora Jovem",
      "data": "2026-04-18T17:00:00.000Z",
      "prioridade": 1,
      "createdAt": "2026-04-15T00:48:56.701Z",
      "updatedAt": "2026-04-15T00:48:59.236Z",
      "publishedAt": "2026-04-15T00:48:59.255Z",
      "imagem": null
    }
  ],
  "meta": {
    "pagination": { "page": 1, "pageSize": 25, "pageCount": 1, "total": 1 }
  }
}
```

---

## ✅ Fase 3 (parcial) — Migração de Módulos Flutter (14–15/04/2026)

**Ambiente**: WSL (projetos no filesystem Linux)
**Branch**: `preparacao-migracao-strapi`

### Módulos migrados (3.1 a 3.6 — 14/04/2026)

| Passo | Módulo       | Arquivos alterados                                                                                     | Status     |
| ----- | ------------ | ------------------------------------------------------------------------------------------------------ | ---------- |
| 3.1   | Horários     | `horarios_page.dart` — Firestore → StrapiClient (`GET /api/horario-missas?sort=ordem:asc`)             | ✅ Migrado |
| 3.2   | Confissões   | `confissoes_page.dart` — 4 queries Firestore → 1 chamada Strapi (`GET /api/confissoes?sort=ordem:asc`) | ✅ Migrado |
| 3.3   | Avisos       | `avisos_page.dart`, `aviso_card.dart`, `aviso_card_markdown.dart` — Firestore → Strapi + ImageKit      | ✅ Migrado |
| 3.4   | Como Ajudar  | `como_ajudar_page.dart`, `como_ajudar_card.dart` — Firestore → Strapi + ImageKit                       | ✅ Migrado |
| 3.5   | Eventos      | `evento_model.dart`, `eventos_repository.dart`, `eventos_controller.dart`, `eventos_page.dart`         | ✅ Migrado |
| 3.6   | PastoralPage | `pastoral_page.dart` — migra 23 módulos de pastorais de uma vez                                        | ✅ Migrado |

### Módulos migrados (3.7a, 3.7b, 3.7c — 15/04/2026)

| Passo | Módulo          | Arquivos alterados                                                                                        | Status     |
| ----- | --------------- | --------------------------------------------------------------------------------------------------------- | ---------- |
| 3.7a  | Avisos Música   | `avisos_musica_page.dart`, `aviso_musica_card.dart` — Firestore → StrapiClient (`GET /api/aviso-musicas`) | ✅ Migrado |
| 3.7b  | Clero           | `sobre/tabs/clero.dart` — Firestore → StrapiClient (`GET /api/cleros?filters[funcao][$eq]=paroco`)        | ✅ Migrado |
| 3.7c  | Confissões Ctrl | `confissoes_controller.dart` — Firestore → StrapiClient (dead code migrado por consistência)              | ✅ Migrado |

### Limpeza de dead code (15/04/2026)

- `firebase_markdown_text.dart` — **removido** (nunca importado por nenhum arquivo do projeto)

### Detalhes técnicos das mudanças

**Padrão geral aplicado:**

- `cloud_firestore` (Firestore) → `StrapiClient` (Dio HTTP) via `Modular.get<StrapiClient>()`
- `DocumentSnapshot` → `Map<String, dynamic>` (formato flat Strapi v5)
- `Timestamp` → `DateTime.parse()` (ISO 8601 strings)
- Imagens: campo `imagem` pode ser `Map` (populado) ou `null` — extração de `url` do objeto media
- FutureBuilder inicializado no `initState` para evitar rebuilds desnecessários

**Eventos (3.5) — mudanças significativas:**

- Repository: Streams → Futures (sem real-time, conforme decisão do projeto)
- Controller: removidas `StreamSubscription` e método `dispose()`
- Model: `fromDocument(DocumentSnapshot)` → `fromJson(Map<String, dynamic>)`
- Filtros Strapi: `$gte`, `$lt`, `$containsi` substituem queries Firestore
- Contagem via `meta.pagination.total` em vez de `.count()`

**PastoralPage (3.6) — maior impacto:**

- `StatelessWidget` → `StatefulWidget` (Future no `initState`)
- Extração de seções: maps dinâmicos do Firestore → componente repetível `secoes` do Strapi
- Query: `filters[slug][$eq]` + `populate=secoes,secoes.url_imagem`
- Referências `title`/`bottomWidget` → `widget.title`/`widget.bottomWidget`

**Compilação validada:** `flutter analyze lib/` — 0 erros, 1 info (elemento não usado em eventos_page).

---

## Estado atual do projeto (15/04/2026)

- **Fases 1 e 2 concluídas.** Firebase e Strapi coexistem no projeto.
- `StrapiClient` (Dio + JWT) e `StrapiAuthService` estão criados e registrados no DI (`AppModule`).
- Strapi v5.42.0 rodando em `http://localhost:1337` com PostgreSQL 16 via Docker no WSL.
- API pública funcional — testada com `curl` (formato flat v5, sem `attributes`).
- **Módulos 3.1–3.8 migrados** para Strapi. Módulos 3.9–3.10 pendentes.
- Branch: `preparacao-migracao-strapi`.

---

## ✅ Fase 3.8 — Login/Auth reescrito do zero (15/04/2026)

**Decisão**: Autenticação reescrita do zero com Strapi JWT — sem herança do Firebase Auth.

### Schema do User no Strapi (campos customizados adicionados)

Arquivo criado: `saolourenco-cms/src/extensions/users-permissions/content-types/user/schema.json`

Campos adicionados ao User padrão do Strapi (Users & Permissions):

| Campo        | Tipo                        | Descrição                  |
| ------------ | --------------------------- | -------------------------- |
| `nome`       | string                      | Nome completo do usuário   |
| `celular`    | string                      | Telefone com máscara       |
| `nascimento` | date                        | Data de nascimento (ISO)   |
| `sexo`       | enumeration (F, M)          | Sexo do usuário            |
| `endereco`   | component `shared.endereco` | Endereço completo (single) |

### Arquivos reescritos no Flutter

| Arquivo                                                                | Mudança                                                                                                                                                                                                                                  |
| ---------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `lib/app/shared/auth/local_user.dart`                                  | Removido `FirebaseAuth`/`Firestore`. Estado baseado em `int? userId` + `Map? userData`. Injetado `StrapiAuthService`. `init()` verifica JWT e chama `getMe()`. Novo `clearUser()`.                                                       |
| `lib/app/shared/auth/local_user.g.dart`                                | Regenerado via `build_runner` — observáveis: `userId`, `userData`, `isLoading`, `nome`, `email`, `erroAoCriarUsuario`, `erroAoLogar`                                                                                                     |
| `lib/app/shared/auth/auth_repository.dart`                             | Removido `FirebaseAuth`/`Firestore`. Injetados `StrapiAuthService` + `StrapiClient`. Registro em 2 etapas: `register()` + `updateProfile()`. Login via `login()` + `getMe()`. Recuperação de senha via `POST /api/auth/forgot-password`. |
| `lib/app/modules/login/login_page.dart`                                | Removido import `firebase_auth`. Removido `FirebaseAuth.instance.signOut()` antes do login. Error codes Firebase mantidos no switch para compatibilidade.                                                                                |
| `lib/app/modules/login/signup_page.dart`                               | Removido import `cloud_firestore`. `Timestamp.fromDate()` → `DateFormat('yyyy-MM-dd').format()`. Removido `FirebaseFirestore.instance`.                                                                                                  |
| `lib/app/modules/login/profile/profile_page.dart`                      | Removido import `cloud_firestore`. `_recuperarDados()` usa `authRepo.obterUsuarioProfile()`. Nascimento parseado de string ISO. Endereço extraído como `Map` do Strapi.                                                                  |
| `lib/app/modules/musica/musica_page.dart`                              | `localUser.firebaseUser == null` → `!localUser.isLoggedIn()`                                                                                                                                                                             |
| `lib/app/modules/musica/pages/membros_musica/membros_musica_page.dart` | Todas as refs `localUser.firebaseUser` → `localUser.isLoggedIn()`, `localUser.nome`, `localUser.email`                                                                                                                                   |

### Padrões técnicos aplicados

- **Registro de usuário**: 2 etapas — `register(username=email, email, password)` → `updateProfile(userId, dadosExtras)` pois o endpoint padrão Strapi só aceita `username`, `email`, `password`
- **Username = email**: Strapi requer `username`; usamos o email como username
- **Nascimento**: `Timestamp` (Firestore) → `"YYYY-MM-DD"` (tipo `date` no Strapi)
- **Endereço**: Enviado como component `shared.endereco` (já existente no Strapi)
- **Recuperação de senha**: `POST /api/auth/forgot-password` com `{ email }`. Requer SMTP configurado no Strapi (fallback silencioso se não configurado).
- **Estado de autenticação**: `userId != null` em vez de `firebaseUser != null`
- **Init do LocalUser**: Verifica JWT via `_authService.isAuthenticated`; se válido, chama `getMe()` para popular estado; se token expirado (401), faz logout silencioso.

### Validação

- `dart run build_runner build` — 0 erros, 4 outputs
- `flutter analyze lib/` — 0 erros (1 info pré-existente em `eventos_page.dart`)
- `grep` Firebase nos arquivos migrados — zero referências residuais
- **Teste funcional pendente**: o fluxo de login/registro/perfil ainda **não foi testado em tempo de execução**. O único ponto de acesso à autenticação no app é a página da Pastoral da Música, que ainda não exibe dados porque o módulo de música não foi totalmente migrado (escalas adiadas). O teste funcional completo será possível quando houver um ponto de entrada acessível ou quando o módulo de música for concluído.

## Próximos passos

| Passo | Módulo            | Status      | Detalhes                                                          |
| ----- | ----------------- | ----------- | ----------------------------------------------------------------- |
| 3.9   | Imagens/Constants | ⬜ Pendente | 30+ URLs Firebase Storage em `constants.dart` → ImageKit.         |
| 3.10  | Home              | ⬜ Pendente | Sem dependências Firestore diretas. `LocalUser` já migrado (3.8). |
| —     | Escalas Música    | 🔒 Adiado   | Coleção `musica_mes_corrente` não migrar neste momento.           |
