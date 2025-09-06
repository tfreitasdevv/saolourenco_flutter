# Configuração CORS para Firebase Storage

## Problema
As imagens do Firebase Storage não carregam no Flutter Web devido a restrições CORS (Cross-Origin Resource Sharing).

## Solução

### 1. Instalar Google Cloud SDK
Se você não tem o Google Cloud SDK instalado:
1. Baixe de: https://cloud.google.com/sdk/docs/install
2. Execute o instalador
3. Reinicie o terminal

### 2. Configurar CORS
Execute os seguintes comandos no terminal:

```bash
# Autenticar com o Google Cloud
gcloud auth login

# Configurar o projeto
gcloud config set project sao-lourenco

# Aplicar configuração CORS
gsutil cors set cors.json gs://sao-lourenco.appspot.com

# Verificar se foi aplicado
gsutil cors get gs://sao-lourenco.appspot.com
```

### 3. Arquivo cors.json
O arquivo `cors.json` já está criado na raiz do projeto com a configuração:

```json
[
  {
    "origin": ["*"],
    "method": ["GET"],
    "maxAgeSeconds": 3600
  }
]
```

### 4. Para Produção
Para produção, recomenda-se restringir as origins:

```json
[
  {
    "origin": ["https://sao-lourenco.web.app", "https://sao-lourenco.firebaseapp.com"],
    "method": ["GET"],
    "maxAgeSeconds": 3600
  }
]
```

## Alternativa pelo Firebase Console

1. Acesse: https://console.firebase.google.com/
2. Selecione o projeto "sao-lourenco"
3. Vá em "Storage" → "Regras"
4. Configure as regras para permitir leitura pública:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

## Status Atual
✅ **Firebase Web configurado** - Projeto está funcionando
✅ **Error handling** - Imagens com fallback quando não carregam
⚠️ **CORS** - Pendente configuração no Google Cloud SDK

## Observações
- O projeto já está funcionando no web
- As imagens que não carregam mostram ícones de fallback
- O Firestore e Auth estão funcionando perfeitamente
- Após configurar o CORS, todas as imagens do Firebase Storage carregarão normalmente
