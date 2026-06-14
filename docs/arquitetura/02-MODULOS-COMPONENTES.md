# 02 - Módulos e Componentes: Organização por Camadas

**Escopo**: Descrição da organização modular, camadas, responsabilidades e relações entre componentes  
**Última Atualização**: 2026-06-13  
**Responsável**: Equipe Técnica do Projeto

## Visão Geral da Arquitetura em Camadas

O aplicativo Flutter segue uma arquitetura em **4 camadas** com suporte a modularização via Flutter Modular:

```
┌─────────────────────────────────────────────────────────┐
│         CAMADA DE APRESENTAÇÃO (UI)                     │
│  Pages, Widgets, Material Design, Interação Usuário     │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│     CAMADA DE LÓGICA DE NEGÓCIO (Business Logic)        │
│  Controllers (MobX), Services, Providers                │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│         CAMADA DE DADOS (Data / Repository)             │
│  Repositories, Models, Acesso a Firestore/SQLite        │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│      CAMADA DE INTEGRAÇÃO E INFRAESTRUTURA              │
│  Firebase SDK, OneSignal, SQLite, SharedPreferences     │
└─────────────────────────────────────────────────────────┘
```

## Estrutura de Diretórios

```
lib/
├── main.dart                           # Entry point da aplicação
├── app/
│   ├── app_widget.dart                # Widget root (MaterialApp)
│   ├── app_controller.dart            # Controlador global (MobX)
│   ├── app_module.dart                # Modular binding global
│   │
│   ├── modules/                        # Módulos funcionais (36 modules)
│   │   ├── home/                       # Dashboard principal
│   │   ├── login/                      # Autenticação
│   │   ├── avisos/                     # Gerenciam avisos
│   │   ├── eventos/                    # Calendário e eventos
│   │   ├── pastorais/                  # Portal de pastorais
│   │   ├── [pastoral-modules]/         # Catequese, Crisma, EJC, MEJ, etc
│   │   └── notifications/              # Gerenciamento de notificações
│   │
│   └── shared/                         # Código compartilhado (infraestrutura)
│       ├── auth/                       # Utilidades de autenticação
│       ├── constants/                  # Enums, constantes globais
│       ├── services/                   # Serviços reutilizáveis
│       │   └── push_notification_service.dart
│       ├── utils/                      # Funções auxiliares
│       └── widgets/                    # UI widgets reutilizáveis
│
├── firebase_options.dart               # Configuração Firebase
├── firebase_options_env.dart           # Variáveis de ambiente
└── scripts/                            # Scripts utilitários

android/ / ios/ / web/                  # Configurações específicas de plataforma
```

## Camada 1: Apresentação (UI Layer)

**Localização**: `lib/app/modules/[module-name]/`

**Componentes**:

- `[module]_page.dart` - Tela principal do módulo (StatefulWidget)
- `[module]_controller.dart` - Lógica de apresentação com MobX
- `widgets/` - Componentes reutilizáveis dentro do módulo
- `[module]_module.dart` - Binding e roteamento (Modular)

**Responsabilidades**:

- Renderizar UI usando Material Design
- Capturar interações de usuário (taps, gestos, formulários)
- Exibir dados do Controller via Observers (MobX)
- Navegar entre telas via Modular routes
- Mostrar diálogos, snackbars e feedback visual

**Padrões**:

- Stateless Pages que consomem Controllers via context
- Builders reativos com `Observer` de MobX para re-render eficiente
- Separation of concerns: UI apenas apresenta, não contém lógica complexa

**Exemplo**:

```dart
// avisos_page.dart
class AvisosPage extends StatefulWidget {
  @override
  State<AvisosPage> createState() => _AvisosPageState();
}

class _AvisosPageState extends State<AvisosPage> {
  late AvisosController controller;

  @override
  void initState() {
    controller = Modular.get<AvisosController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Avisos")),
      body: Observer(
        builder: (_) => controller.isLoading
            ? CircularProgressIndicator()
            : ListView(children: controller.avisos.map(...).toList()),
      ),
    );
  }
}
```

## Camada 2: Lógica de Negócio (Business Logic Layer)

**Localização**: `lib/app/modules/[module-name]/[module]_controller.dart` + `lib/app/shared/services/`

**Componentes**:

- `[module]_controller.dart` - State management com MobX
- `Services` - Lógica de negócio reutilizável entre módulos
- `Providers` - Injeção de dependências

**Responsabilidades**:

- Gerenciar estado local do módulo (MobX observables, actions, reactions)
- Processar eventos de negócio (criar aviso, atualizar evento, etc)
- Coordenar entre UI e Data Layer
- Tratamento de erros e exceções
- Validações de regras de negócio

**Padrões**:

- Controllers são singletons gerenciados por Modular
- MobX para reatividade: `@observable`, `@action`, `@computed`
- Async/await para operações assincronas
- Try-catch com logging de erros

**Exemplo**:

```dart
// avisos_controller.dart
@Injectable()
class AvisosController {
  @observable
  List<Aviso> avisos = [];

  @observable
  bool isLoading = false;

  final AvisosService service;

  AvisosController(this.service);

  @action
  Future<void> loadAvisos() async {
    isLoading = true;
    try {
      avisos = await service.fetchAvisos();
    } catch (e) {
      // tratamento
    } finally {
      isLoading = false;
    }
  }
}
```

## Camada 3: Dados (Data / Repository Layer)

**Localização**: `lib/app/modules/[module-name]/` (implícita) + injeção via Services

**Componentes**:

- `Repositories` - Abstração de fontes de dados
- `Models` - Estruturas de dados (entities)
- `Adapters` - Conversão entre formatos (JSON ↔ Dart, Firestore ↔ Models)

**Responsabilidades**:

- Centralizar acesso a dados (Firestore, SQLite, API)
- Implementar padrões de acesso (queries, filters, pagination)
- Cache e invalidação de cache
- Transformação de dados brutos em models tipados
- Sincronização entre local storage e backend

**Padrões**:

- Repository pattern: abstração de fonte de dados específica
- Models com `fromJson`, `toJson` para serialização
- Firestore listeners para real-time updates
- Local first com sincronização bidirecional

**Estrutura implícita**:

```
(não há pasta explícita, mas mantida em Services)

AvisosService
├── fetchAvisos() → Future<List<Aviso>>
├── createAviso(Aviso) → Future<void>
├── updateAviso(Aviso) → Future<void>
└── deleteAviso(String id) → Future<void>

class Aviso {
  final String id;
  final String titulo;
  final String conteudo;
  final DateTime dataCriacao;

  factory Aviso.fromJson(Map<String, dynamic> json) => ...
  Map<String, dynamic> toJson() => ...
}
```

## Camada 4: Integração e Infraestrutura (Infrastructure Layer)

**Localização**: `lib/app/shared/` + Firebase/OneSignal SDKs

**Componentes**:

- Firebase SDK (Auth, Firestore, Storage, Analytics)
- OneSignal SDK (Push notifications)
- SQLite (sqflite) - persistência local
- SharedPreferences - configurações leves

**Responsabilidades**:

- Gerenciar conexão com backends
- Implementar retry logic e circuit breakers
- Logging e monitoramento
- Tratamento de conectividade
- Criptografia de dados sensíveis

**Padrões**:

- Singleton services para conexões reutilizáveis
- Interceptadores de requisições para logging
- Error handling centralizado
- Fallback offline-first

**Serviços Principais**:

| Serviço                   | Responsabilidade                                           | Tecnologia                 |
| ------------------------- | ---------------------------------------------------------- | -------------------------- |
| `PushNotificationService` | Inicializar OneSignal, registrar handlers                  | OneSignal SDK              |
| `FirebaseService`         | Abstração sobre Firebase (não explícito, direto no código) | Firebase SDK               |
| `AuthService`             | Autenticação via Firebase                                  | Firebase Auth              |
| `FirestoreRepository`     | CRUD em Firestore                                          | Cloud Firestore SDK        |
| `LocalStorageService`     | Persistência local                                         | sqflite, SharedPreferences |

## Módulos Funcionais (Domínios)

Todos os 36 módulos seguem o mesmo padrão interno:

### Módulos Core (Essenciais)

| Módulo          | Responsabilidade                 | Dependências Externas      |
| --------------- | -------------------------------- | -------------------------- |
| `home`          | Dashboard principal, navegação   | Outros módulos (lazy load) |
| `login`         | Autenticação de usuários         | Firebase Auth              |
| `notifications` | Gerenciamento de push, histórico | OneSignal, Firebase        |

### Módulos de Domínio (Funcionalidades Principais)

| Módulo      | Responsabilidade               | Dados Primários         |
| ----------- | ------------------------------ | ----------------------- |
| `avisos`    | CRUD de avisos paroquiais      | Firestore: `/avisos`    |
| `eventos`   | Calendário, agendamento        | Firestore: `/eventos`   |
| `horarios`  | Horários de missas, atividades | Firestore: `/horarios`  |
| `pastorais` | Portal de pastorais, lista     | Firestore: `/pastorais` |

### Módulos de Pastorais (Atividades Especializadas)

| Módulo      | Pastoral                | Dados Primários                   |
| ----------- | ----------------------- | --------------------------------- |
| `catequese` | Catequese               | Firestore: `/pastorais/catequese` |
| `crisma`    | Crisma                  | Firestore: `/pastorais/crisma`    |
| `batismo`   | Batismo                 | Firestore: `/pastorais/batismo`   |
| `ejc`       | EJC (Jovens)            | Firestore: `/pastorais/ejc`       |
| `mej`       | MEJ (Eucarístico Jovem) | Firestore: `/pastorais/mej`       |
| `saude`     | Pastoral da Saúde       | Firestore: `/pastorais/saude`     |
| `rua`       | Pastoral da Rua         | Firestore: `/pastorais/rua`       |
| ...         | (28+ outros)            | Firestore: `/pastorais/[name]`    |

## Padrões de Comunicação Entre Camadas

### Fluxo Comum: Carregar Dados

```
1. UI (Page)
   ↓ onInit() chama controller.load()

2. Business Logic (Controller)
   ↓ @action loadData() chama service.fetch()

3. Data Layer (Service)
   ↓ fetch() chama repository.query()

4. Infrastructure (Firebase/SQLite)
   ↓ retorna dados brutos

3. Data Layer
   ↓ mapeia Firestore docs → Models

2. Business Logic
   ↓ armazena em @observable, notifica via MobX

1. UI
   ↓ Observer detecta mudança, re-renderiza
```

### Padrão de Injeção de Dependências

```dart
// Modular binding
class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton<HomeController>((i) => HomeController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const HomePage()),
  ];
}

// Uso em Page
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeController controller;

  @override
  void initState() {
    controller = Modular.get<HomeController>();
    super.initState();
  }
}
```

## Responsabilidades por Camada (Matriz de Decisão)

| Decisão                          | Apresentação | Negócio | Dados | Infraestrutura |
| -------------------------------- | :----------: | :-----: | :---: | :------------: |
| Renderizar UI                    |      ✓       |         |       |                |
| Validar entrada do usuário       |      ✓       |         |       |                |
| Executar regras de negócio       |              |    ✓    |       |                |
| Gerenciar estado local           |              |    ✓    |       |                |
| Acessar dados                    |              |         |   ✓   |                |
| Transformar dados (JSON ↔ Model) |              |         |   ✓   |                |
| Conectar com backends            |              |         |       |       ✓        |
| Tratamento de conectividade      |              |         |       |       ✓        |
| Logging de eventos               |              |    ✓    |       |       ✓        |

## Relações e Dependências Entre Módulos

### Padrão: Lazy Loading via Modular

Cada módulo é carregado sob demanda:

- `app_module.dart` registra rotas de todos os módulos
- Quando usuário navega para `/avisos`, o módulo é inicializado
- Controllers e services são instanciados

**Grafo Simplificado**:

```
AppModule (root)
├── HomeModule (eager)
├── LoginModule (eager)
├── AvisosModule (lazy)
├── EventosModule (lazy)
├── PastoraisModule (lazy)
│   ├── CatequesModule (lazy)
│   ├── CrismaModule (lazy)
│   └── ... (outros pastorais)
└── NotificationsModule (lazy)
```

### Dependências Compartilhadas

```
SharedLayer (infraestrutura)
├── PushNotificationService
├── AuthService (via Firebase)
├── Constants (enums, valores globais)
└── Widgets (UI components reutilizáveis)

Todos os modules → dependem de SharedLayer
```

## Rastreabilidade

- **Código-fonte de módulos**: `lib/app/modules/[module-name]/`
- **Infraestrutura compartilhada**: `lib/app/shared/`
- **Entry point**: `lib/main.dart`
- **Binding global**: `lib/app/app_module.dart`
- **Root Widget**: `lib/app/app_widget.dart`
- **Gerenciamento de estado**: MobX (`.g.dart` auto-gerados)

## Notas de Atualização

Este documento foi validado contra:

- ✓ Estrutura de diretórios em 2026-06-13
- ✓ Padrão de Controllers (MobX) analisado
- ✓ Flutter Modular binding verificado
- ✓ Shared utilities inspecionadas

**Próxima revisão**: Agendar se houver:

- Novo padrão de gerenciamento de estado
- Mudanças significativas em estrutura de módulos
- Adição de novas camadas (ex: Domain Layer com UseCases)
- Alterações em estratégia de injeção de dependências
