# EH-001 - Gradle usando `org.gradle.java.home` com caminho Windows no WSL

- Categoria: Build
- Origem da evidencia: Usuario + Agente Copilot
- Contexto: execucao de `flutter run` para Android no WSL ao lancar `lib/main.dart` em dispositivo fisico.
- Sintoma: `Value 'C:\Program Files\Java\jdk-17' given for org.gradle.java.home Gradle property is invalid`.
- Causa raiz: o arquivo `android/gradle.properties` continha `org.gradle.java.home` apontando para um caminho local do Windows, invalido dentro do WSL/Linux.
- Solucao: remover a linha `org.gradle.java.home=...` de `android/gradle.properties` e usar o Java do proprio ambiente WSL por meio de `JAVA_HOME`.
- Validacao: `echo "$JAVA_HOME"` retornou `/usr/lib/jvm/java-17-openjdk-amd64` e `cd android && ./gradlew -version` iniciou com JVM 17 em Linux sem repetir o erro.
- Arquivos envolvidos: `android/gradle.properties`, `WSL.md`.
- Status: resolvido.

## Recuperacao rapida

```bash
grep -n "org.gradle.java.home" android/gradle.properties
echo "$JAVA_HOME"
java -version
cd android && ./gradlew -version
```

Se `android/gradle.properties` estiver com `org.gradle.java.home=C:\...`, remova a linha e use o Java do WSL.
