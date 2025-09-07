# Instruções de Teste - OneSignal Push Notifications

## 🎯 Objetivo
Testar a implementação básica do OneSignal no app da Paróquia São Lourenço.

## 📋 Pré-requisitos para Teste

### 1. Configuração Básica do OneSignal
1. Acesse [OneSignal](https://onesignal.com/) e crie uma conta gratuita
2. Crie um novo app chamado "Paróquia São Lourenço"
3. Configure para Android (pode usar um projeto Firebase existente)
4. Copie o **App ID** gerado pelo OneSignal

### 2. Configuração do Arquivo .env
Edite o arquivo `.env` na raiz do projeto:
```bash
# Substitua pelo seu App ID real do OneSignal
ONESIGNAL_APP_ID=12345678-1234-1234-1234-123456789012
```

## 🔧 Como Testar

### Teste 1: Verificação de Inicialização

1. **Execute o app:**
   ```bash
   flutter run
   ```

2. **Verifique os logs do console:**
   Procure por estas mensagens:
   ```
   ✅ Firebase inicializado com sucesso
   ✅ Push notifications inicializadas com sucesso
   ✅ OneSignal inicializado com sucesso
   ```

3. **Se houver erros:**
   - ❌ `Erro ao inicializar OneSignal`: Verifique o App ID no .env
   - ❌ `ONESIGNAL_APP_ID não encontrado`: Arquivo .env não está sendo carregado

### Teste 2: Navegação para Configurações

1. **Adicione o widget de teste temporário** em qualquer tela:
   ```dart
   import 'package:paroquia_sao_lourenco/app/shared/widgets/notification_test_widget.dart';
   
   // Adicione na sua tela:
   const NotificationDebugInfo()
   ```

2. **Ou navegue diretamente:**
   - Digite na barra de URL: `/notifications`
   - Ou use: `Modular.to.pushNamed('/notifications')`

### Teste 3: Configurações de Notificação

1. **Na página de configurações:**
   - Clique em "Solicitar Permissão"
   - Aceite a permissão quando solicitada
   - Verifique se o Player ID aparece

2. **Copie o Player ID** exibido (será algo como: `12345678-abcd-1234-efgh-123456789012`)

### Teste 4: Enviando Notificação de Teste

1. **Acesse o dashboard do OneSignal:**
   - Vá para [app.onesignal.com](https://app.onesignal.com)
   - Selecione seu app

2. **Crie uma nova mensagem:**
   - Clique em "New Message" ou "Messages" → "New Push"
   - **Title**: "Teste da Paróquia"
   - **Message**: "Esta é uma notificação de teste!"

3. **Configure o público:**
   - Selecione "Send to Particular Users"
   - Cole o Player ID copiado do app
   - Clique em "Send Message"

4. **Verifique se a notificação chegou:**
   - App em background: deve aparecer na bandeja
   - App em foreground: deve aparecer como popup

### Teste 5: Funcionalidades Avançadas

1. **Teste as tags do usuário:**
   - Clique em "Definir Tags do Usuário"
   - Verifique no console: `🏷️ Tags do usuário definidas`

2. **Teste eventos:**
   - Clique em "Enviar Evento de Teste"
   - Verifique no console: `📊 Evento enviado`

3. **Limpar notificações:**
   - Clique em "Limpar Notificações"
   - Todas as notificações na bandeja devem ser removidas

## 🐛 Troubleshooting

### Problemas Comuns

1. **"Player ID não disponível"**
   ```
   Soluções:
   - Reinicie o app
   - Verifique se a permissão foi concedida
   - Confirme se o App ID está correto
   ```

2. **"Permissão negada"**
   ```
   Soluções:
   - Vá em Configurações do Android > Apps > Seu App > Notificações
   - Habilite as notificações manualmente
   - Reinicie o app
   ```

3. **"Notificação não chega"**
   ```
   Verificações:
   - Player ID está correto?
   - App está em background ou foreground?
   - Dispositivo tem conexão com internet?
   - Teste com "Send to All Users" primeiro
   ```

4. **"OneSignal não inicializa"**
   ```
   Verificações:
   - Arquivo .env existe na raiz do projeto?
   - ONESIGNAL_APP_ID está configurado?
   - App ID é válido (formato UUID)?
   ```

## 📱 Testando em Diferentes Cenários

### Cenário 1: App Fechado
1. Feche completamente o app
2. Envie uma notificação
3. Deve aparecer na bandeja de notificações
4. Ao clicar, deve abrir o app

### Cenário 2: App em Background
1. Minimize o app (não feche)
2. Envie uma notificação
3. Deve aparecer na bandeja
4. Ao clicar, deve trazer o app para frente

### Cenário 3: App em Foreground
1. Mantenha o app aberto e visível
2. Envie uma notificação
3. Deve aparecer um popup/banner no app
4. Verificar logs no console

## 📊 Logs de Debug

Ative logs verbosos adicionando no `main.dart`:
```dart
import 'package:onesignal_flutter/onesignal_flutter.dart';

// No main(), antes de runApp():
OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
```

### Logs Importantes
```
🔔 Permissão para notificações: true
🆔 Player ID: 12345678-abcd-1234-efgh-123456789012
📱 Notificação recebida em foreground: Teste da Paróquia
👆 Notificação clicada: Teste da Paróquia
🏷️ Tags do usuário definidas: {user_type: parishioner, location: sao_lourenco}
📊 Evento enviado: test_notification
```

## ✅ Checklist de Teste

- [ ] OneSignal inicializa sem erros
- [ ] Arquivo .env carregado corretamente
- [ ] Navegação para /notifications funciona
- [ ] Permissão de notificação pode ser solicitada
- [ ] Player ID é gerado e exibido
- [ ] Notificação de teste chega (app fechado)
- [ ] Notificação de teste chega (app em background)
- [ ] Notificação de teste chega (app em foreground)
- [ ] Tags do usuário são definidas
- [ ] Eventos customizados são enviados
- [ ] Limpeza de notificações funciona

## 🚀 Próximos Passos Após Teste

1. **Se tudo funcionar:**
   - Remover widgets de debug
   - Integrar ao sistema de navegação principal
   - Adicionar configurações de usuário

2. **Implementar funcionalidades de produção:**
   - Segmentação por ministérios
   - Notificações automáticas para eventos
   - Deep linking para telas específicas

3. **Configurar ambiente de produção:**
   - App ID de produção no OneSignal
   - Configurar certificados iOS (se necessário)
   - Configurar domínio para web push

---

**💡 Dica:** Comece sempre testando com seu próprio dispositivo antes de expandir para outros usuários!
