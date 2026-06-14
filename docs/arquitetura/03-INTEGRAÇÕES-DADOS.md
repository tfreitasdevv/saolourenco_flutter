# 03 - Integrações Externas e Fluxos de Dados

**Escopo**: Serviços externos, protocolos de integração, fluxos de dados críticos e persistência  
**Última Atualização**: 2026-06-13  
**Responsável**: Equipe Técnica do Projeto

## Visão Geral de Integrações Externas

O sistema integra-se com múltiplos serviços externos em modelo **cloud-centric**, onde o Firebase é o backend centralizado e OneSignal fornece camada de notificações.

```
┌─────────────────────┐
│  App Flutter        │
│ (Mobile/Web)        │
└──────────┬──────────┘
           │
      ┌────┴────┐
      │          │
      ▼          ▼
  ┌────────┐  ┌──────────┐
  │Firebase│  │OneSignal │
  └────────┘  └──────────┘
      │            │
      ├─ Auth      ├─ Push iOS
      ├─ Firestore ├─ Push Android
      ├─ Storage   └─ Analytics
      ├─ Analytics
      └─ Hosting
```

## 1. Firebase (Backend Centralizado)

### 1.1 Firebase Authentication

**Responsabilidade**: Autenticação centralizada de usuários

**Fluxo de Autenticação**:

```
1. Usuário acessa Login
   ↓
2. App exibe opções:
   - Email/Senha
   - Google Sign-In
   - Apple Sign-In
   ↓
3. Credencial é enviada para Firebase Auth
   ↓
4. Firebase valida credencial
   ↓
5. Se bem-sucedido:
   - Token JWT gerado
   - ID de usuário retornado
   - App armazena token localmente
   ↓
6. Sessão ativada, app desbloqueia funcionalidades
```

**Implementação**:

```dart
// Localização: implícita em Services (Firebase SDK)
FirebaseAuth.instance.signInWithEmailAndPassword(
  email: email,
  password: password
);
```

**Provedores Suportados**:

- Email e Senha (nativo)
- Google Sign-In (OAuth 2.0)
- Apple Sign-In (OpenID Connect)

**Segurança**:

- Tokens armazenados localmente com segurança nativa (Keychain iOS, Keystore Android)
- Expiração automática com refresh token
- Validação de email (opcional)
- 2FA (suportado mas não obrigatório nesta versão)

**Configuração**:

```
firebase_options_env.dart:
- FIREBASE_API_KEY_ANDROID
- FIREBASE_APP_ID_ANDROID
- FIREBASE_MESSAGING_SENDER_ID
- FIREBASE_PROJECT_ID
- FIREBASE_STORAGE_BUCKET
```

### 1.2 Cloud Firestore (Banco de Dados Principal)

**Responsabilidade**: Persistência centralizada de dados paroquiais em modelo NoSQL real-time

**Modelo de Dados**:

```
Database: sao-lourenco

Coleções Principais:
├── avisos/
│   ├── {id}
│   │   ├── titulo: string
│   │   ├── conteudo: string
│   │   ├── dataCriacao: timestamp
│   │   ├── dataAtualizacao: timestamp
│   │   └── autores: array<uid>
│
├── eventos/
│   ├── {id}
│   │   ├── titulo: string
│   │   ├── descricao: string
│   │   ├── data: timestamp
│   │   ├── local: string
│   │   ├── pastoral: reference → /pastorais/{id}
│   │   └── participantes: array<uid>
│
├── pastorais/
│   ├── {name}
│   │   ├── titulo: string
│   │   ├── descricao: string
│   │   ├── coordenador: uid
│   │   ├── horarios: array<string>
│   │   └── membros: array<uid>
│
├── usuarios/
│   ├── {uid}
│   │   ├── nome: string
│   │   ├── email: string
│   │   ├── telefone: string
│   │   ├── dataCriacao: timestamp
│   │   ├── role: enum (fiel|coordenador|admin)
│   │   └── pastorais: array<reference>
│
└── configuracoes/
    ├── app
    │   ├── versaoApp: string
    │   ├── ultimaAtualizacao: timestamp
    │   └── avisosCriticos: array<string>
```

**Fluxo de Sincronização Real-Time**:

```
1. App inicia (login bem-sucedido)
   ↓
2. Controllers registram listeners em coleções críticas
   ↓
3. Firestore envia snapshot inicial
   ↓
4. App armazena em @observable (MobX)
   ↓
5. UI re-renderiza com dados iniciais
   ↓
6. Enquanto app está aberto:
   - Qualquer mudança em Firestore
   - Push para app em tempo real
   - MobX notifica observers
   - UI atualiza automaticamente
   ↓
7. App desconecta ou fecha:
   - Listeners removidos
   - Dados persistem em cache local (SQLite)
```

**Exemplo**: Avisos

```dart
// Controller
AvisosController {
  @observable
  List<Aviso> avisos = [];

  AvisosController(this.service) {
    _setupListener();
  }

  void _setupListener() {
    FirebaseFirestore.instance
      .collection('avisos')
      .orderBy('dataCriacao', descending: true)
      .limit(50)
      .snapshots()
      .listen((snapshot) {
        avisos = snapshot.docs
          .map((doc) => Aviso.fromJson(doc.data()))
          .toList();
      });
  }
}
```

**Características**:

- Listeners contínuos (snapshot updates)
- Offline persistence automática (SQLite local)
- Sincronização bidirecional quando reconectado
- Transações para operações multi-documento
- Indexes automáticos em queries comuns

**Limites e Considerações**:

- Leitura/escrita sob demanda (preço por operação)
- 25KB limite por documento
- Máximo 20.000 documentos por transação
- Index em campos compostos requer setup manual

**Segurança**:

```
Firestore Security Rules:
- Usuários autenticados podem ler dados públicos
- Dados sensíveis (info pessoal) restritos a usuário
- Coordenadores podem editar dados de sua pastoral
- Admins podem editar qualquer coisa
```

### 1.3 Firebase Storage

**Responsabilidade**: Armazenamento de mídia (imagens, documentos) para app e web

**Estrutura de Buckets**:

```
gs://sao-lourenco.appspot.com/

├── avisos/{id}/
│   └── [imagens anexadas ao aviso]
│
├── eventos/{id}/
│   └── [imagens/documentos do evento]
│
├── usuarios/{uid}/
│   └── [foto de perfil, documentos pessoais]
│
└── pastorais/{name}/
    └── [mídia de pastoral]
```

**Upload / Download**:

```dart
// Upload
await FirebaseStorage.instance
  .ref('avisos/$avisoId/imagem.jpg')
  .putFile(file);

// Download URL
final url = await FirebaseStorage.instance
  .ref('avisos/$avisoId/imagem.jpg')
  .getDownloadURL();
```

**Limitações**:

- Max 500MB por arquivo (mobile) / 5GB (web)
- Throughput throttling sob carga

### 1.4 Firebase Analytics

**Responsabilidade**: Coleta de eventos de uso e comportamento

**Eventos Rastreados**:

- `screen_view` - Cada tela acessada
- `button_click` - Cliques em CTAs principais
- `pastoral_accessed` - Acesso a pastoral
- `event_registered` - Registro em evento
- `notification_opened` - Abertura de notificação push

**Uso**:

```dart
FirebaseAnalytics.instance.logEvent(
  name: 'pastoral_accessed',
  parameters: {
    'pastoral_name': 'catequese',
    'user_role': 'fiel',
  },
);
```

### 1.5 Firebase Hosting

**Responsabilidade**: Distribuição da versão web

**URL**: `https://sao-lourenco.web.app`

**Deploy**:

```bash
flutter build web
firebase deploy --only hosting
```

**Recursos**:

- SSL/TLS automático
- CDN global
- Redirects customizáveis
- Rewrite rules para SPA (índice em rotas não encontradas)

---

## 2. OneSignal (Notificações Push)

### 2.1 Arquitetura de Notificações

**Responsabilidade**: Entrega confiável de notificações push para iOS e Android

**Fluxo Geral**:

```
1. Gestor publica aviso/evento em app ou Firebase Console
   ↓
2. Trigger Cloud Function (ou direto)
   ↓
3. OneSignal API é chamada com targeting
   ↓
4. OneSignal encaminha para APNs (iOS) e FCM (Android)
   ↓
5. Dispositivos recebem notificação
   ↓
6. Usuário clica → app abre com contexto
   ↓
7. Analytics registra conversão
```

**Inicialização**:

```dart
// PushNotificationService
Future<void> initialize() async {
  OneSignal.initialize(_appId);

  // Handlers de eventos
  _setupNotificationHandlers();

  // Requisita permissão
  await _requestPermission();
}

// Configuração em .env
ONESIGNAL_APP_ID=xxxxx
```

### 2.2 Tipos de Notificações

| Tipo                        | Trigger                | Payload              | Segmentação         |
| --------------------------- | ---------------------- | -------------------- | ------------------- |
| **Aviso de Comunicado**     | Novo aviso criado      | Título, resumo, link | Todos os usuários   |
| **Evento Próximo**          | Evento em 24h          | Título, hora, local  | Pastoral específica |
| **Lembrete de Missa**       | Horário configurado    | Dia/hora, local      | Todas as pastorais  |
| **Notificação de Cadastro** | Novo evento registrado | Confirmação          | Usuário específico  |
| **Aviso Crítico**           | Situação urgente       | Ícone crítico, ação  | Seleção manual      |

### 2.3 Handlers e Deep Linking

```dart
void _setupNotificationHandlers() {
  // Notificação recebida em foreground
  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    event.notification.display();
  });

  // Notificação clicada (foreground ou background)
  OneSignal.Notifications.addClickListener((event) {
    final data = event.notification.additionalData;
    final tipo = data?['tipo']; // 'aviso', 'evento', etc
    final id = data?['id'];

    _navegarPara(tipo, id);
  });
}

void _navegarPara(String tipo, String id) {
  switch (tipo) {
    case 'aviso':
      Modular.to.pushNamed('/avisos/$id');
      break;
    case 'evento':
      Modular.to.pushNamed('/eventos/$id');
      break;
    // ...
  }
}
```

### 2.4 Segmentação e Targeting

```dart
// Tag usuários por pastoral
OneSignal.User.addTag('pastoral', 'catequese');
OneSignal.User.addTag('role', 'coordenador');

// Enviar para coordenadores de catequese
OneSignal API call:
{
  "contents": {"en": "Nova inscrição na catequese"},
  "filters": [
    {"field": "tag", "key": "pastoral", "value": "catequese"},
    {"field": "tag", "key": "role", "value": "coordenador"}
  ]
}
```

### 2.5 Métricas de OneSignal

| Métrica       | Significado                              |
| ------------- | ---------------------------------------- |
| **Sent**      | Notificações entregues para Apple/Google |
| **Delivered** | Confirmação de entrega no dispositivo    |
| **Clicked**   | Usuário clicou na notificação            |
| **Bounced**   | Token inválido ou expirado               |

**Exemplo**: Campaign de aviso crítico pode ter 10k sent, 9.5k delivered, 2.3k clicked (23% CTR).

---

## 3. Fluxos de Dados Críticos

### Fluxo A: Autenticação → Sessão → Desbloqueio de Features

```
┌─ Usuário (não autenticado)
│
├─ Insere credenciais
│
├─ App envia para Firebase Auth
│
├─ Firebase valida e retorna token
│
├─ App armazena token em Keystore/Keychain
│
├─ Controllers observam mudança de autenticação
│
└─ Funcionalidades desbloqueadas
   ├─ Listeners em Firestore ativam
   ├─ Dados sincronizam em tempo real
   └─ UI atualiza
```

**Implementação**:

```dart
// AppController (global state)
@observable
User? currentUser;

@action
Future<void> login(String email, String password) async {
  try {
    final userCred = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: password);

    currentUser = _mapFirebaseUser(userCred.user);
    // Listeners ativam automaticamente em outros controllers

  } catch (e) {
    // Tratamento de erro
  }
}
```

### Fluxo B: Publicação de Aviso → Sincronização → Notificação

```
┌─ Gestor (web admin)
│
├─ Cria novo aviso
│
├─ App escreve em Firestore /avisos/{id}
│
├─ Firestore dispara trigger (possível Cloud Function)
│
├─ Cloud Function chama OneSignal API
│
├─ OneSignal encaminha para APNs/FCM
│
└─ Todos os clientes recebem em tempo real
   ├─ Listeners em AvisosController recebem snapshot
   ├─ @observable avisos atualiza
   ├─ UI re-renderiza com novo aviso
   └─ Notificação push entregue (paralelo)
```

**Latência Esperada**:

- Escrita em Firestore → UI atualizada: ~500-2000ms
- Notificação push entregue: ~1-5 segundos

### Fluxo C: Sincronização Offline-First

```
┌─ App entra em área sem conexão
│
├─ Firestore listeners continuam ativos localmente
│
├─ Leituras servidas do cache SQLite local
│
├─ Escritas são enfileiradas localmente
│
└─ Quando reconectado
    ├─ Firestore sincroniza fila de escritas
    ├─ Conflitos resolvidos (last-write-wins ou merge)
    ├─ Listeners recebem atualizações
    └─ UI fica consistente
```

**Exemplo**: Usuário em missa abre app, vê avisos offline. Sai de missa, reconecta, app sincroniza automaticamente.

---

## 4. Persistência Local (Offline-First)

### 4.1 SQLite (sqflite)

**Uso**: Cache persistente de dados críticos para offline

**Tabelas Típicas**:

```sql
CREATE TABLE avisos (
  id TEXT PRIMARY KEY,
  titulo TEXT,
  conteudo TEXT,
  dataCriacao INTEGER,
  dataAtualizacao INTEGER,
  syncStatus TEXT -- 'synced', 'pending', 'error'
);

CREATE TABLE eventos (
  id TEXT PRIMARY KEY,
  titulo TEXT,
  data INTEGER,
  pastoral TEXT,
  syncStatus TEXT
);

CREATE TABLE usuarios (
  uid TEXT PRIMARY KEY,
  nome TEXT,
  email TEXT,
  role TEXT
);
```

**Sincronização**:

```dart
// Ao receber update do Firestore
void _onFirestoreUpdate(Aviso avisoRemoto) {
  // 1. Atualiza local
  await sqliteDb.update('avisos', avisoRemoto.toJson());

  // 2. Atualiza MobX
  avisos = [...avisos].map((a) => a.id == avisoRemoto.id ? avisoRemoto : a).toList();

  // 3. UI re-renderiza
}
```

### 4.2 SharedPreferences

**Uso**: Configurações leves, flags de primeira execução, tokens

```dart
// Armazenar
final prefs = await SharedPreferences.getInstance();
prefs.setString('lastAvisoSync', DateTime.now().toIso8601String());
prefs.setBool('notificationsEnabled', true);

// Recuperar
final lastSync = DateTime.parse(prefs.getString('lastAvisoSync') ?? '');
```

---

## 5. Tratamento de Erros e Resiliência

### 5.1 Retry Logic

```dart
// Função genérica com retry exponencial
Future<T> executeWithRetry<T>(
  Future<T> Function() operation,
  {int maxRetries = 3, Duration initialDelay = const Duration(seconds: 1)}
) async {
  int retryCount = 0;

  while (true) {
    try {
      return await operation();
    } catch (e) {
      if (retryCount >= maxRetries) rethrow;

      final delay = initialDelay * pow(2, retryCount);
      await Future.delayed(delay);
      retryCount++;
    }
  }
}

// Uso
await executeWithRetry(() => FirebaseFirestore.instance.collection('avisos').get());
```

### 5.2 Circuit Breaker

```dart
// Previne cascata de falhas
class CircuitBreaker {
  int failureCount = 0;
  bool isClosed = true; // healthy

  Future<T> execute<T>(Future<T> Function() operation) async {
    if (!isClosed) throw Exception('Circuit breaker is open');

    try {
      final result = await operation();
      failureCount = 0;
      return result;
    } catch (e) {
      failureCount++;
      if (failureCount > 5) {
        isClosed = false;
        Future.delayed(Duration(minutes: 5), () => isClosed = true);
      }
      rethrow;
    }
  }
}
```

### 5.3 Fallback e Graceful Degradation

```dart
// Se Firestore falhar, usar cache local
Future<List<Aviso>> getAvisos() async {
  try {
    return await FirebaseFirestore.instance.collection('avisos').get()...
  } catch (e) {
    debugPrint('Firebase indisponível, usando cache local');
    return await _getAvisosLocal();
  }
}
```

---

## 6. Segurança de Dados

### 6.1 Dados Sensíveis

| Dado                     | Armazenamento                       | Proteção                   |
| ------------------------ | ----------------------------------- | -------------------------- |
| **Token Firebase**       | Keystore (Android) / Keychain (iOS) | Encriptação nativa OS      |
| **Credenciais de login** | Nunca armazenado                    | Apenas token armazenado    |
| **Informações pessoais** | Firestore                           | Rules restringem a usuário |
| **Dados de API**         | SQLite com encryption               | Encrypt at rest (opcional) |

### 6.2 Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Avisos - leitura pública, escrita apenas admin
    match /avisos/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.token.admin == true;
    }

    // Usuários - leitura própria, escrita própria
    match /usuarios/{uid} {
      allow read: if request.auth.uid == uid;
      allow write: if request.auth.uid == uid;
    }

    // Pastorais - leitura pública, escrita coordenador
    match /pastorais/{docId} {
      allow read: if request.auth != null;
      allow write: if request.auth.token.role in ['admin', 'coordenador'];
    }
  }
}
```

---

## Rastreabilidade

- **Firebase Setup**: `lib/firebase_options_env.dart`, `firebase.json`
- **Inicialização**: `lib/main.dart` (Firebase.initializeApp)
- **Push Notifications**: `lib/app/shared/services/push_notification_service.dart`
- **Configuração .env**: `ONESIGNAL_APP_ID`, variáveis Firebase
- **Firestore Models**: Implícito em cada módulo (serialização JSON)

## Notas de Atualização

Este documento foi validado contra:

- ✓ main.dart (Firebase init, OneSignal init)
- ✓ firebase_options_env.dart (Firebase config)
- ✓ PushNotificationService (OneSignal setup)
- ✓ pubspec.yaml (dependências Firebase e OneSignal)
- ✓ docs/ (docs de segurança e setup)

**Próxima revisão**: Agendar se houver:

- Mudanças em estrutura de dados Firestore
- Migração de backend
- Alterações em política de sincronização offline
- Novas integrações externas (ex: pagamento, SMS)
- Ajustes em Firestore Security Rules
