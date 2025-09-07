# Guia de Implementação - Push Notifications com Firebase Cloud Messaging

## 📱 Visão Geral

Este guia mostra como implementar e usar as notificações push no app da Paróquia São Lourenço usando Firebase Cloud Messaging (FCM).

## ✅ O que foi implementado

### 1. Dependências Adicionadas
- `firebase_messaging: ^15.1.3` - Pacote principal do FCM

### 2. Arquivos Criados/Modificados

#### **Serviço de Notificações**
- `lib/app/services/notification_service.dart` - Serviço principal para gerenciar FCM
- `lib/app/widgets/notification_test_widget.dart` - Widget para testar notificações

#### **Configurações Android**
- Permissões adicionadas no `AndroidManifest.xml`:
  - `WAKE_LOCK` - Para acordar o dispositivo
  - `VIBRATE` - Para vibração
  - `RECEIVE_BOOT_COMPLETED` - Para iniciar após reinicialização
  - `POST_NOTIFICATIONS` - Para Android 13+

#### **Configurações iOS**
- Background modes adicionados no `Info.plist`:
  - `fetch` - Para buscar conteúdo em background
  - `remote-notification` - Para notificações remotas

#### **Inicialização**
- `main.dart` - Configurado para inicializar o serviço de notificações

## 🚀 Como Usar

### 1. **Testar Notificações**
Navegue para a rota `/notification-test` para acessar o widget de teste:
```dart
// Exemplo de navegação
Modular.to.pushNamed('/notification-test');
```

### 2. **Obter Token FCM**
```dart
final notificationService = NotificationService();
final token = await notificationService.getToken();
print('Token FCM: $token');
```

### 3. **Inscrever em Tópicos**
```dart
// Inscrever em um tópico
await notificationService.subscribeToTopic('eventos');

// Desinscrever de um tópico
await notificationService.unsubscribeFromTopic('eventos');
```

### 4. **Escutar Notificações**
```dart
// Escutar mensagens recebidas
notificationService.messageStream.listen((message) {
  print('Notificação recebida: ${message.notification?.title}');
  // Processar a notificação
});
```

## 📨 Enviando Notificações

### 1. **Via Firebase Console**
1. Acesse o [Firebase Console](https://console.firebase.google.com)
2. Selecione seu projeto
3. Vá em "Cloud Messaging"
4. Clique em "Send your first message"
5. Preencha os dados e envie

### 2. **Via API REST**
```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=SEU_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "TOKEN_DO_DISPOSITIVO",
    "notification": {
      "title": "Título da Notificação",
      "body": "Corpo da mensagem"
    },
    "data": {
      "custom_field": "valor_personalizado"
    }
  }'
```

### 3. **Para Tópicos**
```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=SEU_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "/topics/eventos",
    "notification": {
      "title": "Novo Evento",
      "body": "Confira o novo evento da paróquia"
    }
  }'
```

## 🔧 Configurações Avançadas

### 1. **Personalizar Notificações no Android**
Crie um arquivo `android/app/src/main/res/drawable/notification_icon.xml` para ícone personalizado.

### 2. **Configurar Canais de Notificação (Android)**
```dart
// Adicione no NotificationService se necessário
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.max,
);
```

### 3. **Manipular Dados Personalizados**
```dart
void _handleNotificationTap(RemoteMessage message) {
  // Navegar baseado nos dados
  if (message.data['screen'] == 'eventos') {
    Modular.to.pushNamed('/eventos');
  } else if (message.data['screen'] == 'profile') {
    Modular.to.pushNamed('/profile');
  }
}
```

## 🎯 Tópicos Sugeridos

Para organizar as notificações da paróquia, sugerimos os seguintes tópicos:

- `geral` - Notificações gerais da paróquia
- `eventos` - Eventos e programações
- `missas` - Horários e mudanças de missas
- `avisos` - Avisos importantes
- `pastorais` - Atividades das pastorais
- `catequese` - Informações sobre catequese
- `doações` - Campanhas de doação

## 🔒 Segurança

### 1. **Server Key**
- Mantenha a Server Key do Firebase em segurança
- Use variáveis de ambiente no servidor
- Nunca exponha a chave no código do app

### 2. **Validação**
- Sempre valide os dados recebidos nas notificações
- Implemente verificações de segurança no backend

## 📋 Checklist de Implementação

- [x] Dependência firebase_messaging adicionada
- [x] NotificationService criado
- [x] Permissões Android configuradas
- [x] Configurações iOS adicionadas
- [x] Inicialização no main.dart
- [x] Widget de teste criado
- [x] Documentação criada

## 🔄 Próximos Passos

1. **Integração com Backend**: Criar APIs para gerenciar tokens e enviar notificações
2. **Personalização**: Customizar aparência das notificações
3. **Analytics**: Implementar tracking de abertura de notificações
4. **Segmentação**: Criar grupos de usuários para notificações específicas
5. **Agendamento**: Implementar notificações agendadas

## 🐛 Solução de Problemas

### Token não é gerado
- Verifique se o Firebase está configurado corretamente
- Confirme se o google-services.json (Android) está no local correto
- Para iOS, verifique se o GoogleService-Info.plist está configurado

### Notificações não chegam
- Verifique se as permissões foram concedidas
- Confirme se o app não está em modo "Não perturbe"
- Teste primeiro com o Firebase Console

### App não abre ao tocar na notificação
- Verifique se o handler onMessageOpenedApp está configurado
- Confirme se a navegação está funcionando corretamente

## 📞 Contato

Para dúvidas ou problemas com a implementação, consulte a documentação oficial do Firebase Cloud Messaging: https://firebase.google.com/docs/cloud-messaging
