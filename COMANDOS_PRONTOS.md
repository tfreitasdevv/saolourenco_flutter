# 📋 Comandos Prontos - Copy & Paste

## 🎯 Use este arquivo para copiar e colar comandos direto no terminal

---

## 🚀 Implementação Completa (Do Zero ao Build)

### Windows (PowerShell ou CMD)

```batch
REM ============================================
REM IMPLEMENTAÇÃO COMPLETA - WINDOWS
REM ============================================

REM Passo 1: Ir para a pasta do projeto
cd c:\Projetos\saolourenco

REM Passo 2: Verificar Flutter
flutter doctor -v

REM Passo 3: Limpar builds anteriores
flutter clean
cd android
call gradlew.bat clean
cd ..

REM Passo 4: Atualizar dependências
flutter pub get

REM Passo 5: Gerar build com o script (RECOMENDADO)
call scripts\build-16kb.bat

REM Passo 5 (ALTERNATIVA): Gerar build manualmente
REM flutter build appbundle --release

REM Passo 6: Verificar o arquivo gerado
dir build\app\outputs\bundle\release\app-release.aab

echo.
echo ============================================
echo Build concluido! Arquivo em:
echo build\app\outputs\bundle\release\app-release.aab
echo ============================================
```

---

## 🔧 Instalação do NDK 27.x

### Opção A: Via sdkmanager (Recomendado)

```batch
REM Windows - Instalar NDK 27.x via sdkmanager
cd %LOCALAPPDATA%\Android\Sdk\cmdline-tools\latest\bin
call sdkmanager.bat "ndk;27.0.12077973"

REM Verificar instalação
dir %LOCALAPPDATA%\Android\Sdk\ndk\27.0.12077973
```

### Linux/macOS

```bash
# Linux/macOS - Instalar NDK 27.x via sdkmanager
cd $ANDROID_SDK_ROOT/cmdline-tools/latest/bin
./sdkmanager "ndk;27.0.12077973"

# Verificar instalação
ls $ANDROID_SDK_ROOT/ndk/27.0.12077973
```

---

## 🧹 Limpeza Completa

### Windows

```batch
REM Limpeza completa do projeto
cd c:\Projetos\saolourenco

REM Limpar Flutter
flutter clean

REM Limpar Gradle
cd android
call gradlew.bat clean
call gradlew.bat cleanBuildCache
cd ..

REM Remover pasta build manualmente (opcional)
REM rmdir /s /q build

REM Atualizar dependências
flutter pub get

echo Limpeza concluida!
```

### Linux/macOS

```bash
# Limpeza completa do projeto
cd ~/projetos/saolourenco

# Limpar Flutter
flutter clean

# Limpar Gradle
cd android
./gradlew clean
./gradlew cleanBuildCache
cd ..

# Remover pasta build manualmente (opcional)
# rm -rf build

# Atualizar dependências
flutter pub get

echo "Limpeza concluída!"
```

---

## 📦 Gerar Build

### Build de Produção (App Bundle)

```batch
REM Windows - Build de produção
cd c:\Projetos\saolourenco
flutter build appbundle --release

REM Ver o arquivo gerado
dir build\app\outputs\bundle\release\app-release.aab
```

```bash
# Linux/macOS - Build de produção
cd ~/projetos/saolourenco
flutter build appbundle --release

# Ver o arquivo gerado
ls -lh build/app/outputs/bundle/release/app-release.aab
```

### Build de Debug (para testar)

```batch
REM Windows - Build de debug
cd c:\Projetos\saolourenco
flutter build apk --debug

REM Instalar em dispositivo conectado
flutter install
```

```bash
# Linux/macOS - Build de debug
cd ~/projetos/saolourenco
flutter build apk --debug

# Instalar em dispositivo conectado
flutter install
```

---

## 🔍 Verificações e Diagnóstico

### Verificar Ambiente Flutter

```bash
# Ver informações completas do Flutter
flutter doctor -v

# Ver apenas resumo
flutter doctor

# Ver versão do Flutter
flutter --version

# Ver canais disponíveis
flutter channel
```

### Verificar NDK Instalados

```batch
REM Windows - Listar NDKs instalados
dir %LOCALAPPDATA%\Android\Sdk\ndk\

REM Verificar NDK 27 específico
dir %LOCALAPPDATA%\Android\Sdk\ndk\27.0.12077973
```

```bash
# Linux/macOS - Listar NDKs instalados
ls $ANDROID_SDK_ROOT/ndk/

# Verificar NDK 27 específico
ls $ANDROID_SDK_ROOT/ndk/27.0.12077973
```

### Verificar Gradle

```batch
REM Windows - Ver versão do Gradle
cd c:\Projetos\saolourenco\android
call gradlew.bat --version
cd ..
```

```bash
# Linux/macOS - Ver versão do Gradle
cd ~/projetos/saolourenco/android
./gradlew --version
cd ..
```

### Verificar Versão do App

```batch
REM Windows - Ver versão do app
cd c:\Projetos\saolourenco
type pubspec.yaml | findstr "version:"
```

```bash
# Linux/macOS - Ver versão do app
cd ~/projetos/saolourenco
grep "version:" pubspec.yaml
```

---

## 🐛 Resolução de Problemas

### Problema: "NDK not found"

```batch
REM Windows - Adicionar NDK ao local.properties
cd c:\Projetos\saolourenco\android
echo ndk.dir=%LOCALAPPDATA%\Android\Sdk\ndk\27.0.12077973 >> local.properties
cd ..

REM Limpar e tentar novamente
flutter clean
flutter pub get
flutter build appbundle --release
```

### Problema: "Gradle build failed"

```batch
REM Windows - Limpeza profunda do Gradle
cd c:\Projetos\saolourenco\android
call gradlew.bat clean
call gradlew.bat cleanBuildCache
cd ..

REM Remover cache do Flutter
flutter clean

REM Remover pubspec.lock e reinstalar
del pubspec.lock
flutter pub get

REM Tentar build novamente
flutter build appbundle --release
```

### Problema: Build muito lento

```batch
REM Windows - Aumentar memória do Gradle
cd c:\Projetos\saolourenco\android

REM Editar gradle.properties (backup primeiro)
copy gradle.properties gradle.properties.backup

REM Adicionar mais memória (abra o arquivo e edite manualmente)
REM org.gradle.jvmargs=-Xmx8g -XX:MaxMetaspaceSize=1g

cd ..
```

### Problema: "Java version mismatch"

```batch
REM Windows - Verificar versão do Java
java -version

REM Deve mostrar: openjdk version "17.x.x"
REM Se não for 17, baixe de: https://adoptium.net/

REM Verificar JAVA_HOME
echo %JAVA_HOME%

REM Configurar JAVA_HOME (se necessário)
REM setx JAVA_HOME "C:\Program Files\Java\jdk-17"
```

---

## 📊 Comandos Úteis do Flutter

### Atualizar Flutter e Dependências

```bash
# Atualizar Flutter para última versão
flutter upgrade

# Atualizar dependências do projeto
flutter pub upgrade

# Verificar dependências desatualizadas
flutter pub outdated
```

### Dispositivos e Emuladores

```bash
# Listar dispositivos conectados
flutter devices

# Listar emuladores disponíveis
flutter emulators

# Criar emulador
flutter emulators --create

# Iniciar emulador específico
flutter emulators --launch <emulator_id>
```

### Análise de Código

```bash
# Analisar código
flutter analyze

# Formatar código
flutter format .

# Executar testes
flutter test
```

---

## 🎯 Sequência Completa Recomendada

### Para Primeira Implementação

```batch
REM ============================================
REM SEQUÊNCIA COMPLETA - PRIMEIRA VEZ
REM ============================================

REM 1. Verificar ambiente
flutter doctor -v

REM 2. Instalar NDK 27.x
cd %LOCALAPPDATA%\Android\Sdk\cmdline-tools\latest\bin
call sdkmanager.bat "ndk;27.0.12077973"
cd c:\Projetos\saolourenco

REM 3. Limpar tudo
flutter clean
cd android
call gradlew.bat clean
cd ..

REM 4. Atualizar dependências
flutter pub get

REM 5. Build de teste (debug)
flutter build apk --debug

REM 6. Se debug OK, gerar produção
call scripts\build-16kb.bat

REM 7. Verificar resultado
dir build\app\outputs\bundle\release\app-release.aab

echo.
echo ============================================
echo PRONTO! Agora faça upload no Google Play Console
echo ============================================
```

### Para Builds Subsequentes

```batch
REM ============================================
REM BUILDS FUTUROS (após primeira implementação)
REM ============================================

cd c:\Projetos\saolourenco

REM Limpar
flutter clean

REM Atualizar
flutter pub get

REM Build
call scripts\build-16kb.bat

REM Verificar
dir build\app\outputs\bundle\release\app-release.aab
```

---

## 📱 Instalação em Dispositivo para Teste

### Via USB (Modo Desenvolvedor)

```bash
# Verificar dispositivo conectado
adb devices

# Instalar versão debug
flutter install --debug

# Ou instalar versão release
flutter install --release

# Ver logs em tempo real
flutter logs
```

### Via Wi-Fi (Sem USB)

```bash
# Conectar dispositivo via ADB Wi-Fi
adb tcpip 5555
adb connect <IP_DO_DISPOSITIVO>:5555

# Verificar conexão
adb devices

# Instalar
flutter install
```

---

## 🚀 Deploy Web (Bonus)

```bash
# Build para web
flutter build web --release

# Deploy no Firebase Hosting
firebase deploy --only hosting

# Ou usar o script
# Windows: deploy-web.bat
# Linux/macOS: ./deploy-web.sh
```

---

## 📋 Checklist Rápido

```bash
# Executar antes de cada build
flutter doctor           # ✅ Tudo OK?
flutter clean           # ✅ Limpou?
flutter pub get         # ✅ Dependências OK?
flutter build appbundle # ✅ Build OK?
dir build\...aab       # ✅ Arquivo gerado?
```

---

## 💡 Dicas Úteis

### Copiar Arquivo AAB para Desktop

```batch
REM Windows - Copiar bundle para desktop
copy build\app\outputs\bundle\release\app-release.aab %USERPROFILE%\Desktop\paroquia-saolourenco-v2.0.4.aab

echo Arquivo copiado para o Desktop!
```

```bash
# Linux/macOS - Copiar bundle para desktop
cp build/app/outputs/bundle/release/app-release.aab ~/Desktop/paroquia-saolourenco-v2.0.4.aab

echo "Arquivo copiado para o Desktop!"
```

### Ver Tamanho do Bundle

```batch
REM Windows
dir build\app\outputs\bundle\release\app-release.aab
```

```bash
# Linux/macOS
ls -lh build/app/outputs/bundle/release/app-release.aab
```

### Abrir Pasta do Bundle no Explorador

```batch
REM Windows - Abrir pasta no Explorer
explorer build\app\outputs\bundle\release\
```

```bash
# Linux - Abrir pasta no gerenciador de arquivos
xdg-open build/app/outputs/bundle/release/

# macOS - Abrir pasta no Finder
open build/app/outputs/bundle/release/
```

---

## ⚡ Script Ultra-Rápido (1 Comando)

### Windows - One-liner Completo

```batch
cd c:\Projetos\saolourenco && flutter clean && cd android && call gradlew.bat clean && cd .. && flutter pub get && flutter build appbundle --release && dir build\app\outputs\bundle\release\app-release.aab
```

### Linux/macOS - One-liner Completo

```bash
cd ~/projetos/saolourenco && flutter clean && cd android && ./gradlew clean && cd .. && flutter pub get && flutter build appbundle --release && ls -lh build/app/outputs/bundle/release/app-release.aab
```

---

**📌 Salve este arquivo nos favoritos do seu navegador!**  
**🔖 Use Ctrl+F para buscar comandos específicos**  
**📋 Copie e cole direto no terminal**

---

**Projeto**: Paróquia São Lourenço  
**Data**: 15/10/2025  
**Versão**: 2.0.4+21
