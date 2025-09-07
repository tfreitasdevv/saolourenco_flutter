# Guia de Configuração - OneSignal Push Notifications

Este guia irá te ajudar a configurar as notificações push usando OneSignal no projeto da Paróquia São Lourenço.

## 📋 Pré-requisitos

1. Conta no OneSignal (gratuita)
2. Projeto Flutter configurado
3. Android SDK configurado (para apps Android)

## 🚀 Passo a Passo

### 1. Criando conta no OneSignal

1. Acesse [OneSignal](https://onesignal.com/)
2. Clique em "Get Started Free"
3. Crie sua conta
4. Confirme seu email

### 2. Criando um novo App no OneSignal

1. No dashboard do OneSignal, clique em "New App/Website"
2. Digite o nome do app: **"Paróquia São Lourenço"**
3. Selecione as plataformas:
   - ✅ Google Android (FCM)
   - ✅ Apple iOS
   - ✅ Google Chrome (Web Push)

### 3. Configuração Android (FCM)

1. **Obter arquivo google-services.json:**
   - Acesse o [Firebase Console](https://console.firebase.google.com/)
   - Selecione seu projeto
   - Vá em "Configurações do projeto" > "Geral"
   - Role para baixo até "Seus apps"
   - Clique no ícone do Android
   - Baixe o arquivo `google-services.json`

2. **Configurar no OneSignal:**
   - Na configuração do Android no OneSignal
   - Faça upload do arquivo `google-services.json`
   - Ou copie as informações manualmente:
     - **Firebase Server Key**: Encontre em Firebase Console > Configurações > Cloud Messaging
     - **Firebase Sender ID**: Encontre no `google-services.json` → `project_number`

3. **Salvar configurações**

### 4. Configuração iOS (Opcional)

1. **Apple Push Certificates:**
   - Acesse o [Apple Developer Portal](https://developer.apple.com/)
   - Crie um Push Certificate para seu app
   - Baixe o certificado (.p12)

2. **Configurar no OneSignal:**
   - Upload do certificado .p12
   - Digite a senha do certificado
   - Selecione o ambiente (Development/Production)

### 5. Configuração Web Push (Opcional)

1. **Site URL:** Digite a URL do seu site
2. **Choose a Label:** Nome que aparecerá para o usuário
3. **Site Name:** Nome do seu site
4. **Default Icon URL:** URL do ícone do site

### 6. Obtendo as chaves do OneSignal

Após criar o app, você receberá:

1. **App ID**: Identificador único do seu app
   - Exemplo: `12345678-1234-1234-1234-123456789012`

2. **REST API Key**: Para enviar notificações via API
   - Encontre em: OneSignal Dashboard > Settings > Keys & IDs

### 7. Configurando o arquivo .env

1. **Crie o arquivo .env** na raiz do projeto (se não existir):
   ```bash
   cp .env.example .env
   ```

2. **Adicione as configurações do OneSignal:**
   ```bash
   # OneSignal Configuration
   ONESIGNAL_APP_ID=seu_app_id_aqui
   ONESIGNAL_REST_API_KEY=sua_rest_api_key_aqui
   ```

### 8. Instalando dependências

Execute o comando no terminal:
```bash
flutter pub get
```

### 9. Configurações de Build

**Android:**
- O arquivo `google-services.json` deve estar em `android/app/`
- As permissões já foram adicionadas ao `AndroidManifest.xml`

**iOS:**
- Configure o Bundle ID corretamente
- Adicione as capacidades de Push Notifications no Xcode

## 🧪 Testando as Notificações

### 1. Via App

1. Execute o app: `flutter run`
2. Navegue para a página de configurações de notificação
3. Solicite a permissão para notificações
4. Copie o Player ID exibido

### 2. Via Dashboard OneSignal

1. Acesse o dashboard do OneSignal
2. Clique em "Messages" > "New Push"
3. Configure a mensagem:
   - **Title**: Título da notificação
   - **Message**: Conteúdo da notificação
   - **Icon**: URL do ícone (opcional)

4. **Audience**: Escolha uma das opções:
   - **Send to All Users**: Todos os usuários
   - **Send to Particular Users**: Cole o Player ID copiado do app

5. Clique em "Send Message"

### 3. Testando Segmentação

Você pode criar segmentos baseados em:
- **Tags**: Definidas no app (`user_type`, `location`, etc.)
- **Location**: Geolocalização dos usuários
- **Device Type**: Android, iOS, Web
- **Language**: Idioma do dispositivo
- **Time Zone**: Fuso horário

## 📱 Recursos Avançados

### 1. Notificações Personalizadas

```dart
// Exemplo de dados customizados
await pushService.setUserTags({
  'user_type': 'parishioner',
  'interests': 'liturgy,events,news',
  'location': 'sao_lourenco',
  'ministry': 'choir'
});
```

### 2. Deep Linking

Configure ações quando o usuário clicar na notificação:

```json
{
  "screen": "events",
  "event_id": "123",
  "action": "view_details"
}
```

### 3. Notificações Agendadas

No dashboard do OneSignal:
1. Configure sua mensagem
2. Em "Delivery", selecione "Scheduled"
3. Defina data e hora de envio

### 4. A/B Testing

1. Crie duas versões da mensagem
2. OneSignal automaticamente divide a audiência
3. Analise qual versão performa melhor

## 📊 Analytics e Métricas

O OneSignal fornece métricas detalhadas:

- **Delivered**: Quantas notificações foram entregues
- **Opened**: Quantas foram abertas
- **Click Rate**: Taxa de cliques
- **Conversion Rate**: Taxa de conversão

### Eventos Customizados

```dart
// Rastrear eventos específicos
await pushService.sendEvent('mass_attendance', {
  'mass_type': 'sunday',
  'time': '08:00',
  'location': 'main_church'
});
```

## 🔧 Solução de Problemas

### Problemas Comuns

1. **"App ID não encontrado"**
   - Verifique se o `ONESIGNAL_APP_ID` está correto no .env
   - Confirme se o arquivo .env está sendo carregado

2. **"Permissão negada"**
   - Usuário negou permissão de notificação
   - Oriente o usuário a habilitar nas configurações do dispositivo

3. **"Player ID nulo"**
   - OneSignal não foi inicializado corretamente
   - Verifique se `initialize()` foi chamado no main.dart

4. **Notificações não chegam**
   - Verifique se o app está em foreground/background
   - Confirme se o Player ID está correto
   - Teste com "Send to All Users" primeiro

### Logs de Debug

Para ativar logs detalhados:
```dart
OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
```

### Teste em Diferentes Cenários

- App fechado
- App em background
- App em foreground
- Diferentes dispositivos/versões do Android

## 📝 Próximos Passos

1. **Configurar notificações automáticas** para:
   - Novos eventos da paróquia
   - Lembretes de missas
   - Comunicados importantes

2. **Implementar segmentação avançada**:
   - Por ministérios
   - Por idade
   - Por localização

3. **Adicionar notificações rich media**:
   - Imagens
   - Botões de ação
   - Sons customizados

4. **Integrar com backend**:
   - API para envio automático
   - Sincronização com calendário de eventos

## 🔗 Links Úteis

- [Dashboard OneSignal](https://app.onesignal.com/)
- [Documentação OneSignal Flutter](https://documentation.onesignal.com/docs/flutter-sdk-setup)
- [Firebase Console](https://console.firebase.google.com/)
- [OneSignal REST API](https://documentation.onesignal.com/reference/create-notification)

---

**💡 Dica:** Comece sempre testando com seu próprio dispositivo usando o Player ID antes de enviar para todos os usuários!
