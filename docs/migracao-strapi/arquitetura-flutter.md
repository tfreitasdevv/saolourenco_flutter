# Arquitetura Atual do App Flutter

> Referência histórica do estado do projeto **antes** da migração para Strapi.
> Para os padrões **já migrados**, consulte [padroes-strapi.md](padroes-strapi.md).

---

## Stack tecnológico

- **Framework**: Flutter (Android + Web + iOS)
- **State management**: MobX (com code generation via `mobx_codegen`)
- **Routing/DI**: Flutter Modular (`flutter_modular`)
- **Backend**: Firebase (Firestore + Auth + Storage) — em migração para Strapi
- **Push notifications**: OneSignal (independente do Firebase — manter)
- **Pacote do app**: `paroquia_sao_lourenco`

## Dependências Firebase atuais (pubspec.yaml)

```yaml
firebase_core: ^3.6.0
firebase_auth: ^5.3.1
cloud_firestore: ^5.4.3
firebase_storage: ^12.3.2
firebase_analytics: ^11.3.3
cached_network_image: ^3.4.1
```

## Estrutura de diretórios

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

## Padrão de módulo (Flutter Modular)

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

## Código-Fonte Firebase Original (Referência Histórica)

> As seções abaixo documentam o código **original Firebase** para referência durante a migração.
> Use-as para entender a lógica que precisa ser preservada ao reescrever para Strapi.

### main.dart — Inicialização Firebase

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

### PastoralPage — Widget centralizado (migra 23 módulos de uma vez)

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

### Acesso direto ao Firestore (Avisos, Horários, Como Ajudar)

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

### Repository com Stream (Eventos)

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

### Confissões (MobX Controller)

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

### AuthRepository — Autenticação + Perfil

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

### LocalUser — Estado MobX Global

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

### constants.dart — URLs Firebase Storage

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
// ... (22 mais URLs de pastorais)
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
