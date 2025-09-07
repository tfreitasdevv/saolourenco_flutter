# 🔐 Configuração de Segurança - Paróquia São Lourenço

## 📋 Configuração Inicial

### 1. Configurar Variáveis de Ambiente

1. **Copie o arquivo de exemplo:**
   ```bash
   cp .env.example .env
   ```

2. **Edite o arquivo `.env`** com os valores reais do seu projeto Firebase:
   ```env
   FIREBASE_API_KEY_ANDROID=sua_chave_api_android_aqui
   FIREBASE_API_KEY_WEB=sua_chave_api_web_aqui
   FIREBASE_PROJECT_ID=sao-lourenco
   FIREBASE_MESSAGING_SENDER_ID=371105984234
   # ... outros valores
   ```

### 2. Configurar Keystore Android

1. **Copie o template:**
   ```bash
   cp android/key.properties.template android/key.properties
   ```

2. **Edite `android/key.properties`** com suas credenciais reais:
   ```properties
   storePassword=sua_senha_da_keystore
   keyPassword=sua_senha_da_chave
   keyAlias=upload
   storeFile=caminho/para/sua/keystore.jks
   ```

### 3. Configurar Firebase

1. **Baixe o `google-services.json`** do console Firebase
2. **Coloque em `android/app/google-services.json`**

### 4. Configurar Web (Desenvolvimento)

1. **Para desenvolvimento local, edite `web/index.html`** e substitua os valores placeholder:
   ```javascript
   var firebaseConfig = {
     apiKey: "sua_chave_api_web_real",
     authDomain: "sao-lourenco.firebaseapp.com",
     // ... outros valores reais
   };
   ```

2. **Para produção, use `web/index_template.html`** com um script de build que substitua as variáveis

### 5. Instalar Dependências

```bash
flutter pub get
```

**Importante**: O arquivo `.env` **NÃO** deve estar nos assets do `pubspec.yaml`. O `flutter_dotenv` carrega diretamente da raiz do projeto.

## ⚠️ IMPORTANTE - Segurança

- **NUNCA** commite arquivos `.env`, `key.properties` ou `google-services.json`
- Estes arquivos já estão no `.gitignore`
- Use apenas os arquivos `.template` e `.example` como referência

## 🚀 Execução

Após configurar todos os arquivos:

```bash
flutter run
```

## 📁 Estrutura de Arquivos Sensíveis

```
projeto/
├── .env                           # ❌ NÃO COMMITAR
├── .env.example                   # ✅ Template para commit
├── android/
│   ├── key.properties            # ❌ NÃO COMMITAR  
│   ├── key.properties.template   # ✅ Template para commit
│   └── app/
│       └── google-services.json  # ❌ NÃO COMMITAR
├── web/
│   ├── index.html                # ❌ NÃO COMMITAR (contém chaves)
│   ├── index_secure.html         # ✅ Versão segura para referência
│   └── index_template.html       # ✅ Template para build
└── lib/
    ├── firebase_options.dart      # ❌ NÃO COMMITAR (arquivo original)
    └── firebase_options_env.dart  # ✅ Versão com variáveis de ambiente
```

## 🔄 Próximos Passos

1. **Regenerar chaves Firebase** no console do Google
2. **Remover arquivos sensíveis do histórico Git** usando `git filter-branch`
3. **Configurar GitHub Secrets** para CI/CD
4. **Implementar build scripts** para substituir variáveis em produção
