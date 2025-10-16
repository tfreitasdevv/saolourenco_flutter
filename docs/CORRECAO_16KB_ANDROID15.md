# Correção: Compatibilidade com Páginas de 16 KB (Android 15+)

## Problema
O Google Play Console exige que todos os apps destinados ao Android 15 ou versões mais recentes aceitem tamanhos de página de 16 KB de memória. A partir de 30 de maio de 2026, apps que não suportarem esse requisito não poderão receber atualizações.

## Solução Implementada

### 1. Atualização do NDK Version
- **Anterior:** `25.1.8937393`
- **Novo:** `27.0.12077973`

A versão 27.x do NDK inclui suporte completo para páginas de memória de 16 KB.

### 2. Configuração no gradle.properties
Adicionada a propriedade:
```properties
android.bundle.enableUncompressedNativeLibs=false
```

Esta configuração garante que as bibliotecas nativas sejam empacotadas de forma compatível com diferentes tamanhos de página de memória.

### 3. Filtros de ABI no defaultConfig
Adicionada configuração explícita de ABIs suportadas:
```gradle
ndk {
    abiFilters 'armeabi-v7a', 'arm64-v8a', 'x86_64'
}
```

Isso garante que apenas as arquiteturas compatíveis com 16 KB sejam incluídas no build.

## Próximos Passos

### 1. Instalar a NDK 27.x
No Android Studio:
1. Abra **Tools** → **SDK Manager**
2. Vá para a aba **SDK Tools**
3. Marque **Show Package Details**
4. Localize **NDK (Side by side)** e instale a versão **27.0.12077973**

Ou via linha de comando:
```bash
# No diretório do Android SDK
sdkmanager --install "ndk;27.0.12077973"
```

### 2. Limpar o Build Anterior
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### 3. Gerar um Novo Build
```bash
# Para gerar o App Bundle (recomendado para o Google Play)
flutter build appbundle --release

# Ou para gerar APK
flutter build apk --release
```

### 4. Testar a Compatibilidade
Antes de enviar para produção, teste o app em:
- Dispositivos com Android 15
- Emuladores configurados com diferentes tamanhos de página

### 5. Verificar o Bundle
Após gerar o App Bundle, verifique se ele está corretamente configurado:
```bash
# Usando bundletool (se disponível)
bundletool validate --bundle=build/app/outputs/bundle/release/app-release.aab
```

### 6. Fazer Upload no Google Play Console
1. Acesse o Google Play Console
2. Vá para **Produção** → **Criar nova versão**
3. Faça upload do novo App Bundle
4. Verifique se o Console indica compatibilidade com 16 KB
5. Publique a atualização

## Verificação da Compatibilidade

Após o upload, o Google Play Console mostrará:
- ✅ "Aceita tamanhos de página de 16 KB de memória"

Se ainda aparecer como incompatível, verifique:
1. A versão do NDK está corretamente instalada
2. Todas as dependências nativas (plugins) estão atualizadas
3. O build foi feito com as novas configurações

## Dependências a Verificar

As seguintes dependências nativas do projeto devem estar atualizadas:
- ✅ `firebase_core` (3.6.0)
- ✅ `firebase_auth` (5.3.1)
- ✅ `firebase_storage` (12.3.2)
- ✅ `cloud_firestore` (5.4.3)
- ✅ `firebase_analytics` (11.3.3)
- ✅ `onesignal_flutter` (5.2.5)
- ✅ `url_launcher` (6.2.6)

Todas estas versões já são compatíveis com 16 KB.

## Referências
- [Guia Oficial do Google - Compatibilidade com 16 KB](https://developer.android.com/guide/practices/page-sizes)
- [Documentação do NDK](https://developer.android.com/ndk/guides)
- [Flutter e Android 15](https://docs.flutter.dev/deployment/android#reviewing-the-gradle-build-configuration)

## Data de Implementação
15 de outubro de 2025

## Prazo Google Play
30 de maio de 2026 (227 dias restantes)
