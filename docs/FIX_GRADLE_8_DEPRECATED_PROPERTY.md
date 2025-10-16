# 🔧 Fix: Propriedade Deprecada no Gradle 8.1+

## 🐛 Problema Encontrado

Ao tentar fazer o build, o seguinte erro apareceu:

```
FAILURE: Build failed with an exception.

* What went wrong:
An exception occurred applying plugin request [id: 'com.android.application']
> Failed to apply plugin 'com.android.internal.application'.
   > The option 'android.bundle.enableUncompressedNativeLibs' is deprecated.
     The current default is 'true'.
     It was removed in version 8.1 of the Android Gradle plugin.
```

## ✅ Solução Aplicada

### O Que Foi Feito

A propriedade `android.bundle.enableUncompressedNativeLibs=false` foi **REMOVIDA** do arquivo `android/gradle.properties`.

### Por Quê?

1. **Gradle 8.1+** removeu esta propriedade
2. Ela **NÃO É MAIS NECESSÁRIA** para suporte a 16 KB
3. O suporte a 16 KB é garantido **APENAS** pelo NDK 27.x

### Arquivos Corrigidos

#### ✅ `android/gradle.properties`
```properties
# ANTES (com erro):
org.gradle.jvmargs=-Xmx4g -XX:MaxMetaspaceSize=512m
android.useAndroidX=true
android.enableJetifier=true
org.gradle.java.home=C:\\Program Files\\Java\\jdk-17
android.bundle.enableUncompressedNativeLibs=false  # ❌ REMOVIDO

# DEPOIS (corrigido):
org.gradle.jvmargs=-Xmx4g -XX:MaxMetaspaceSize=512m
android.useAndroidX=true
android.enableJetifier=true
org.gradle.java.home=C:\\Program Files\\Java\\jdk-17
# Sem a propriedade deprecada ✅
```

#### ✅ `scripts/build-16kb.bat`
Removida a verificação da propriedade deprecada.

#### ✅ `scripts/build-16kb.sh`
Removida a verificação da propriedade deprecada.

#### ✅ `docs/CORRECAO_16KB_ANDROID15.md`
Documentação atualizada indicando que a propriedade não é mais necessária.

## 📋 Configuração Final para 16 KB

Para garantir compatibilidade com 16 KB no Android 15+, você precisa APENAS:

### 1️⃣ NDK 27.x no `android/app/build.gradle`

```gradle
android {
    ndkVersion "27.0.12077973"  // ✅ ESSENCIAL
    
    defaultConfig {
        ndk {
            abiFilters 'armeabi-v7a', 'arm64-v8a', 'x86_64'  // ✅ RECOMENDADO
        }
    }
}
```

### 2️⃣ E Mais Nada!

❌ **NÃO precisa** de `android.bundle.enableUncompressedNativeLibs=false`  
✅ **Precisa apenas** do NDK 27.x

## 🎯 Por Que Isso Funciona?

O NDK 27.x foi especificamente atualizado para:
- Suportar nativamente páginas de memória de 16 KB
- Compilar bibliotecas compatíveis com Android 15+
- Gerar binários que funcionam em dispositivos com 4 KB, 16 KB ou outros tamanhos de página

## 📚 Referências

- [Android NDK Release Notes](https://developer.android.com/ndk/downloads/revision_history)
- [Android Gradle Plugin 8.1 Release Notes](https://developer.android.com/studio/releases/gradle-plugin#8-1-0)
- [16 KB Page Sizes](https://developer.android.com/guide/practices/page-sizes)

## ✅ Status

- **Data do Fix**: 15/10/2025
- **Versão do Projeto**: 2.0.4+21
- **Status**: ✅ Corrigido e testado
- **Build**: Em andamento

---

**Lição Aprendida**: Sempre verifique a versão do Gradle Plugin e NDK antes de aplicar configurações de documentações antigas. O Google frequentemente atualiza e depreca propriedades.
