# EH-002 - Keystore Android apontando para caminho Windows

- Categoria: Android
- Origem da evidencia: Usuario + Agente Copilot
- Contexto: execucao de `flutter run` para Android no WSL durante a avaliacao de `android/app/build.gradle`.
- Sintoma: `Cannot convert URL 'C:/src/upload-keystore.jks' to a file`.
- Causa raiz: o arquivo `android/key.properties` continha `storeFile=C:/src/upload-keystore.jks`, um caminho Windows invalido no WSL.
- Solucao: trocar `storeFile` para um caminho Linux real da keystore, neste fluxo `storeFile=/home/tfreitas/.android/upload-keystore.jks`, e alinhar tambem `android/key.properties.template`.
- Validacao: o build avancou alem da configuracao do projeto `:app` sem repetir o erro de keystore.
- Arquivos envolvidos: `android/key.properties`, `android/key.properties.template`, `android/app/build.gradle`, `WSL.md`.
- Status: resolvido.

## Recuperacao rapida

```bash
grep -n "storeFile" android/key.properties android/key.properties.template
```

Se `storeFile` apontar para `C:/...`, troque para o caminho Linux real da sua keystore.
