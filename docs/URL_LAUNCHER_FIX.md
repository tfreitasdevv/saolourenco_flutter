# Correção dos Links - URL Launcher

## Problema
Links não estavam abrindo em dispositivos físicos Android/iOS, mostrando a mensagem "Não foi possível abrir o link".

## Causa
Faltavam configurações específicas para permitir que o `url_launcher` funcione corretamente em dispositivos físicos, especialmente no Android 11+ (API 30+) que tem restrições mais rígidas.

## Solução Implementada

### 1. Configurações Android (`android/app/src/main/AndroidManifest.xml`)

#### Permissões Adicionadas:
```xml
<uses-permission android:name="android.permission.QUERY_ALL_PACKAGES" />
```

#### Queries para Android 11+ (API 30+):
```xml
<queries>
  <!-- Navegadores web -->
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https" />
  </intent>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="http" />
  </intent>
  <!-- Telefone -->
  <intent>
    <action android:name="android.intent.action.DIAL" />
  </intent>
  <!-- Email -->
  <intent>
    <action android:name="android.intent.action.SENDTO" />
    <data android:scheme="mailto" />
  </intent>
  <!-- Apps específicos comuns -->
  <package android:name="com.facebook.katana" />
  <package android:name="com.instagram.android" />
  <package android:name="com.google.android.youtube" />
  <package android:name="com.whatsapp" />
  <package android:name="com.google.android.apps.maps" />
</queries>
```

### 2. Configurações iOS (`ios/Runner/Info.plist`)

#### Query Schemes Adicionados:
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>https</string>
  <string>http</string>
  <string>tel</string>
  <string>mailto</string>
  <string>sms</string>
  <string>fb</string>
  <string>instagram</string>
  <string>youtube</string>
  <string>whatsapp</string>
  <string>maps</string>
  <string>comgooglemaps</string>
</array>
```

### 3. Classe Utilitária Melhorada (`lib/app/shared/utils/url_launcher_utils.dart`)

#### Funcionalidades:
- ✅ Múltiplas tentativas de lançamento
- ✅ Logs detalhados para debug
- ✅ Tratamento específico por tipo de URL
- ✅ Fallbacks automáticos
- ✅ Mensagens de erro informativas

#### Tipos de URL Suportados:
- 🌐 **URLs Web**: `https://`, `http://`
- 📞 **Telefone**: `tel:`
- 📧 **Email**: `mailto:`
- 💬 **WhatsApp**: URLs específicas
- 🗺️ **Mapas**: Google Maps, Apple Maps

#### Modos de Lançamento:
1. `LaunchMode.externalApplication` (preferido)
2. `LaunchMode.inAppBrowserView` (fallback)
3. `LaunchMode.platformDefault` (último recurso)

## Arquivos Modificados

### Configurações:
- ✅ `android/app/src/main/AndroidManifest.xml`
- ✅ `ios/Runner/Info.plist`

### Código:
- ✅ `lib/app/shared/utils/url_launcher_utils.dart` (criado)
- ✅ `lib/app/modules/eventos/widgets/evento_card.dart`
- ✅ `lib/app/modules/home/home_page.dart`
- ✅ `lib/app/modules/grupo_de_oracao/grupo_de_oracao_page.dart`
- ✅ `lib/app/modules/capelas/capelas_page.dart`

## Validação

### Para testar após a implementação:
1. **Fazer clean do projeto**: `flutter clean`
2. **Reinstalar dependências**: `flutter pub get`
3. **Gerar novo APK/Build**
4. **Testar em dispositivo físico**

### Links para testar:
- 🌐 Site institucional
- 📞 Números de telefone
- 📧 Emails
- 📱 Redes sociais (Instagram, Facebook, YouTube)
- 🗺️ Localização no Google Maps

## Debug

Os logs agora mostram detalhes do processo:
```
🔗 Tentando abrir URL: https://example.com
🔗 URI válida. Scheme: https, Host: example.com
🔗 Verificando se a URL pode ser aberta...
✅ URL pode ser aberta, tentando diferentes modos...
🔗 Tentativa 1: LaunchMode.externalApplication
✅ Link aberto com sucesso no modo: LaunchMode.externalApplication
```

## Compatibilidade

- ✅ **Android 11+ (API 30+)**: Queries específicas
- ✅ **iOS 9+**: Query schemes declarados
- ✅ **Web**: Funcionamento nativo do navegador
- ✅ **Todos os tipos de URL**: Web, telefone, email, apps específicos
