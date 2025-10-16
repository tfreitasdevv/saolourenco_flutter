# ⚡ Guia Rápido - 10 Passos para Build com 16 KB

## 🎯 Para Desenvolvedores VS Code (Sem Android Studio)

---

## ☑️ Passo a Passo Simplificado

### 📍 Passo 1: Abrir Terminal no VS Code
```
Ctrl + ` (ou View → Terminal)
```

---

### 📍 Passo 2: Verificar Flutter
```bash
flutter doctor -v
```
**Esperado**: Tudo OK ou pequenos avisos (ignore avisos do Android Studio)

---

### 📍 Passo 3: Localizar Android SDK
```bash
flutter doctor -v | findstr "Android SDK"
```
**Anote o caminho** (ex: `C:\Users\SeuNome\AppData\Local\Android\Sdk`)

---

### 📍 Passo 4: Instalar NDK 27.x

#### Opção A - Via sdkmanager (Mais Fácil):
```bash
# Navegue até a pasta do SDK
cd %LOCALAPPDATA%\Android\Sdk\cmdline-tools\latest\bin

# Instale o NDK
sdkmanager.bat "ndk;27.0.12077973"
```

#### Opção B - Download Manual:
1. Baixar de: https://github.com/android/ndk/wiki/Unsupported-Downloads
2. Procurar: `android-ndk-r27b-windows.zip`
3. Extrair para: `%LOCALAPPDATA%\Android\Sdk\ndk\27.0.12077973\`

---

### 📍 Passo 5: Verificar Instalação do NDK
```bash
dir %LOCALAPPDATA%\Android\Sdk\ndk\27.0.12077973
```
**Esperado**: Lista de pastas (build, meta, python, sources, etc.)

---

### 📍 Passo 6: Voltar para o Projeto
```bash
cd c:\Projetos\saolourenco
```

---

### 📍 Passo 7: Limpar Builds Anteriores
```bash
flutter clean
cd android
gradlew.bat clean
cd ..
```

---

### 📍 Passo 8: Atualizar Dependências
```bash
flutter pub get
```

---

### 📍 Passo 9: Gerar App Bundle

#### Opção A - Script Automatizado (Recomendado):
```bash
scripts\build-16kb.bat
```

#### Opção B - Manual:
```bash
flutter build appbundle --release
```

**⏱️ Aguarde**: 5-10 minutos  
**📦 Arquivo gerado**: `build\app\outputs\bundle\release\app-release.aab`

---

### 📍 Passo 10: Upload no Google Play

1. Acesse: https://play.google.com/console
2. Seu app → Produção → Criar nova versão
3. Upload: `build\app\outputs\bundle\release\app-release.aab`
4. Verificar: ✅ "Aceita tamanhos de página de 16 KB"
5. Publicar

---

## 🚨 Se Algo der Errado

### ❌ Erro: "NDK not found"
```bash
# Verificar se NDK foi instalado
dir %LOCALAPPDATA%\Android\Sdk\ndk\

# Se vazio, repetir Passo 4
```

### ❌ Erro: "Gradle build failed"
```bash
# Limpar tudo novamente
flutter clean
cd android
gradlew.bat clean
gradlew.bat cleanBuildCache
cd ..

# Tentar novamente
flutter build appbundle --release
```

### ❌ Erro: "sdkmanager not found"
```bash
# Instalar Command Line Tools
# 1. Baixe de: https://developer.android.com/studio#command-line-tools-only
# 2. Extraia para: %LOCALAPPDATA%\Android\Sdk\cmdline-tools\latest\
# 3. Tente novamente o Passo 4
```

---

## 📊 Verificações Importantes

### ✅ Antes do Build
- [ ] NDK 27.x instalado
- [ ] Flutter funcionando (`flutter doctor`)
- [ ] Gradle funcionando (`gradlew.bat --version`)

### ✅ Depois do Build
- [ ] Arquivo .aab gerado
- [ ] Tamanho: 15-40 MB (razoável)
- [ ] Sem erros no console

### ✅ No Google Play Console
- [ ] Upload concluído
- [ ] Processamento finalizado
- [ ] ✅ "Aceita 16 KB" confirmado
- [ ] Publicado

---

## 🎓 Comandos Mais Usados

```bash
# Ver informações do sistema
flutter doctor -v

# Limpar projeto
flutter clean

# Atualizar dependências
flutter pub get

# Build de teste (debug)
flutter build apk --debug

# Build de produção (release)
flutter build appbundle --release

# Ver versão do app
type pubspec.yaml | findstr version

# Listar dispositivos conectados
flutter devices
```

---

## 📞 Links Úteis

- 🔗 NDK Downloads: https://developer.android.com/ndk/downloads
- 🔗 Google Play Console: https://play.google.com/console
- 🔗 Flutter Doctor: `flutter doctor -v`
- 🔗 Documentação Completa: [`docs/GUIA_IMPLEMENTACAO_VSCODE.md`](GUIA_IMPLEMENTACAO_VSCODE.md)

---

## ⏱️ Tempo Estimado Total

- **Primeira vez**: 30-60 minutos
- **Próximas vezes**: 10-15 minutos

---

## 🎯 Objetivo Final

✅ App Bundle gerado  
✅ Upload no Google Play  
✅ Compatibilidade com 16 KB confirmada  
✅ App pronto para Android 15+  

---

**Desenvolvido especialmente para VS Code** 💙  
**Data**: 15/10/2025  
**Projeto**: Paróquia São Lourenço
