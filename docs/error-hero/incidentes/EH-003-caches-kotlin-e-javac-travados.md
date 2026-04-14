# EH-003 - Caches Kotlin e artefatos Java travados no build Android

- Categoria: Build
- Origem da evidencia: Usuario + Agente Copilot
- Contexto: execucao de `flutter run` e validacoes Android no WSL apos os bloqueios iniciais de Java e keystore.
- Sintoma: falhas como `Could not close incremental caches` em `build/firebase_analytics/kotlin/...` e `Unable to delete directory` em `build/sqflite/intermediates/javac/...`.
- Causa raiz: caches locais do projeto e artefatos de compilacao ficaram presos por daemons Gradle/Kotlin ou por estado residual de builds anteriores interrompidos.
- Solucao: parar os daemons do Gradle com `cd android && ./gradlew --stop`, remover `build/`, `android/.gradle` e `.dart_tool`, depois executar `flutter pub get` e `flutter build apk --debug`.
- Validacao: `flutter build apk --debug` concluiu com sucesso e gerou `build/app/outputs/flutter-apk/app-debug.apk`.
- Arquivos envolvidos: `build/`, `android/.gradle`, `.dart_tool`, `WSL.md`.
- Status: resolvido.

## Recuperacao rapida

```bash
cd /home/tfreitas/projetos/saolourenco_flutter/android
./gradlew --stop

rm -rf /home/tfreitas/projetos/saolourenco_flutter/build \
       /home/tfreitas/projetos/saolourenco_flutter/android/.gradle \
       /home/tfreitas/projetos/saolourenco_flutter/.dart_tool

cd /home/tfreitas/projetos/saolourenco_flutter
flutter pub get
flutter build apk --debug
```
