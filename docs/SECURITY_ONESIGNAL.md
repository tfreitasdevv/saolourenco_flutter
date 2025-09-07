# 🔒 Segurança - OneSignal Push Notifications

## ⚠️ IMPORTANTE: Configuração de Produção

### 📋 Checklist de Segurança Antes do Deploy

#### ✅ Arquivos Protegidos (.gitignore)
- [x] `.env` - Contém credenciais do OneSignal e Firebase
- [x] `lib/firebase_options.dart` - Chaves do Firebase
- [x] `android/app/google-services.json` - Configurações do Firebase
- [x] `android/key.properties` - Credenciais de assinatura

#### 🔧 Configurações de Produção

1. **OneSignal App ID**
   ```bash
   # NO ARQUIVO .env (NÃO COMMITADO)
   ONESIGNAL_APP_ID=seu_app_id_real_aqui
   ```

2. **Firebase Credentials**
   ```bash
   # NO ARQUIVO .env (NÃO COMMITADO)
   FIREBASE_API_KEY_ANDROID=sua_api_key_real
   FIREBASE_PROJECT_ID=seu_project_id
   ```

#### 🚫 O que NÃO deve ir para o Git

1. **App IDs do OneSignal** - Embora não sejam secretos, é boa prática mantê-los em .env
2. **REST API Keys do OneSignal** - NUNCA commitá-las
3. **Chaves do Firebase** - Manter em arquivos ignorados
4. **Player IDs de usuários** - Dados pessoais

#### 📝 Valores Hardcoded Removidos

- ✅ OneSignal App ID removido do código fonte
- ✅ Logs sanitizados para não expor credenciais
- ✅ Falha segura: erro se App ID não configurado via .env
- ✅ Documentação de segurança implementada

#### 🔄 Processo de Deploy Seguro

1. **Desenvolvimento:**
   ```bash
   # Configure o .env local
   ONESIGNAL_APP_ID=dcccfb35-0de8-4be2-8a69-0f821a747425
   ```

2. **Produção:**
   ```bash
   # Configure o .env de produção
   ONESIGNAL_APP_ID=seu_app_id_de_producao
   ```

#### 💡 Recomendações

1. **Use diferentes App IDs** para desenvolvimento e produção
2. **Rotacione as chaves** periodicamente
3. **Monitor logs** para detectar uso indevido
4. **Remova códigos de debug** antes do deploy

#### 🛡️ Auditoria de Segurança

- [ ] Arquivo .env não está no repositório Git
- [ ] Credenciais não estão hardcoded no código
- [ ] Logs de debug removidos em produção
- [ ] App IDs de produção configurados
- [ ] Documentação de segurança atualizada

---
**📅 Última revisão:** Setembro 2025  
**👤 Responsável:** Equipe de Desenvolvimento  
**🔒 Status:** Configurado e Seguro
