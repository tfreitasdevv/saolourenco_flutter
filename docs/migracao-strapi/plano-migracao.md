# Plano de Migração Firebase → Strapi v5

> Fases de migração, tabela de módulos, Content Types, arquivos novos e verificações.
> Para o registro do que já foi feito, consulte [progresso.md](progresso.md).

---

## Fase 1 — Setup do Strapi (sem mudança no Flutter) ✅

**1.1** Criar projeto Strapi v5

```bash
npx create-strapi@latest saolourenco-cms
```

Escolher PostgreSQL como banco de dados.

**1.2** Criar Content Types no Strapi Admin

| Coleção Firestore          | Content Type Strapi     | Tipo          | Campos Strapi                                                                                                            |
| -------------------------- | ----------------------- | ------------- | ------------------------------------------------------------------------------------------------------------------------ |
| `avisos`                   | **Aviso**               | Collection    | data (datetime), descricao (richtext), imagem (media/single), prioridade (integer), titulo (string)                      |
| `avisos_musica`            | **AvisoMusica**         | Collection    | data (datetime), descricao (richtext), prioridade (integer), titulo (string)                                             |
| `clero`                    | **Clero**               | Collection    | funcao (string), data_ordenacao (string), historia (richtext), imagem (media/single), nome (string)                      |
| `como_ajudar`              | **ComoAjudar**          | Collection    | descricao (richtext), imagem (media/single), link (string), ordem (integer), titulo (string)                             |
| `confissoes`               | **Confissao**           | Collection    | secao (string, único), texto (richtext), titulo (string), ordem (integer)                                                |
| `conteudo_pagina_pastoral` | **PastoralConteudo**    | Collection    | slug (string, único), secoes (repeatable component "SecaoPastoral")                                                      |
| `eventos`                  | **Evento**              | Collection    | data (datetime), descricao (richtext), imagem (media/single), link (string), titulo (string)                             |
| `horarios_missas`          | **HorarioMissa**        | Collection    | dia (string, único), missas (JSON), ordem (integer), titulo (string)                                                     |
| `imagens_capelas`          | **ImagemCapela**        | Collection    | slug (string, único), imagem (media/single)                                                                              |
| `administradores`          | **Administrador**       | Collection    | email (string), name (string), addedAt (datetime), addedBy (string), isInitialAdmin (boolean)                            |
| `usuarios`                 | **Users & Permissions** | Plugin nativo | Campos custom: celular (string), endereco (component Endereco), nascimento (date), nome (string), sexo (enumeration F/M) |

**1.3** Criar Strapi Components

**Component `shared.secao-pastoral`** (repeatable):

- titulo (string) — título da seção
- tipo (enumeration: texto, botao, imagem)
- texto (richtext) — conteúdo de texto
- link (string) — URL do botão
- url_imagem (media/single) — imagem da seção
- ordem (integer)

**Component `shared.endereco`** (single):

- logradouro (string)
- numero (string)
- complemento (string)
- bairro (string)
- cidade (string)
- estado (string)

**1.4** Configurar permissões

- **Public** (find, findOne): Aviso, AvisoMusica, Clero, ComoAjudar, Confissao, PastoralConteudo, Evento, HorarioMissa, ImagemCapela
- **Authenticated** (find own, update own): Users/me
- **Admin**: CRUD completo

**1.5** Instalar e configurar ImageKit

```bash
npm install strapi-plugin-imagekit
```

Configurar em `config/plugins.ts`:

```ts
export default ({ env }) => ({
  imagekit: {
    enabled: true,
    config: {
      publicKey: env("IMAGEKIT_PUBLIC_KEY"),
      privateKey: env("IMAGEKIT_PRIVATE_KEY"),
      urlEndpoint: env("IMAGEKIT_URL_ENDPOINT"),
      enabled: true,
      useTransformUrls: true,
      useSignedUrls: false,
      uploadEnabled: true,
      uploadOptions: {
        folder: "/strapi-uploads/",
        tags: ["strapi", "paroquia"],
        overwriteTags: false,
        isPrivateFile: false,
      },
    },
  },
});
```

Atualizar CSP em `config/middlewares.ts` — permitir `ik.imagekit.io` em `img-src`, `media-src` e `eml.imagekit.io` em `frame-src`.

**1.6** Deploy no Render.com

- Web Service: Node.js, branch main, build `npm run build`, start `npm run start`
- PostgreSQL: free tier, conectar via DATABASE_URL
- Variáveis: APP_KEYS, API_TOKEN_SALT, ADMIN_JWT_SECRET, JWT_SECRET, DATABASE_URL, IMAGEKIT_PUBLIC_KEY, IMAGEKIT_PRIVATE_KEY, IMAGEKIT_URL_ENDPOINT

**1.7** Popular dados manualmente no painel Strapi

- Criar os registros de cada content type diretamente pelo painel admin do Strapi
- Fazer upload das imagens pela Media Library (serão enviadas ao ImageKit automaticamente)

---

## Fase 2 — Camada de Abstração no Flutter ✅

**2.1** Criar `lib/app/shared/services/strapi_client.dart`

- Cliente HTTP centralizado (Dio)
- Base URL configurável via .env
- Métodos: `get()`, `post()`, `put()`, `delete()`
- Interceptor para JWT: header `Authorization: Bearer <token>`
- Tratamento de erros padronizado

**2.2** Criar `lib/app/shared/auth/strapi_auth_service.dart`

- `register(email, password, userData)` → POST `/api/auth/local/register`
- `login(email, password)` → POST `/api/auth/local`
- `logout()` → limpa JWT do secure storage
- `getMe()` → GET `/api/users/me`
- `updateProfile(data)` → PUT `/api/users/{id}`
- JWT persistido com `flutter_secure_storage`

**2.3** Criar `lib/app/shared/config/api_config.dart`

- `baseUrl` (da variável de ambiente STRAPI_URL)
- Endpoints como constantes

**2.4** Atualizar modelos de dados

- `EventoModel.fromDocument(DocumentSnapshot)` → `EventoModel.fromJson(Map<String, dynamic>)`
- Formato Strapi v5 é **flat**: `{ data: [{ id, documentId, titulo, data, ... }] }` (sem wrapper `attributes`)
- O `toMap()` → `toJson()` sem `Timestamp` (usar ISO 8601 string)

**2.5** Adicionar ao pubspec.yaml

```yaml
dependencies:
  dio: ^5.x.x
  flutter_secure_storage: ^9.x.x
```

---

## Fase 3 — Migrar Módulos (ordem recomendada)

| Passo   | Módulo            | Arquivo(s) Principal(is)                                                                              | Endpoint Strapi                                                      | Status                             |
| ------- | ----------------- | ----------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- | ---------------------------------- |
| 3.1     | Horários          | `horarios_page.dart`                                                                                  | `GET /api/horario-missas?sort=ordem:asc`                             | ✅ Migrado                         |
| 3.2     | Confissões        | `confissoes_page.dart`                                                                                | `GET /api/confissoes?sort=ordem:asc`                                 | ✅ Migrado                         |
| 3.3     | Avisos            | `avisos_page.dart`                                                                                    | `GET /api/avisos?sort=data:desc&populate=imagem`                     | ✅ Migrado                         |
| 3.4     | Como Ajudar       | `como_ajudar_page.dart`                                                                               | `GET /api/como-ajudars?sort=ordem:asc&populate=imagem`               | ✅ Migrado                         |
| 3.5     | Eventos           | `eventos_repository.dart`, `evento_model.dart`                                                        | `GET /api/eventos?sort=data:asc&populate=imagem`                     | ✅ Migrado                         |
| 3.6     | PastoralPage      | `pastoral_page.dart`                                                                                  | `GET /api/pastoral-conteudos?filters[slug][$eq]=...&populate=secoes` | ✅ Migrado (23 módulos)            |
| 3.7a    | Avisos Música     | `avisos_musica_page.dart`, `aviso_musica_card.dart`                                                   | `GET /api/aviso-musicas?sort=data:desc`                              | ✅ Migrado                         |
| 3.7b    | Clero             | `sobre/tabs/clero.dart`                                                                               | `GET /api/cleros?filters[funcao][$eq]=paroco&populate=imagem`        | ✅ Migrado                         |
| 3.7c    | Confissões Ctrl   | `confissoes_controller.dart`                                                                          | `GET /api/confissoes?filters[secao][$eq]=texto_confissoes`           | ✅ Migrado                         |
| **3.8** | **Login/Auth**    | `auth_repository.dart`, `local_user.dart`, `login_page.dart`, `signup_page.dart`, `profile_page.dart` | `/api/auth/local`, `/api/auth/local/register`, `/api/users/me`       | ✅ Migrado — **reescrito do zero** |
| 3.9     | Imagens/Constants | `constants.dart`                                                                                      | Assets locais (`assets/images/`)                                     | ✅ Migrado — 35 assets locais      |
| 3.10    | Home              | `home_page.dart`                                                                                      | Verificar dados buscados                                             | ✅ Validado                        |

---

### Detalhes da Fase 3.8 — Login/Auth (reescrita do zero)

> **Decisão (15/04/2026):** A autenticação será **implementada do zero** — sem herdar, adaptar ou reaproveitar o código Firebase Auth existente. Ver motivação completa em [README.md](README.md#decisão-sobre-autenticação-15042026).

**`StrapiAuthService` já existe (criado na Fase 2):**

- Localização: `lib/app/shared/auth/strapi_auth_service.dart`
- Já registrado como singleton no `AppModule`
- Métodos: `register()`, `login()`, `logout()`, `getMe()`, `updateProfile()`
- JWT salvo automaticamente no `FlutterSecureStorage` via `StrapiClient.saveToken()`

**Arquivos a reescrever (do zero, nesta ordem):**

1. **`lib/app/shared/auth/local_user.dart`** — Reescrever completamente. Remover `User? firebaseUser` e `FirebaseAuth.instance.currentUser`. O estado de autenticação deve ser baseado em JWT do Strapi: usar `StrapiClient.hasToken` para verificar login e `StrapiAuthService.getMe()` para obter dados do usuário. Manter a arquitetura MobX (`@observable`, `@action`). Rodar `build_runner` para regenerar `local_user.g.dart`.

2. **`lib/app/shared/auth/auth_repository.dart`** — Reescrever completamente. Substituir `FirebaseAuth` por `StrapiAuthService`. Mapeamento de métodos:
   - `criarUsuario()` → `StrapiAuthService.register()`
   - `logar()` → `StrapiAuthService.login()`
   - `logout()` → `StrapiAuthService.logout()`
   - `obterUsuarioAtual()` → `StrapiAuthService.getMe()`
   - `atualizarDadosUsuario()` → `StrapiAuthService.updateProfile()`
   - `recuperarSenha()` → Implementar via endpoint do Strapi (plugin users-permissions com configuração de email, ou endpoint customizado). **Definir abordagem durante a implementação.**

3. **`lib/app/modules/login/login_page.dart`** — Reescrever para usar os novos `AuthRepository` e `LocalUser`. Remover import `firebase_auth`.

4. **`lib/app/modules/login/signup_page.dart`** — Reescrever para usar os novos `AuthRepository` e `LocalUser`.

5. **`lib/app/modules/login/profile/profile_page.dart`** — Reescrever para usar os novos `AuthRepository` e `LocalUser`.

**Validação pós-implementação:**

- Testar login, registro, logout e edição de perfil nas 3 plataformas (Android, iOS, Web)
- Verificar persistência do JWT após fechar e reabrir o app
- Verificar que `flutter analyze lib/` não retorna erros
- Verificar que o fluxo de navegação (login → home, logout → login) funciona corretamente

---

### Arquivos que ainda usam Firebase (inventário atualizado em 15/04/2026)

| Arquivo                                                             | Dependência Firebase         | Próximo passo                   |
| ------------------------------------------------------------------- | ---------------------------- | ------------------------------- |
| `lib/app/modules/musica/repositories/escala_musica_repository.dart` | Firestore                    | 🔒 Adiado (musica_mes_corrente) |
| `lib/app/modules/musica/models/escala_musica_domingo_model.dart`    | Firestore (DocumentSnapshot) | 🔒 Adiado                       |
| `lib/app/modules/musica/models/escala_musica_sabado_model.dart`     | Firestore (DocumentSnapshot) | 🔒 Adiado                       |
| `lib/app/modules/musica/funcoes_auxiliares/preencher_dados.dart`    | Firestore                    | 🔒 Adiado (script de teste)     |
| `lib/app/shared/constants/constants.dart`                           | ~~Firebase Storage URLs~~    | ✅ Fase 3.9 — assets locais     |
| `lib/scripts/criar_confissoes_firebase.dart`                        | Firestore                    | Fase 4 — remover                |
| `lib/firebase_options_env.dart`                                     | Config Firebase              | Fase 4 — remover                |
| `lib/firebase_options_env.template.dart`                            | Config Firebase              | Fase 4 — remover                |

---

## Fase 4 — Limpeza Final

**Remover do pubspec.yaml:**

- `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `firebase_analytics`

**Remover arquivos:**

- `lib/firebase_options.dart`
- `lib/firebase_options_env.dart`
- `lib/firebase_options_env.template.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist` (se existir)
- `lib/scripts/criar_confissoes_firebase.dart`

**Atualizar:**

- `lib/main.dart` — remover `Firebase.initializeApp()`, inicializar StrapiClient
- `lib/app/app_module.dart` — registrar StrapiClient, StrapiAuthService no DI
- `firebase.json` — remover ou atualizar se não usar Firebase Hosting
- Scripts de deploy (`deploy-web.bat`, `deploy-web.sh`)
- Documentação

---

## Arquivos Novos Criados

| Arquivo                                        | Propósito                              | Status    |
| ---------------------------------------------- | -------------------------------------- | --------- |
| `saolourenco-cms/` (projeto inteiro)           | Projeto Strapi v5 com 10 Content Types | ✅ Criado |
| `lib/app/shared/services/strapi_client.dart`   | Cliente HTTP centralizado (Dio)        | ✅ Criado |
| `lib/app/shared/auth/strapi_auth_service.dart` | Autenticação Strapi (JWT)              | ✅ Criado |
| `lib/app/shared/config/api_config.dart`        | URL base e constantes da API           | ✅ Criado |

---

## Verificação por Fase

| Verificação                                         | Quando                    | Status                                                                                                                                                                 |
| --------------------------------------------------- | ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Strapi admin acessível, content types criados       | Após Fase 1               | ✅ Verificado (11/04)                                                                                                                                                  |
| Build do Strapi sem erros                           | Após Fase 1               | ✅ Verificado (11/04)                                                                                                                                                  |
| Permissões públicas configuradas                    | Após Fase 1               | ✅ Verificado (11/04)                                                                                                                                                  |
| Dados inseridos manualmente no painel Strapi        | Após população manual     | ✅ Feito (14/04)                                                                                                                                                       |
| Imagens carregando do ImageKit                      | Após upload de imagens    | ⬜ Pendente                                                                                                                                                            |
| StrapiClient fazendo GET com sucesso                | Após Fase 2               | ✅ Verificado (14/04)                                                                                                                                                  |
| Cada módulo exibindo dados do Strapi                | Após cada passo da Fase 3 | 🟡 3.1–3.7 migrados (15/04)                                                                                                                                            |
| Cadastro, login, logout, perfil funcionando         | Após 3.8                  | 🟡 Código migrado, teste funcional pendente — acesso ao fluxo de auth só é possível pela Pastoral da Música, que ainda não exibe dados (módulo não totalmente migrado) |
| 23 páginas de pastorais carregando                  | Após 3.6                  | 🟡 Código migrado, aguarda teste manual                                                                                                                                |
| `flutter build apk` e `flutter build web` sem erros | Após Fase 4               | ⬜ Pendente                                                                                                                                                            |
| App completo funcionando sem Firebase               | Final                     | ⬜ Pendente                                                                                                                                                            |
