# Migração Firebase → Strapi v5 — Guia de Referência Completo

> **Documento de referência para sessão de implementação.**
> Criado em: 11/04/2026
> Atualizado em: 12/04/2026 — Fase 1 concluída (ImageKit substituiu Cloudinary)
> Atualizado em: 12/04/2026 — PostgreSQL local com Docker (substituiu SQLite), migração para WSL
> Atualizado em: 14/04/2026 — Ambiente WSL configurado (Docker Engine + PostgreSQL + Strapi rodando)
> Contém: arquitetura atual, decisões, plano de migração, mapeamento de coleções, código-fonte de referência.

---

## 1. Decisões Finais

| Item                          | Decisão                                                                       |
| ----------------------------- | ----------------------------------------------------------------------------- |
| Versão Strapi                 | **v5** (mais recente)                                                         |
| Banco de dados                | **PostgreSQL** (local via Docker + Render.com free tier em produção)          |
| Hospedagem                    | **Render.com** (free tier: Web Service + PostgreSQL)                          |
| Ambiente de dev               | **WSL** (Windows Subsystem for Linux) — projetos clonados no filesystem Linux |
| Imagens                       | **ImageKit** (free tier: 20GB) via `strapi-plugin-imagekit`                   |
| Migração                      | **Gradual** — módulo a módulo, Firebase fica ativo durante transição          |
| Dados em tempo real           | **Não** — busca sob demanda (sem streams/real-time)                           |
| Gerenciamento de conteúdo     | **Somente painel Strapi** (app é read-only)                                   |
| Autenticação                  | **Migrar para Strapi** Users & Permissions                                    |
| Coleção `musica_mes_corrente` | **Não migrar** neste momento                                                  |

---

## 2. Arquitetura Atual do App Flutter

### 2.1 Stack tecnológico

- **Framework**: Flutter (Android + Web + iOS)
- **State management**: MobX (com code generation via `mobx_codegen`)
- **Routing/DI**: Flutter Modular (`flutter_modular`)
- **Backend**: Firebase (Firestore + Auth + Storage)
- **Push notifications**: OneSignal (independente do Firebase)
- **Pacote do app**: `paroquia_sao_lourenco`

### 2.2 Dependências Firebase atuais (pubspec.yaml)

```yaml
firebase_core: ^3.6.0
firebase_auth: ^5.3.1
cloud_firestore: ^5.4.3
firebase_storage: ^12.3.2
firebase_analytics: ^11.3.3
cached_network_image: ^3.4.1
```

### 2.3 Estrutura de diretórios

```
lib/
├── firebase_options_env.dart          # Config Firebase via .env
├── firebase_options_env.template.dart  # Template
├── firebase_options.dart               # Gerado, gitignored
├── main.dart                           # Firebase.initializeApp()
├── app/
│   ├── app_controller.dart             # MobX controller global
│   ├── app_controller.g.dart
│   ├── app_module.dart                 # Root DI + routes
│   ├── app_widget.dart                 # MaterialApp setup
│   ├── shared/
│   │   ├── auth/
│   │   │   ├── auth_repository.dart    # Firebase Auth + Firestore 'usuarios'
│   │   │   ├── local_user.dart         # MobX observable (FirebaseUser)
│   │   │   └── local_user.g.dart
│   │   ├── constants/
│   │   │   └── constants.dart          # URLs Firebase Storage (30+ constantes)
│   │   ├── services/
│   │   │   └── push_notification_service.dart  # OneSignal (manter)
│   │   ├── utils/
│   │   │   ├── text.dart
│   │   │   └── url_launcher_utils.dart
│   │   └── widgets/
│   │       ├── acesso_membros_button.dart
│   │       ├── firebase_markdown_text.dart
│   │       ├── pastoral_page.dart      # Widget centralizado (23 módulos)
│   │       └── rich_text_markdown.dart
│   └── modules/
│       ├── home/                       # Dashboard
│       ├── login/                      # Auth (login, signup, profile/)
│       ├── avisos/                     # Avisos paroquiais
│       ├── eventos/                    # Eventos (com repository + model)
│       ├── horarios/                   # Horários das missas
│       ├── confissoes/                 # Confissões (controller MobX)
│       ├── como_ajudar/                # Como ajudar
│       ├── musica/                     # Música (repository + models)
│       ├── capelas/                    # Capelas
│       ├── notifications/              # Configurações push
│       ├── pastorais/                  # Lista de pastorais
│       ├── sobre/                      # Sobre a paróquia
│       └── [23 módulos de pastorais]   # Cada um usa PastoralPage
│           ├── acolitos/, alfabetizacao/, batismo/, catequese/
│           ├── conferencia_sao_vicente/, cor/, coroinhas/, crisma/
│           ├── dizimo/, eac/, ecc/, ejc/, familiar/
│           ├── grupo_de_oracao/, liturgia/, mae_tres_vezes/
│           ├── mej/, nascituro/, pascom/, promocao_humana/
│           ├── rua/, saude/
└── scripts/
    └── criar_confissoes_firebase.dart  # Script de inicialização de dados
```

### 2.4 Padrão de módulo (Flutter Modular)

```dart
// Exemplo: lib/app/app_module.dart
class AppModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton(LocalUser.new);
    i.addLazySingleton(AuthRepository.new);
    i.addLazySingleton(PushNotificationService.new);
    i.addSingleton(AppController.new);
  }

  @override
  void routes(RouteManager r) {
    r.module('/', module: HomeModule());
    r.child('/signup', child: (context) => SignupPage());
    r.module('/login', module: LoginModule());
    r.child('/profile', child: (context) => ProfilePage());
    r.child('/notifications', child: (context) => const NotificationSettingsPage());
  }
}
```

---

## 3. Código-Fonte de Referência (Padrões Atuais)

### 3.1 main.dart — Inicialização Firebase

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("❌ Erro ao carregar arquivo .env: $e");
  }
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("❌ Erro ao inicializar Firebase: $e");
  }
  // ... OneSignal init ...
  runApp(ModularApp(module: AppModule(), child: AppWidget()));
}
```

### 3.2 PastoralPage — Widget centralizado (migra 23 módulos de uma vez)

```dart
// lib/app/shared/widgets/pastoral_page.dart
// Parâmetros: title, documentId, bottomWidget (opcional)
// Busca: FirebaseFirestore.instance.collection('conteudo_pagina_pastoral').doc(documentId).get()
// Extrai seções do documento (maps), ordena por campo "ordem"
// Maps com nome ">botao*" → botão (campos: link, texto, ordem)
// Maps com nome ">imagem*" → imagem (campos: url, ordem)
// Demais maps → texto (campos: texto, ordem), título = nome do map

List<Map<String, dynamic>> _extrairSecoes(DocumentSnapshot snapshot) {
  final data = snapshot.data() as Map<String, dynamic>? ?? {};
  final secoes = <Map<String, dynamic>>[];
  for (final entry in data.entries) {
    if (entry.value is Map) {
      final map = entry.value as Map<String, dynamic>;
      final ehBotao = entry.key.startsWith('>botao');
      final ehImagem = entry.key.startsWith('>imagem');
      secoes.add({
        'titulo': entry.key,
        'tipo': ehBotao ? 'botao' : ehImagem ? 'imagem' : 'texto',
        'texto': (map['texto'] ?? '').toString(),
        if (ehBotao) 'link': (map['link'] ?? '').toString(),
        if (ehImagem) 'url': (map['url'] ?? '').toString(),
        'ordem': (map['ordem'] ?? 999) is int
            ? map['ordem']
            : int.tryParse(map['ordem'].toString()) ?? 999,
      });
    }
  }
  secoes.sort((a, b) => (a['ordem'] as int).compareTo(b['ordem'] as int));
  return secoes;
}
```

**Módulos que usam PastoralPage (23 total)**:

- acolitos, alfabetizacao, batismo, catequese, conferencia_sao_vicente, cor, coroinhas
- crisma, dizimo, eac, ecc, ejc, familiar, grupo_de_oracao, liturgia
- mae_tres_vezes, mej, nascituro, pascom, promocao_humana, rua, saude
- musica (com `bottomWidget: AcessoMembrosButton`)

**Mapeamento de documentId não-óbvio**:

- módulo `alfabetizacao` → documentId `alfabetizacao_adultos`
- módulo `crisma` → documentId `catecumenato_crismal`
- módulo `mae_tres_vezes` → documentId `mae_tres_vezes_admiravel`

### 3.3 Padrão de acesso direto ao Firestore (Avisos, Horários, Como Ajudar)

```dart
// lib/app/modules/avisos/avisos_page.dart
FutureBuilder<QuerySnapshot>(
  future: FirebaseFirestore.instance
      .collection("avisos")
      .orderBy('data', descending: true)
      .get(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return Center(child: CircularProgressIndicator(...));
    } else {
      return ListView(
        children: (snapshot.data?.docs ?? []).map((doc) {
          return AvisoCard(snapshot: doc);
        }).toList(),
      );
    }
  },
)
```

```dart
// lib/app/modules/horarios/horarios_page.dart
FutureBuilder<QuerySnapshot>(
  future: FirebaseFirestore.instance
      .collection('horarios_missas')
      .orderBy('ordem')
      .get(),
  builder: (context, snapshot) {
    // Cada doc tem: doc["titulo"], data?["missas"] (array de strings)
  },
)
```

### 3.4 Padrão com Repository (Eventos)

```dart
// lib/app/modules/eventos/repositories/eventos_repository.dart
class EventosRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'eventos';

  Stream<List<EventoModel>> obterEventosFuturos() {
    final agora = Timestamp.fromDate(DateTime.now());
    return _firestore.collection(_collection)
        .where('data', isGreaterThanOrEqualTo: agora)
        .orderBy('data', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EventoModel.fromDocument(doc)).toList());
  }
  // Outros: obterEventos(), obterEventosPassados(), obterProximosEventos(dias)
  // obterEventoPorId(id), buscarEventosPorTitulo(titulo), obterEventosPorPeriodo(inicio, fim)
}
```

```dart
// lib/app/modules/eventos/models/evento_model.dart
class EventoModel {
  late String id;
  late DateTime data;
  late String titulo;
  String? descricao;
  String? imagem;  // URL Firebase Storage
  String? link;

  EventoModel.fromDocument(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    final Timestamp timestamp = data['data'] as Timestamp;
    this.data = timestamp.toDate();
    titulo = data['titulo'] as String;
    descricao = data['descricao'] as String?;
    imagem = data['imagem'] as String?;
    link = data['link'] as String?;
  }

  Map<String, dynamic> toMap() {
    return {
      'data': Timestamp.fromDate(data),
      'titulo': titulo,
      'descricao': descricao,
      'imagem': imagem,
      'link': link,
    };
  }

  bool get temImagem => imagem != null && imagem!.isNotEmpty;
  bool get temLink => link != null && link!.isNotEmpty;
  bool get temDescricao => descricao != null && descricao!.isNotEmpty;
}
```

### 3.5 Confissões (MobX Controller)

```dart
// lib/app/modules/confissoes/confissoes_controller.dart
abstract class _ConfissoesBase with Store {
  @observable
  String textoConfissoes = '';
  @observable
  bool isLoading = true;

  @action
  Future<void> carregarTextoConfissoes() async {
    isLoading = true;
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('confissoes')
          .doc('texto_confissoes')
          .get();
      if (doc.exists) {
        textoConfissoes = doc.get('texto') ?? '';
      }
    } catch (e) {
      textoConfissoes = 'Erro ao carregar o texto: $e';
    }
    isLoading = false;
  }
}
```

### 3.6 AuthRepository — Autenticação + Perfil

```dart
// lib/app/shared/auth/auth_repository.dart
class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalUser localUser;
  Map<String, dynamic> dadosUsuario = {};

  // criarUsuario({dadosUsuario, senha, onSuccess, onFail})
  //   → _auth.createUserWithEmailAndPassword() → salva em 'usuarios' collection

  // logar({email, senha, onSuccess, onFail})
  //   → _auth.signInWithEmailAndPassword() → busca perfil de 'usuarios'

  // logout()
  //   → _auth.signOut() → limpa estado local

  // obterUsuarioAtual()
  //   → FirebaseFirestore.instance.collection('usuarios').doc(uid).get()

  // obterUsuarioProfile() → retorna Map<String, dynamic>

  // atualizarDadosUsuario(dadosUsuario)
  //   → FirebaseFirestore.instance.collection('usuarios').doc(uid).update(dadosUsuario)

  // recuperarSenha(email)
  //   → _auth.sendPasswordResetEmail()
}
```

### 3.7 LocalUser — Estado MobX Global

```dart
// lib/app/shared/auth/local_user.dart
abstract class _LocalUserBase with Store {
  @observable User? firebaseUser;
  @observable bool isLoading = false;
  @observable String? nome;
  // ... mais observáveis (erroAoCriarUsuario, erroAoLogar, email, etc.)

  init() async {
    firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      // Busca nome do Firestore collection 'usuarios'
    }
  }

  @action setFirebaseUser(User? value) async {
    firebaseUser = value;
    // Busca dados do Firestore
  }
}
```

### 3.8 constants.dart — URLs Firebase Storage

```dart
// lib/app/shared/constants/constants.dart

// Imagens do Asset (manter)
const String splash4k = 'assets/images/Splash4k.jpg';
const String splash2k = 'assets/images/Splash2k.jpg';
const String bg = 'assets/images/BG8.jpg';
const String tercoBranco = 'assets/images/terco-cut-white.png';
const String iconeBranco = 'assets/images/IconeBranco.png';

// 24 URLs de pastorais (migrar para ImageKit)
const String bastismo = 'https://firebasestorage.googleapis.com/.../batismo.jpg?...';
const String catequese = 'https://firebasestorage.googleapis.com/.../catequese.jpg?...';
const String crisma = 'https://firebasestorage.googleapis.com/.../crisma.jpg?...';
const String dizimo = 'https://firebasestorage.googleapis.com/.../dizimo.jpg?...';
const String eac = 'https://firebasestorage.googleapis.com/.../eac2.jpg?...';
const String ecc = 'https://firebasestorage.googleapis.com/.../ecc.jpg?...';
const String ejc = 'https://firebasestorage.googleapis.com/.../ejc.jpg?...';
const String grupo = 'https://firebasestorage.googleapis.com/.../grupo.jpg?...';
const String liturgia = 'https://firebasestorage.googleapis.com/.../liturgia.jpg?...';
const String musica = 'https://firebasestorage.googleapis.com/.../musica.jpg?...';
const String pascom = 'https://firebasestorage.googleapis.com/.../pascom.jpg?...';
const String ejc2 = 'https://firebasestorage.googleapis.com/.../ejc2.jpg?...';
const String mej = 'https://firebasestorage.googleapis.com/.../mej.jpg?...';
const String saude = 'https://firebasestorage.googleapis.com/.../saude.jpg?...';
const String acolitos = 'https://firebasestorage.googleapis.com/.../acolitos.jpg?...';
const String alfabetizacao = 'https://firebasestorage.googleapis.com/.../alfabetizacao.jpg?...';
const String conferencia_sao_vicente = 'https://firebasestorage.googleapis.com/.../conferencia_sao_vicente.jpg?...';
const String eventos = 'https://firebasestorage.googleapis.com/.../eventos.jpg?...';
const String familiar = 'https://firebasestorage.googleapis.com/.../familiar.jpg?...';
const String mae_tres_vezes = 'https://firebasestorage.googleapis.com/.../mae_tres_vezes.jpg?...';
const String promocao_humana = 'https://firebasestorage.googleapis.com/.../promocao_humana.jpg?...';
const String nascituro = 'https://firebasestorage.googleapis.com/.../nascituro.jpg?...';
const String coroinhas = 'https://firebasestorage.googleapis.com/.../coroinhas.jpg?...';
const String rua = 'https://firebasestorage.googleapis.com/.../rua.jpg?...';
const String cor = 'https://firebasestorage.googleapis.com/.../batismo.jpg?...'; // reutiliza batismo

// 4 URLs de capelas (migrar para ImageKit)
const String saoLourencoDosIndios = 'https://firebasestorage.googleapis.com/.../Capelas/...';
const String meninoJesusDePraga = 'https://firebasestorage.googleapis.com/.../Capelas/...';
const String nSraDaConceicao = 'https://firebasestorage.googleapis.com/.../Capelas/...';
const String nSraGuadalupe = 'https://firebasestorage.googleapis.com/.../Capelas/...';

// 6 URLs de ícones (migrar para ImageKit)
const String facebook = 'https://firebasestorage.googleapis.com/.../Icones/f.png?...';
const String instagram = 'https://firebasestorage.googleapis.com/.../Icones/i.png?...';
const String youtube = 'https://firebasestorage.googleapis.com/.../Icones/y2.png?...';
const String telefone = 'https://firebasestorage.googleapis.com/.../Icones/t.png?...';
const String mapa = 'https://firebasestorage.googleapis.com/.../Icones/m.png?...';
const String whatsapp = 'https://firebasestorage.googleapis.com/.../Icones/w.png?...';

// 1 URL da história da paróquia
const String paroquiaLateral = 'https://firebasestorage.googleapis.com/.../Sobre/paroquia_lateral.jpg?...';

// Cores do tema (manter)
const Color t1 = Color(0xff0D0A08);
const Color t2 = Color(0xff261E17);  // AppBar
const Color t3 = Color(0xff403328);
const Color t4 = Color(0xff6B5745);
const Color t5 = Color(0xff998060);
const Color t6 = Color(0xffd3c8bb);

// Textos longos da história da paróquia (manter ou migrar)
const String historia = "...";

// Blur confissões (manter)
const double confissoesBlurIntensity = 0.5;
const double confissoesOverlayOpacity = 0.15;
```

---

## 4. Coleções Firestore — Estrutura Completa

### 4.1 `avisos`

- IDs aleatórios
- Campos: `data` (timestamp), `descrição` (string), `imagem` (URL Storage), `prioridade` (int64), `titulo` (string)

### 4.2 `avisos_musica`

- IDs aleatórios
- Campos: `data` (timestamp), `descrição` (string), `prioridade` (int64), `titulo` (string)

### 4.3 `clero`

- IDs = nome da função (ex: "pároco")
- Campos: `data_ordenacao` (string), `historia` (string), `imagem` (URL Storage), `nome` (string)

### 4.4 `como_ajudar`

- IDs aleatórios
- Campos: `como ajudar` (string), `imagem` (URL Storage), `link` (string), `ordem` (int64), `titulo` (string)

### 4.5 `confissoes`

- IDs fixos: "primeira_secao", "segunda_secao", "terceira_secao", "quarta_secao"
- **Também possui** documento `texto_confissoes` (usado pelo controller)
- Campos: `texto` (string), `titulo` (string)

### 4.6 `conteudo_pagina_pastoral`

- IDs = slug da pastoral (ex: "acolitos", "eac", "batismo", "catecumenato_crismal")
- Campos: maps dinâmicos onde o nome do map = título da seção
  - Cada map tem: `texto` (string), `ordem` (int64)
  - Maps `>botao*`: `link` (string), `texto` (string), `ordem` (int64)
  - Maps `>imagem*`: `url` (string), `ordem` (int64)

### 4.7 `eventos`

- IDs aleatórios
- Campos: `data` (timestamp), `descricao` (string), `imagem` (URL Storage), `link` (string), `titulo` (string)

### 4.8 `horarios_missas`

- IDs fixos: "domingos", "sabados", "segunda", "terca_a_sexta"
- Campos: `missas` (array de strings), `ordem` (int64), `titulo` (string)

### 4.9 `imagens_capelas`

- IDs fixos: "conceicao", "guadalupe", "indios", "menino"
- Campos: `imagem` (URL Storage)

### 4.10 `administradores`

- IDs aleatórios
- Campos: `addedAt` (timestamp), `addedBy` (string), `email` (string), `isInitialAdmin` (boolean), `name` (string)

### 4.11 `usuarios`

- IDs = Firebase Auth UID
- Campos: `celular` (string), `email` (string), `endereco` (map: bairro, cidade, complemento, estado, logradouro, numero), `nascimento` (timestamp), `nome` (string), `sexo` (string "F"/"M")

---

## 5. Plano de Migração

### Fase 1 — Setup do Strapi (sem mudança no Flutter)

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

### Fase 2 — Camada de Abstração no Flutter

**2.1** Criar `lib/app/shared/services/strapi_client.dart`

- Cliente HTTP centralizado (usar pacote `dio` ou `http`)
- Base URL configurável via .env
- Métodos: `get()`, `post()`, `put()`, `delete()`
- Interceptor para JWT: header `Authorization: Bearer <token>`
- Tratamento de erros padronizado (status codes → exceções tipadas)

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
- Tratar formato Strapi v5: `{ data: { id, attributes: { titulo, data, ... } } }`
- Campos media são objetos: `{ data: { attributes: { url: "https://..." } } }`
- O `toMap()` → `toJson()` sem `Timestamp` (usar ISO 8601 string)

**2.5** Adicionar ao pubspec.yaml

```yaml
dependencies:
  dio: ^5.x.x
  flutter_secure_storage: ^9.x.x
```

---

### Fase 3 — Migrar Módulos (ordem recomendada)

| Passo | Módulo            | Arquivo(s) Principal(is)                                                                              | Endpoint Strapi                                                                 | Notas                                           |
| ----- | ----------------- | ----------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | ----------------------------------------------- |
| 3.1   | Horários          | `lib/app/modules/horarios/horarios_page.dart`                                                         | `GET /api/horario-missas?sort=ordem:asc`                                        | Mais simples, bom para validar o client         |
| 3.2   | Confissões        | `lib/app/modules/confissoes/confissoes_controller.dart`                                               | `GET /api/confissoes?sort=ordem:asc`                                            | MobX controller, boa validação do padrão        |
| 3.3   | Avisos            | `lib/app/modules/avisos/avisos_page.dart`                                                             | `GET /api/avisos?sort=data:desc&populate=imagem`                                | Tem imagem (testar ImageKit)                    |
| 3.4   | Como Ajudar       | `lib/app/modules/como_ajudar/como_ajudar_page.dart`                                                   | `GET /api/como-ajudars?sort=ordem:asc&populate=imagem`                          |                                                 |
| 3.5   | Eventos           | `lib/app/modules/eventos/repositories/eventos_repository.dart`, `evento_model.dart`                   | `GET /api/eventos?filters[data][$gte]=2026-01-01&sort=data:asc&populate=imagem` | Maior complexidade (filtros, model)             |
| 3.6   | **PastoralPage**  | `lib/app/shared/widgets/pastoral_page.dart`                                                           | `GET /api/pastoral-conteudos?filters[slug][$eq]=eac&populate=secoes`            | **Maior impacto**: uma mudança migra 23 módulos |
| 3.7   | Música            | `lib/app/modules/musica/repositories/escala_musica_repository.dart`                                   | Definir endpoints conforme escalas                                              | Sem `musica_mes_corrente`                       |
| 3.8   | Login/Auth        | `auth_repository.dart`, `local_user.dart`, `login_page.dart`, `signup_page.dart`, `profile_page.dart` | `/api/auth/local`, `/api/auth/local/register`, `/api/users/me`                  | Mais complexo, alterar por último               |
| 3.9   | Imagens/Constants | `lib/app/shared/constants/constants.dart`                                                             | URLs do ImageKit via Media Library                                              | 30+ URLs para atualizar                         |
| 3.10  | Home              | `lib/app/modules/home/home_page.dart`                                                                 | Verificar dados buscados                                                        |                                                 |

---

### Fase 4 — Limpeza Final

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

## 6. Arquivos Novos a Criar

| Arquivo                                        | Propósito                              | Status    |
| ---------------------------------------------- | -------------------------------------- | --------- |
| `saolourenco-cms/` (projeto inteiro)           | Projeto Strapi v5 com 10 Content Types | ✅ Criado |
| `lib/app/shared/services/strapi_client.dart`   | Cliente HTTP centralizado (Dio)        | ✅ Criado |
| `lib/app/shared/auth/strapi_auth_service.dart` | Autenticação Strapi (JWT)              | ✅ Criado |
| `lib/app/shared/config/api_config.dart`        | URL base e constantes da API           | ✅ Criado |

---

## 7. Verificação por Fase

| Verificação                                         | Quando                    | Status                |
| --------------------------------------------------- | ------------------------- | --------------------- |
| Strapi admin acessível, content types criados       | Após Fase 1               | ✅ Verificado (11/04) |
| Build do Strapi sem erros                           | Após Fase 1               | ✅ Verificado (11/04) |
| Permissões públicas configuradas                    | Após Fase 1               | ✅ Verificado (11/04) |
| Dados inseridos manualmente no painel Strapi        | Após população manual     | ✅ Feito (14/04)      |
| Imagens carregando do ImageKit                      | Após upload de imagens    | ⬜ Pendente           |
| StrapiClient fazendo GET com sucesso                | Após Fase 2               | ✅ Verificado (14/04) |
| Cada módulo exibindo dados do Strapi                | Após cada passo da Fase 3 | ⬜ Pendente           |
| Cadastro, login, logout, perfil funcionando         | Após 3.8                  | ⬜ Pendente           |
| 23 páginas de pastorais carregando                  | Após 3.6                  | ⬜ Pendente           |
| `flutter build apk` e `flutter build web` sem erros | Após Fase 4               | ⬜ Pendente           |
| App completo funcionando sem Firebase               | Final                     | ⬜ Pendente           |

---

## 8. Formato de Resposta da API Strapi v5

```json
// GET /api/avisos?sort=data:desc&populate=imagem
// ⚠️ Strapi v5 usa formato FLAT (sem "attributes" aninhados, diferente do v4)
{
  "data": [
    {
      "id": 1,
      "documentId": "abc123def456",
      "titulo": "Título do aviso",
      "descricao": "Texto do aviso...",
      "data": "2026-04-10T00:00:00.000Z",
      "prioridade": 1,
      "createdAt": "2026-04-10T00:00:00.000Z",
      "updatedAt": "2026-04-10T00:00:00.000Z",
      "publishedAt": "2026-04-10T00:00:00.000Z",
      "imagem": {
        "id": 5,
        "documentId": "img789xyz",
        "url": "https://ik.imagekit.io/.../imagem.jpg",
        "width": 800,
        "height": 600,
        "formats": { "thumbnail": { "url": "..." }, "small": { "url": "..." } }
      }
    }
  ],
  "meta": {
    "pagination": { "page": 1, "pageSize": 25, "pageCount": 1, "total": 3 }
  }
}
```

> **Nota importante sobre Strapi v5**: Os campos ficam diretamente no objeto de cada item em `data[]`, sem o wrapper `attributes` que existia no Strapi v4. Campos de media (imagem) também seguem formato flat quando populados.

**Filtros úteis da API Strapi:**

- `?sort=campo:asc` ou `:desc`
- `?filters[campo][$eq]=valor`
- `?filters[data][$gte]=2026-01-01`
- `?filters[data][$lt]=2026-12-31`
- `?populate=imagem` (campo de relação/media)
- `?populate=*` (todos os campos)
- `?pagination[page]=1&pagination[pageSize]=10`

---

## 9. Como usar este documento na nova sessão

Na nova sessão do Copilot, diga:

> "Leia o arquivo `docs/MIGRACAO_FIREBASE_STRAPI.md` e vamos continuar a migração pela Fase 2."

Ou para uma fase específica:

> "Leia `docs/MIGRACAO_FIREBASE_STRAPI.md` e vamos implementar o passo 3.6 (PastoralPage)."

---

## 9.1 Setup do CMS em um novo computador (WSL)

Guia completo para clonar e rodar o projeto `saolourenco-cms` em uma máquina nova com WSL.

### Pré-requisitos do sistema

- **WSL 2** com Ubuntu 22.04+ (recomendado: 24.04)
- **Node.js** v22+ (via nvm ou nodesource)
- **Git** configurado com acesso ao repositório

### 1. Instalar Docker Engine no WSL (sem Docker Desktop)

```bash
# Adicionar repositório oficial do Docker
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker Engine + Compose
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Permitir uso sem sudo (requer reinício da sessão WSL)
sudo usermod -aG docker $USER
```

### 2. Clonar o projeto e instalar dependências

```bash
cd ~/projetos  # ou o diretório de sua preferência
git clone <url-do-repositorio> saolourenco-cms
cd saolourenco-cms
npm install
```

### 3. Criar o arquivo `.env`

Copiar o template e preencher os valores:

```bash
cp .env.example .env
```

**Gerar secrets criptográficos** (substituir os valores `toBeModified`):

```bash
# Gerar cada secret individualmente
openssl rand -base64 32  # Executar uma vez para cada campo
```

Preencher no `.env`:

- `APP_KEYS` — duas chaves separadas por vírgula
- `API_TOKEN_SALT`, `ADMIN_JWT_SECRET`, `TRANSFER_TOKEN_SALT`, `JWT_SECRET`, `ENCRYPTION_KEY` — um secret cada

Preencher credenciais do **ImageKit** (obtidas em https://imagekit.io/dashboard):

- `IMAGEKIT_PUBLIC_KEY`
- `IMAGEKIT_PRIVATE_KEY`
- `IMAGEKIT_URL_ENDPOINT`

As configurações do **PostgreSQL local** já vêm preenchidas no template (user: `strapi`, senha: `strapi`, db: `strapi`).

### 4. Subir o banco de dados

```bash
# Iniciar o daemon Docker (necessário após cada reinício do WSL)
sudo service docker start

# Subir o container PostgreSQL 16
cd ~/projetos/saolourenco-cms
docker compose up -d

# Verificar se está rodando e saudável
docker ps
```

Saída esperada: container `strapi-pg` com status `healthy`.

### 5. Iniciar o Strapi

```bash
# Primeiro start — faz build e cria as tabelas automaticamente
npm run develop
```

Acessar `http://localhost:1337/admin` e **criar a conta de administrador**.

As permissões públicas de leitura (find + findOne) para as 9 APIs são criadas automaticamente pelo bootstrap em `src/index.ts`.

### 6. Popular dados

Inserir os registros manualmente pelo painel admin do Strapi:

- Avisos, Clero, Como Ajudar, Confissões, Eventos, Horários, Imagens de Capelas, Pastorais
- Upload de imagens pela Media Library (enviadas automaticamente ao ImageKit)

### Comandos do dia a dia

```bash
# Após reiniciar o WSL
sudo service docker start          # Iniciar Docker daemon
docker compose up -d                # Subir PostgreSQL (se não estiver rodando)
npm run develop                     # Iniciar Strapi em modo desenvolvimento

# Parar tudo
# Ctrl+C no terminal do Strapi
docker compose down                 # Parar PostgreSQL (dados persistem no volume)

# Verificar status
docker ps                           # Ver containers rodando
docker compose logs postgres        # Ver logs do PostgreSQL
```

### Observações

- O volume Docker `strapi-pg-data` persiste os dados mesmo após `docker compose down`.
- Para apagar completamente o banco: `docker compose down -v` (remove o volume).
- Os secrets do `.env` são únicos por máquina — não compartilhar entre ambientes.
- A conta admin do Strapi é criada no banco, então cada ambiente terá a sua.

---

## 10. Registro de Progresso

### ✅ Fase 1 — Concluída em 11/04/2026

#### 10.1 Projeto Strapi criado

- **Localização**: `C:\Projetos\saolourenco-cms\`
- **Versão**: Strapi v5.42.0 (TypeScript)
- **Banco local**: PostgreSQL 16 via Docker (substituiu SQLite em 12/04)
- **Banco produção**: PostgreSQL (Render.com via `DATABASE_URL`)
- **Node.js**: v22.22.2

Comando usado:

```bash
npx --yes create-strapi@latest saolourenco-cms --quickstart --no-run --typescript
```

#### 10.2 Content Types criados (10 coleções via schema.json)

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

#### 10.3 Components criados (2)

| Component               | Arquivo                                     | Uso                                                                                              |
| ----------------------- | ------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| `shared.secao-pastoral` | `src/components/shared/secao-pastoral.json` | Repeatable no PastoralConteudo (campos: titulo, tipo enum, texto, link, url_imagem media, ordem) |
| `shared.endereco`       | `src/components/shared/endereco.json`       | Single no Users & Permissions (campos: logradouro, numero, complemento, bairro, cidade, estado)  |

#### 10.4 ImageKit configurado

- Pacote instalado: `strapi-plugin-imagekit`
- Configuração: `config/plugins.ts` — usa variáveis `IMAGEKIT_PUBLIC_KEY`, `IMAGEKIT_PRIVATE_KEY`, `IMAGEKIT_URL_ENDPOINT`
- CSP middleware: `config/middlewares.ts` — permite `ik.imagekit.io` em `img-src` e `media-src`, `eml.imagekit.io` em `frame-src`
- Credenciais do ImageKit preenchidas no `.env` ✅

#### 10.5 Permissões públicas auto-configuradas

Arquivo `src/index.ts` contém bootstrap que cria automaticamente permissões `find` + `findOne` para o role **Public** nas 9 APIs de leitura pública:

- aviso, aviso-musica, clero, como-ajudar, confissao, pastoral-conteudo, evento, horario-missa, imagem-capela

Log confirmado no primeiro start:

```
✅ Permissão pública criada: api::aviso.aviso.find
✅ Permissão pública criada: api::aviso.aviso.findOne
... (18 permissões no total)
```

#### 10.6 População de dados

- **Modo**: manual, via painel admin do Strapi
- Criar os registros de cada content type diretamente pelo painel
- Fazer upload das imagens pela Media Library (enviadas ao ImageKit automaticamente)
- Dados iniciais populados via painel admin ✅

#### 10.7 Build e start validados

```
✔ Compiling TS (3388ms)
✔ Building build context (365ms)
✔ Building admin panel (36800ms)
✔ Strapi started successfully — http://localhost:1337/admin
```

#### 10.8 Arquivos de configuração do projeto Strapi

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

### ✅ Fase 1.5 — PostgreSQL local com Docker (12/04/2026)

**Motivação**: Paridade dev/prod — evitar diferenças de comportamento entre SQLite (dev) e PostgreSQL (prod no Render.com). Queries, tipos de dados e constraints funcionam igual nos dois ambientes.

#### Arquivos criados/alterados no `saolourenco-cms`:

| Arquivo              | Ação          | Detalhes                                                                                                                                                    |
| -------------------- | ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `docker-compose.yml` | ✅ Criado     | PostgreSQL 16 Alpine, container `strapi-pg`, porta 5432, volume `strapi-pg-data`, healthcheck com `pg_isready`                                              |
| `.dockerignore`      | ✅ Criado     | Exclui node_modules, build, dist, .tmp, .env                                                                                                                |
| `package.json`       | ✅ Atualizado | Dependência `pg` adicionada (`npm install pg`)                                                                                                              |
| `.env`               | ✅ Atualizado | `DATABASE_CLIENT=postgres`, `DATABASE_HOST=localhost`, `DATABASE_PORT=5432`, `DATABASE_NAME=strapi`, `DATABASE_USERNAME=strapi`, `DATABASE_PASSWORD=strapi` |
| `.env.example`       | ✅ Atualizado | Documentação de setup local (Docker) e produção (Render.com `DATABASE_URL`)                                                                                 |
| `config/database.ts` | Sem alteração | Já suportava PostgreSQL via variáveis de ambiente                                                                                                           |

#### docker-compose.yml

```yaml
services:
  postgres:
    image: postgres:16-alpine
    container_name: strapi-pg
    restart: unless-stopped
    ports:
      - "5432:5432"
    environment:
      POSTGRES_DB: strapi
      POSTGRES_USER: strapi
      POSTGRES_PASSWORD: strapi
    volumes:
      - strapi-pg-data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U strapi -d strapi"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  strapi-pg-data:
```

#### Como iniciar o ambiente de desenvolvimento

```bash
cd saolourenco-cms
docker compose up -d      # Subir PostgreSQL
npm run develop            # Iniciar Strapi (cria tabelas automaticamente)
```

#### Dados anteriores (SQLite)

- O banco SQLite (`.tmp/data.db`) não é migrado — os dados devem ser re-inseridos pelo painel admin
- O pacote `better-sqlite3` foi mantido no `package.json` como fallback (sem conflito)

---

### ✅ Fase 1.6 — Migração para WSL e setup do ambiente (14/04/2026)

**Motivação**: Projetos migrados do Windows para o WSL (filesystem Linux) para melhor performance e compatibilidade.

#### O que foi feito:

| #   | Ação                                                                                                                 | Status   |
| --- | -------------------------------------------------------------------------------------------------------------------- | -------- |
| 1   | Projetos clonados no WSL (`/home/tfreitas/projetos/saolourenco_flutter` e `/home/tfreitas/projetos/saolourenco-cms`) | ✅ Feito |
| 2   | Docker Engine instalado nativamente no WSL (sem Docker Desktop) — Docker 29.4.0 + Compose v5.1.2                     | ✅ Feito |
| 3   | PostgreSQL 16 rodando via Docker Compose (`sudo docker compose up -d`)                                               | ✅ Feito |
| 4   | `.env` criado com secrets criptográficos + config PostgreSQL local                                                   | ✅ Feito |
| 5   | Build do Strapi com sucesso (`npm run build`)                                                                        | ✅ Feito |
| 6   | Strapi v5.42.0 iniciado com PostgreSQL e 18 permissões públicas criadas automaticamente                              | ✅ Feito |
| 7   | Painel admin acessível em `http://localhost:1337/admin`                                                              | ✅ Feito |

#### Como iniciar o ambiente de desenvolvimento (WSL)

```bash
# 1. Iniciar o Docker daemon (necessário após reiniciar o WSL)
sudo service docker start

# 2. Subir o PostgreSQL
cd /home/tfreitas/projetos/saolourenco-cms
sudo docker compose up -d

# 3. Iniciar o Strapi
npm run develop
```

#### Nota sobre Docker no WSL

O Docker Engine foi instalado diretamente no Ubuntu 24.04 do WSL (sem Docker Desktop).
Para usar sem `sudo`, o usuário foi adicionado ao grupo `docker` (`sudo usermod -aG docker $USER`).
Após reiniciar a sessão WSL, o grupo será efetivado.

---

### ✅ Fase 1 — Pendências concluídas (14/04/2026)

| #   | Pendência                                       | Status                          |
| --- | ----------------------------------------------- | ------------------------------- |
| 1   | ~~Clonar projetos no WSL~~                      | ✅ Feito                        |
| 2   | ~~Subir Docker + testar Strapi com PostgreSQL~~ | ✅ Feito                        |
| 3   | ~~Criar conta admin Strapi~~                    | ✅ Feito                        |
| 4   | ~~Credenciais ImageKit~~                        | ✅ Feito                        |
| 5   | ~~Popular dados manualmente~~                   | ✅ Feito (dados iniciais)       |
| 6   | **Verificar dados no painel**                   | 🟡 Em andamento                 |
| 7   | **Deploy no Render.com**                        | 🟢 Baixa (pode ser após Fase 2) |

### ⏳ Fase 2 — Camada de Abstração Flutter (iniciada em 14/04/2026)

**Ambiente**: WSL (projetos no filesystem Linux)

**Pré-requisitos — todos concluídos:**

1. ~~Projetos `saolourenco` e `saolourenco-cms` clonados no WSL~~ ✅
2. ~~Docker rodando no WSL (`docker compose up -d` no `saolourenco-cms`)~~ ✅
3. ~~Strapi iniciado com PostgreSQL (`npm run develop`) e painel admin acessível~~ ✅
4. ~~Conta admin criada no Strapi~~ ✅
5. ~~Dados de teste inseridos~~ ✅

#### 10.7 Arquivos criados na Fase 2 (14/04/2026)

| Arquivo                                        | Propósito                                                     | Status    |
| ---------------------------------------------- | ------------------------------------------------------------- | --------- |
| `lib/app/shared/config/api_config.dart`        | URL base (via .env), constantes de endpoints Strapi           | ✅ Criado |
| `lib/app/shared/services/strapi_client.dart`   | Cliente HTTP com Dio, interceptor JWT, gerenciamento de token | ✅ Criado |
| `lib/app/shared/auth/strapi_auth_service.dart` | Login, registro, logout, getMe, updateProfile via Strapi      | ✅ Criado |

#### 10.8 Alterações na Fase 2

| Arquivo                   | Alteração                                                             |
| ------------------------- | --------------------------------------------------------------------- |
| `pubspec.yaml`            | Adicionado `dio: ^5.7.0` e `flutter_secure_storage: ^9.2.4`           |
| `.env`                    | Adicionado `STRAPI_URL=http://localhost:1337`                         |
| `lib/app/app_module.dart` | Registrado `StrapiClient` e `StrapiAuthService` como singletons no DI |

#### 10.9 Formato real da API Strapi v5 (validado)

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

#### Próximo passo: Fase 3 — Migrar módulos

Iniciar pela migração dos módulos na ordem definida na seção 5 (Fase 3).
O passo 3.1 (Horários) é o mais simples e ideal para validar o client.

Na nova sessão, diga:

> "Leia `docs/MIGRACAO_FIREBASE_STRAPI.md` e vamos implementar o passo 3.1 (Horários)."
