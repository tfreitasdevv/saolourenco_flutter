# 🚀 Guia de Implementação - Compatibilidade 16 KB (VS Code)

## Passo a Passo Completo - Somente VS Code

Este guia foi criado para desenvolvedores que utilizam **apenas o VS Code** (sem Android Studio).

---

## ✅ Pré-requisitos

Antes de começar, verifique se você tem instalado:

```bash
# Verifique o Flutter
flutter --version

# Verifique o Java
java -version

# Verifique o Android SDK (via Flutter)
flutter doctor -v
```

**Requisitos mínimos:**
- ✅ Flutter 3.0+
- ✅ Java JDK 17
- ✅ Android SDK via Flutter
- ✅ Git

---

## 📋 Passo 1: Verificar Configurações Atuais

### 1.1 Verificar se as alterações foram aplicadas

Abra o arquivo `android/gradle.properties` e confirme que contém:
```properties
android.bundle.enableUncompressedNativeLibs=false
```

Abra o arquivo `android/app/build.gradle` e confirme:
- NDK version: `27.0.12077973`
- Filtros de ABI configurados no `defaultConfig`

✅ **Status**: Se você vê essas configurações, o código está correto!

---

## 🔧 Passo 2: Instalar NDK 27.x (SEM Android Studio)

### Opção A: Via sdkmanager (Recomendado)

O `sdkmanager` vem junto com o Android SDK do Flutter.

#### Windows (PowerShell ou CMD):
```bash
# Navegar até o diretório de ferramentas do Android SDK
cd %LOCALAPPDATA%\Android\Sdk\cmdline-tools\latest\bin

# Ou, se estiver usando Flutter SDK:
cd %USERPROFILE%\AppData\Local\Android\Sdk\cmdline-tools\latest\bin

# Instalar NDK 27
sdkmanager.bat "ndk;27.0.12077973"
```

#### Linux/macOS:
```bash
# Encontrar o caminho do Android SDK
flutter doctor -v | grep "Android SDK"

# Navegar até o sdkmanager (substitua pelo seu caminho)
cd $ANDROID_SDK_ROOT/cmdline-tools/latest/bin

# Instalar NDK 27
./sdkmanager "ndk;27.0.12077973"
```

### Opção B: Download Manual

Se o sdkmanager não estiver disponível:

1. **Baixar NDK 27**:
   - Acesse: https://developer.android.com/ndk/downloads
   - Baixe: `android-ndk-r27-windows.zip` (ou versão para seu SO)

2. **Extrair para o local correto**:
   ```bash
   # Windows
   # Extrair para: %LOCALAPPDATA%\Android\Sdk\ndk\27.0.12077973\
   
   # Linux/macOS
   # Extrair para: $ANDROID_SDK_ROOT/ndk/27.0.12077973/
   ```

3. **Verificar instalação**:
   ```bash
   # Windows
   dir %LOCALAPPDATA%\Android\Sdk\ndk\27.0.12077973
   
   # Linux/macOS
   ls $ANDROID_SDK_ROOT/ndk/27.0.12077973
   ```

---

## 🧹 Passo 3: Limpar Builds Anteriores

Execute no **terminal do VS Code** (Ctrl + `):

```bash
# Navegar até a pasta do projeto (se necessário)
cd c:\Projetos\saolourenco

# Limpar build do Android
cd android
gradlew.bat clean
cd ..

# Limpar build do Flutter
flutter clean

# Obter dependências novamente
flutter pub get
```

**⏱️ Tempo estimado**: 1-2 minutos

---

## 🏗️ Passo 4: Gerar Build de Teste

### 4.1 Build de Debug (para testar)

```bash
flutter build apk --debug
```

**O que verificar:**
- ✅ Build concluído sem erros
- ✅ Nenhum aviso sobre NDK incompatível
- ✅ APK gerado em `build/app/outputs/flutter-apk/app-debug.apk`

### 4.2 Se houver erro de NDK não encontrado

**Erro comum:**
```
NDK is not installed
```

**Solução:**
1. Verifique a instalação do NDK no Passo 2
2. Execute `flutter doctor -v` e veja se o NDK é detectado
3. Se necessário, adicione manualmente ao `local.properties`:

```bash
# Abra o arquivo android/local.properties
# Adicione (ajuste o caminho conforme seu SO):
ndk.dir=C:\\Users\\SeuUsuario\\AppData\\Local\\Android\\Sdk\\ndk\\27.0.12077973
```

---

## 📦 Passo 5: Gerar Build de Produção

### 5.1 Usando o Script Automatizado (Recomendado)

```bash
# No terminal do VS Code, na raiz do projeto:
scripts\build-16kb.bat
```

O script fará automaticamente:
1. ✅ Limpar builds anteriores
2. ✅ Verificar configurações
3. ✅ Obter dependências
4. ✅ Gerar App Bundle
5. ✅ Mostrar localização do arquivo

### 5.2 Build Manual

Se preferir fazer manualmente:

```bash
# Limpar
flutter clean
cd android
gradlew.bat clean
cd ..

# Obter dependências
flutter pub get

# Gerar App Bundle
flutter build appbundle --release
```

**Localização do arquivo gerado:**
```
build\app\outputs\bundle\release\app-release.aab
```

**⏱️ Tempo estimado**: 5-10 minutos (dependendo do hardware)

---

## ✅ Passo 6: Verificar o Build

### 6.1 Verificar se o arquivo foi gerado

```bash
# Listar o arquivo
dir build\app\outputs\bundle\release\app-release.aab

# Ver tamanho
dir build\app\outputs\bundle\release\
```

### 6.2 Informações esperadas

- ✅ Arquivo: `app-release.aab`
- ✅ Tamanho: ~15-40 MB (varia conforme o projeto)
- ✅ Data: Hoje

---

## 🧪 Passo 7: Testar (Opcional mas Recomendado)

### 7.1 Testar em Emulador

```bash
# Criar emulador com Android 15 (API 35)
flutter emulators --create --name android15_test

# Iniciar emulador
flutter emulators --launch android15_test

# Instalar e testar
flutter run --release
```

### 7.2 Testar em Dispositivo Físico

```bash
# Conectar dispositivo via USB (modo desenvolvedor ativado)
# Verificar conexão
adb devices

# Instalar
flutter install --release
```

---

## 📤 Passo 8: Upload no Google Play Console

### 8.1 Acessar o Console

1. Acesse: https://play.google.com/console
2. Selecione seu app: **Paróquia São Lourenco**
3. Vá em: **Produção** → **Criar nova versão**

### 8.2 Upload do Bundle

1. Clique em **Upload novo pacote de apps**
2. Selecione o arquivo: `build\app\outputs\bundle\release\app-release.aab`
3. Aguarde o upload (pode levar alguns minutos)

### 8.3 Verificar Compatibilidade

Após o processamento, verifique na seção **Pacote de apps**:

**✅ Deve aparecer:**
```
✓ Aceita tamanhos de página de 16 KB de memória
```

**❌ Se aparecer erro:**
- Verifique se o NDK 27.x foi usado
- Confirme as configurações no gradle.properties
- Gere um novo build seguindo este guia novamente

### 8.4 Publicar

1. **Teste Interno** (recomendado primeiro):
   - Publique em **Teste Interno**
   - Teste com usuários beta
   - Aguarde 24-48h para feedback

2. **Produção**:
   - Depois dos testes, publique em **Produção**
   - Complete as notas de versão
   - Confirme a publicação

---

## 🔍 Passo 9: Verificação Final

### Checklist de Conclusão

- [ ] NDK 27.x instalado e verificado
- [ ] Build limpo executado sem erros
- [ ] App Bundle gerado com sucesso
- [ ] Arquivo .aab tem tamanho razoável (15-40 MB)
- [ ] Upload no Google Play Console concluído
- [ ] Compatibilidade com 16 KB confirmada no Console
- [ ] Publicado em teste interno ou produção

---

## 🆘 Resolução de Problemas

### Problema 1: "NDK not found"

**Solução:**
```bash
# Verificar se o NDK está instalado
dir %LOCALAPPDATA%\Android\Sdk\ndk\

# Se vazio, reinstale seguindo o Passo 2
```

### Problema 2: "Gradle build failed"

**Solução:**
```bash
# Limpar completamente
flutter clean
cd android
gradlew.bat clean
cd ..

# Atualizar dependências
flutter pub get
flutter pub upgrade

# Tentar novamente
flutter build appbundle --release
```

### Problema 3: "Java version mismatch"

**Solução:**
```bash
# Verificar versão do Java
java -version

# Deve ser Java 17
# Se não for, baixe e instale: https://adoptium.net/
```

### Problema 4: Build muito lento

**Solução:**
```bash
# Aumentar memória do Gradle
# Edite android/gradle.properties e ajuste:
org.gradle.jvmargs=-Xmx8g -XX:MaxMetaspaceSize=1g
```

### Problema 5: "Execution failed for task ':app:lintVitalRelease'"

**Solução:**
```gradle
// Adicione em android/app/build.gradle, dentro de android { }
lintOptions {
    checkReleaseBuilds false
    abortOnError false
}
```

---

## 📊 Comandos Úteis de Verificação

### Verificar Flutter Doctor
```bash
flutter doctor -v
```

### Verificar NDK instalados
```bash
# Windows
dir %LOCALAPPDATA%\Android\Sdk\ndk\

# Ver versão específica
dir %LOCALAPPDATA%\Android\Sdk\ndk\27.0.12077973
```

### Verificar Gradle
```bash
cd android
gradlew.bat --version
```

### Verificar versão do app
```bash
# Ver pubspec.yaml
type pubspec.yaml | findstr version
```

### Limpar cache do Gradle
```bash
cd android
gradlew.bat clean
gradlew.bat cleanBuildCache
```

---

## 📝 Notas Importantes

### Sobre o VS Code

- ✅ **Vantagem**: Mais leve e rápido que Android Studio
- ✅ **Suficiente**: Para Flutter, não precisa do Android Studio
- ✅ **Linha de comando**: Você tem controle total via terminal

### Sobre o NDK

- ⚠️ A versão 27.x é **OBRIGATÓRIA** para compatibilidade com 16 KB
- ⚠️ Versões antigas (25.x ou anteriores) **NÃO** funcionam
- ⚠️ O Google Play **rejeitará** builds sem NDK compatível

### Sobre o Prazo

- 📅 **Prazo final**: 30 de maio de 2026
- ⏰ **Dias restantes**: 227 dias
- ✅ **Tempo suficiente**: Sim, mas não procrastine

### Sobre Testes

- 🧪 **Teste Interno**: Sempre recomendado antes da produção
- 📱 **Dispositivos**: Teste em Android 15 se possível
- ✅ **Emuladores**: Também funcionam para validação básica

---

## 🎯 Resumo Rápido

```bash
# 1. Instalar NDK 27
sdkmanager.bat "ndk;27.0.12077973"

# 2. Limpar e preparar
flutter clean && cd android && gradlew.bat clean && cd ..

# 3. Obter dependências
flutter pub get

# 4. Gerar bundle
flutter build appbundle --release

# 5. Upload
# Arquivo: build\app\outputs\bundle\release\app-release.aab
# Para: Google Play Console
```

---

## 📚 Documentação Relacionada

- 📄 [`docs/CORRECAO_16KB_ANDROID15.md`](CORRECAO_16KB_ANDROID15.md) - Detalhes técnicos
- 📋 [`CHECKLIST_16KB.md`](../CHECKLIST_16KB.md) - Lista de verificação
- 🔧 [`scripts/build-16kb.bat`](../scripts/build-16kb.bat) - Script automatizado

---

## ✅ Conclusão

Seguindo este guia, você conseguirá:
1. ✅ Instalar o NDK correto sem Android Studio
2. ✅ Gerar builds compatíveis com 16 KB
3. ✅ Publicar atualizações no Google Play
4. ✅ Manter o app conforme os requisitos até 2026+

**Tempo total estimado**: 30-60 minutos (primeira vez)

---

**Desenvolvido com ❤️ para desenvolvedores VS Code**  
**Data**: 15 de outubro de 2025  
**Projeto**: Paróquia São Lourenço
