# Guia Completo para Rodar o Projeto 100% no WSL

Este guia descreve o que precisa ser feito para deixar este projeto pronto para rodar diretamente no Linux dentro do WSL, sem depender de SDK, Flutter, Android Studio ou Node instalados no Windows.

O objetivo aqui e usar apenas:

- Ubuntu no WSL2
- ferramentas Linux instaladas dentro do WSL
- arquivos do projeto armazenados no filesystem Linux
- VS Code conectado ao WSL

## 1. Premissas

Antes de começar, confirme estas condicoes:

- Voce esta usando WSL2
- O projeto foi clonado dentro do Linux, por exemplo em `/home/tfreitas/projetos/saolourenco_flutter`
- Voce vai abrir o projeto no VS Code com a extensao Remote - WSL
- Se quiser interface grafica para navegador, Android Studio ou emulador, o WSLg precisa estar funcionando

Comandos de verificacao dentro do WSL:

```bash
echo "$WSL_DISTRO_NAME"
pwd
uname -a
```

Se quiser confirmar do lado do host que esta em WSL2, rode `wsl --status` no PowerShell do Windows. Isso e apenas verificacao do host, nao faz parte do setup do projeto.

Se o projeto estiver em algo como `/mnt/c/...`, mova para o filesystem Linux antes de continuar. Flutter, Gradle e Node costumam ficar mais lentos e menos confiaveis quando trabalham em disco montado do Windows.

## 2. Atualizar o Ubuntu

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y \
	curl git unzip xz-utils zip libglu1-mesa \
	clang cmake ninja-build pkg-config \
	libgtk-3-dev liblzma-dev jq wget sed
```

Esses pacotes cobrem o basico para Flutter, builds Android, ferramentas auxiliares e execucao grafica no Linux.

## 3. Instalar Java 17 no WSL

Este projeto usa Java 17 no Android Gradle build.

Referencias do projeto:

- `compileSdkVersion 35`
- `targetSdkVersion 35`
- `sourceCompatibility JavaVersion.VERSION_17`
- Gradle `8.7`
- Android Gradle Plugin `8.5.2`

Instalacao:

```bash
sudo apt install -y openjdk-17-jdk
java -version
javac -version
```

Configure o `JAVA_HOME` no shell:

```bash
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
echo "$JAVA_HOME"
```

## 4. Instalar o Flutter SDK no WSL

Nao use o Flutter do Windows. Instale uma copia Linux dentro do WSL.

Exemplo:

```bash
mkdir -p ~/development
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable
echo 'export PATH=$HOME/development/flutter/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
flutter --version
```

Se quiser fixar a versao proxima da usada no projeto, veja primeiro a versao instalada:

```bash
flutter --version
```

Depois rode:

```bash
flutter doctor
```

## 5. Instalar o Chrome no Linux para Web

Para `flutter run -d chrome` ou `flutter build web`, o navegador tambem precisa ser Linux.

Opcao recomendada com Google Chrome Linux:

```bash
wget -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y /tmp/google-chrome.deb
which google-chrome
```

Configure o executavel do Chrome para o Flutter:

```bash
echo 'export CHROME_EXECUTABLE=/usr/bin/google-chrome' >> ~/.bashrc
source ~/.bashrc
echo "$CHROME_EXECUTABLE"
```

Se voce preferir Chromium e sua distribuicao o fornecer sem Snap, ajuste `CHROME_EXECUTABLE` para o caminho correto do binario Linux.

Habilite suporte web no Flutter:

```bash
flutter config --enable-web
flutter devices
```

## 6. Instalar Node.js e Firebase CLI no WSL

O projeto usa deploy web com Firebase Hosting. Instale tudo no Linux:

```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs
node -v
npm -v
```

Instale o Firebase CLI:

```bash
sudo npm install -g firebase-tools
firebase --version
```

Faca login no Firebase pelo Linux:

```bash
firebase login
```

Se preferir ambiente sem navegador local, use:

```bash
firebase login --no-localhost
```

## 7. Instalar FlutterFire CLI no WSL

Este passo e importante porque o clone nao traz o arquivo local `lib/firebase_options_env.dart`.

Instale a CLI:

```bash
dart pub global activate flutterfire_cli
echo 'export PATH=$HOME/.pub-cache/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
flutterfire --version
```

## 8. Instalar Android Studio e Android SDK no WSL

Se voce quer rodar Android sem depender do Windows, o Android SDK tambem precisa estar no Linux.

Antes de seguir, vale separar claramente quando este item e obrigatorio:

- Se voce vai rodar apenas no Chrome e gerar build web, este item 8 pode ser pulado.
- Se voce vai rodar no Android a partir do WSL com `flutter run`, `flutter build apk` ou `flutter build appbundle`, este item passa a ser obrigatorio pelo menos no nivel do Android SDK Linux.
- Se voce usa dispositivo fisico por USB, mas o acesso ao aparelho depende de alguma ponte feita pelo Windows, o seu fluxo deixa de ser 100% WSL. Ainda pode funcionar, mas ja nao atende a meta estrita deste guia.
- Android Studio Linux e opcional. O que e realmente obrigatorio para Android e ter o Android SDK no Linux com os componentes necessarios.

Ha dois caminhos:

- Android Studio Linux rodando via WSLg
- command-line tools do Android SDK instaladas manualmente no WSL

O fluxo mais simples para manutencao costuma ser Android Studio Linux via WSLg.

Resumo pratico para os cenarios mais comuns:

- Web apenas: nao precisa instalar Android Studio nem Android SDK.
- Web + Android em dispositivo fisico iniciado pelo WSL: precisa do Android SDK Linux; Android Studio e opcional.
- Web + Android via emulador no WSLg: precisa do Android SDK Linux e, na pratica, o Android Studio costuma ser o caminho mais simples.

### 8.1. Instalar Android Studio Linux

Esta subsecao e opcional. Use-a se voce quiser a interface grafica do Android Studio, gerenciar SDKs de forma mais simples ou criar/emular AVDs dentro do WSLg.

Baixe a versao Linux no site oficial, extraia no Linux e execute dentro do WSLg.

Exemplo:

```bash
mkdir -p ~/apps ~/Android/Sdk
cd ~/apps
```

Baixe o tarball do Android Studio para Linux e extraia em `~/apps/android-studio`.

Fluxo detalhado sugerido:

1. Acesse a pagina oficial do Android Studio e copie o link do pacote `.tar.gz` para Linux.
2. Ainda dentro de `~/apps`, baixe o arquivo com `wget` ou `curl`.
3. Extraia o conteudo do tarball.
4. Renomeie a pasta extraida para `android-studio` para manter um caminho estavel no shell.
5. Confirme que o executavel principal existe antes de continuar.

Exemplo com `wget`:

```bash
cd ~/apps
wget -O android-studio-linux.tar.gz "COLE_AQUI_A_URL_OFICIAL_DO_TARBALL"
tar -xzf android-studio-linux.tar.gz
rm -rf ~/apps/android-studio
mv android-studio ~/apps/android-studio
ls ~/apps/android-studio/bin/studio.sh
```

Se voce preferir `curl`, o fluxo equivalente fica assim:

```bash
cd ~/apps
curl -L "COLE_AQUI_A_URL_OFICIAL_DO_TARBALL" -o android-studio-linux.tar.gz
tar -xzf android-studio-linux.tar.gz
rm -rf ~/apps/android-studio
mv android-studio ~/apps/android-studio
ls ~/apps/android-studio/bin/studio.sh
```

Se o comando `ls ~/apps/android-studio/bin/studio.sh` retornar o caminho do arquivo, a extracao ficou correta.

Depois adicione ao shell:

```bash
echo 'export ANDROID_STUDIO_HOME=$HOME/apps/android-studio' >> ~/.bashrc
echo 'export ANDROID_SDK_ROOT=$HOME/Android/Sdk' >> ~/.bashrc
echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator' >> ~/.bashrc
source ~/.bashrc
```

Abra o Android Studio:

```bash
$ANDROID_STUDIO_HOME/bin/studio.sh
```

Se `studio.sh` nao estiver no `PATH`, execute pelo caminho completo dentro da pasta `bin` do Android Studio.

### 8.2. Instalar os componentes obrigatorios do Android SDK

Esta subsecao e a parte realmente obrigatoria para Android quando o build ou o run sao feitos no WSL.

Dentro do Android Studio Linux, instale:

- Android SDK Platform 35
- Android SDK Build-Tools 35.x
- Android SDK Platform-Tools
- Android SDK Command-line Tools
- NDK (Side by side) `27.0.12077973`

O `Android Emulator` so e necessario se voce pretende usar emulador no WSLg. Para dispositivo fisico ou apenas build, ele pode ficar de fora.

Esse NDK e obrigatorio porque o projeto foi configurado para compatibilidade com paginas de 16 KB no Android 15+.

Se quiser usar `sdkmanager` diretamente:

```bash
yes | sdkmanager --licenses
sdkmanager \
	"platform-tools" \
	"platforms;android-35" \
	"build-tools;35.0.0" \
	"cmdline-tools;latest" \
	"ndk;27.0.12077973"
```

Se voce tambem quiser emulador no WSLg, inclua `"emulator"` no comando acima.

Depois informe ao Flutter onde esta o Android Studio, se necessario:

```bash
flutter config --android-studio-dir "$ANDROID_STUDIO_HOME"
flutter doctor -v
```

Se voce nao instalou Android Studio e optou apenas pelo SDK por linha de comando, o mais importante e garantir que `ANDROID_SDK_ROOT`, `ANDROID_HOME`, `adb` e `sdkmanager` estejam acessiveis no shell antes de rodar `flutter doctor -v`.

## 9. Abrir o projeto corretamente no WSL

Abra a pasta Linux no VS Code com Remote - WSL.

O caminho correto e algo como:

```bash
cd /home/tfreitas/projetos/saolourenco_flutter
code .
```

Evite abrir a copia pelo caminho UNC do Windows como pasta local. O ideal e o VS Code anexado ao ambiente WSL.

## 10. Criar os arquivos locais que nao vieram no clone

Este repositorio ignora varios arquivos necessarios para execucao:

- `.env`
- `android/key.properties`
- `android/app/google-services.json`
- `lib/firebase_options_env.dart`
- `web/index.html`

Sem isso, o projeto nao fica pronto para rodar completamente.

### 10.1. Criar o `.env`

```bash
cd /home/tfreitas/projetos/saolourenco_flutter
cp .env.example .env
```

Preencha o `.env` com os valores reais. O minimo esperado pelo projeto hoje inclui:

```env
FIREBASE_API_KEY_ANDROID=...
FIREBASE_API_KEY_WEB=...
FIREBASE_PROJECT_ID=...
FIREBASE_MESSAGING_SENDER_ID=...
FIREBASE_APP_ID_ANDROID=...
FIREBASE_APP_ID_WEB=...
FIREBASE_MEASUREMENT_ID=...
FIREBASE_AUTH_DOMAIN=...
FIREBASE_DATABASE_URL=...
FIREBASE_STORAGE_BUCKET=...
ONESIGNAL_APP_ID=...
ONESIGNAL_REST_API_KEY=...
```

Observacao importante:

- o app carrega `.env` logo no inicio do `main.dart`
- o servico de notificacao falha sem `ONESIGNAL_APP_ID`
- se o arquivo existir, mas estiver incompleto, voce vai ter erro em runtime

### 10.2. Criar `android/key.properties`

Esse arquivo e necessario para build de release. Para debug ele pode nao ser exigido, mas vale deixar configurado desde ja.

```bash
cp android/key.properties.template android/key.properties
```

Edite com seus valores reais:

```properties
storePassword=...
keyPassword=...
keyAlias=upload
storeFile=/home/tfreitas/.android/upload-keystore.jks
```

Use caminho Linux para a keystore. Nao use `C:/...`.

### 10.3. Adicionar `android/app/google-services.json`

Baixe o arquivo do Firebase Console referente ao app Android com package id:

```text
com.saolourenco.paroquia_sao_lourenco_v2
```

Salve em:

```bash
android/app/google-services.json
```

### 10.4. Gerar `lib/firebase_options_env.dart`

O projeto importa esse arquivo em `lib/main.dart`, mas ele nao vem versionado.

O jeito mais seguro para um ambiente local completo e gerar o arquivo no proprio WSL com FlutterFire CLI.

No diretorio do projeto:

```bash
flutterfire configure \
	--project=sao-lourenco \
	--platforms=android,web \
	--out=lib/firebase_options_env.dart
```

Se o projeto Firebase usar outro ID, ajuste o valor em `--project`.

Esse passo resolve dois problemas de uma vez:

- cria o arquivo que o app importa
- garante suporte a Android e Web no `DefaultFirebaseOptions`

Observacao:

- existe um template em `lib/firebase_options_env.template.dart`
- esse template atual nao implementa web
- para rodar o projeto por completo no WSL, prefira gerar o arquivo real com `flutterfire configure`

### 10.5. Criar `web/index.html`

O repositorio nao versiona `web/index.html`. Sem ele, `flutter run -d chrome` e `flutter build web` podem falhar.

Crie a partir do template:

```bash
cp web/index_template.html web/index.html
```

Se o seu fluxo web ficar 100% baseado no `firebase_options_env.dart` gerado pelo FlutterFire, voce pode manter o `index.html` igual ao template e apenas garantir que ele exista.

Se quiser continuar usando a inicializacao JavaScript do Firebase no HTML, substitua os placeholders do arquivo com os valores reais antes de buildar.

## 11. Aceitar licencas e validar o ambiente

Agora rode:

```bash
flutter doctor --android-licenses
flutter doctor -v
```

O esperado e que fique tudo verde ou, no maximo, com avisos que voce conscientemente nao vai usar.

Itens que precisam estar OK para este projeto:

- Flutter (Linux)
- Android toolchain no Linux, se voce for usar Android
- Chrome ou Chromium
- Android Studio no Linux, somente se voce quiser interface grafica de gerenciamento do SDK ou emulador

## 12. Baixar as dependencias do projeto

No diretorio raiz:

```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

Esse projeto usa MobX codegen, entao vale garantir os arquivos gerados atualizados antes da primeira execucao.

Se preferir modo watch durante o desenvolvimento:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## 13. Verificacoes antes da primeira execucao

Confirme estes pontos:

```bash
test -f .env && echo OK:.env
test -f android/app/google-services.json && echo OK:google-services.json
test -f lib/firebase_options_env.dart && echo OK:firebase_options_env.dart
test -f web/index.html && echo OK:web/index.html
flutter devices
```

Se algum arquivo obrigatorio nao existir, corrija antes de continuar.

## 14. Rodar Web no WSL

Observacao importante sobre o renderer web:

O Flutter Web tem dois renderers: CanvasKit (padrao) e HTML. O CanvasKit depende de WebGL, que nao funciona corretamente no WSLg porque a GPU e virtualizada por software. O resultado e que nenhuma imagem aparece na tela, nem assets locais nem imagens de rede.

Por isso, no WSL, use sempre `--web-renderer html` nos comandos de run e build web. Esse renderer usa elementos HTML nativos do navegador e funciona sem problemas no WSLg.

Para deploy em producao, onde os usuarios acessam de navegadores reais com GPU, voce pode buildar sem essa flag para usar o CanvasKit, que tem melhor qualidade visual.

### 14.1. Modo desenvolvimento

```bash
flutter run -d chrome --web-renderer html
```

Se o dispositivo Chrome nao aparecer:

```bash
flutter config --enable-web
flutter devices
echo "$CHROME_EXECUTABLE"
```

### 14.2. Build local de producao

```bash
flutter build web --release --web-renderer html
```

### 14.3. Deploy para Firebase Hosting pelo WSL

```bash
./deploy-web.sh
```

Ou manualmente:

```bash
flutter build web --release
firebase deploy --only hosting
```

O script `deploy-web.sh` builda sem `--web-renderer html` por padrao, gerando o build com CanvasKit para producao. Se voce quiser testar o build localmente antes do deploy e precisa que funcione no WSLg, use o comando manual com `--web-renderer html`.

## 15. Rodar Android no WSL

Voce tem quatro cenarios viaveis.

Observacao importante sobre USB:

- Se o dispositivo aparecer direto no `adb devices` dentro do WSL, voce pode trabalhar por USB normalmente.
- Se o aparelho so aparece no Windows e nao aparece no WSL, voce ainda nao tem um fluxo Android realmente resolvido no Linux.
- Em muitos setups, o USB no WSL depende de encaminhamento feito pelo host Windows. Isso pode ser aceitavel no uso diario, mas ja nao e o cenario estrito de independencia total do Windows descrito neste guia.

### 15.1. Dispositivo fisico via USB

Este e o seu fluxo se voce conecta o aparelho por cabo e executa o app a partir do WSL.

No celular Android:

- ative as Opcoes do desenvolvedor
- ative Depuracao USB
- autorize a chave RSA quando o aparelho pedir confirmacao

No WSL:

```bash
adb devices
flutter run -d <device-id>
```

Se o aparelho nao aparecer em `adb devices`, o problema normalmente nao e do Flutter nem do projeto. O ponto a resolver passa a ser como esse dispositivo USB esta sendo exposto ao WSL.

Se voce quer um fluxo estritamente 100% WSL, o ideal continua sendo fazer o Android SDK, o `adb` e o build rodarem no Linux e usar USB apenas se o aparelho realmente estiver visivel no ambiente WSL.

### 15.2. Dispositivo fisico via depuracao Wi-Fi

Esse costuma ser o caminho mais simples para evitar qualquer dependencia do Windows.

No celular Android:

- ative as Opcoes do desenvolvedor
- ative Depuracao sem fio
- emparelhe com ADB

Como localizar os dados de conexao no celular:

1. abra `Configuracoes -> Opcoes do desenvolvedor -> Depuracao sem fio`
2. toque em `Parear dispositivo com codigo de pareamento`
3. anote o `Endereco IP e porta` exibido nessa janela, por exemplo `192.168.1.50:37123`
4. use esse valor no comando `adb pair`; aqui voce tambem vai informar o codigo numerico mostrado na mesma tela
5. volte para a tela principal de `Depuracao sem fio`
6. anote o outro `Endereco IP e porta` mostrado ali, por exemplo `192.168.1.50:43567`
7. use esse segundo valor no comando `adb connect`

Resumo dos valores:

- `IP_DO_CELULAR`: e o IP mostrado na tela de `Depuracao sem fio`
- `PORTA_DE_PAREAMENTO`: e a porta que aparece na janela `Parear dispositivo com codigo de pareamento`
- `PORTA_ADB`: e a porta mostrada na tela principal de `Depuracao sem fio` depois do pareamento

Observacoes importantes:

- a porta de pareamento e a porta ADB normalmente sao diferentes
- essas portas podem mudar quando a depuracao sem fio e reiniciada
- celular e WSL precisam estar na mesma rede

No WSL:

```bash
adb pair IP_DO_CELULAR:PORTA_DE_PAREAMENTO
adb connect IP_DO_CELULAR:PORTA_ADB
adb devices
flutter run -d <device-id>
```

Esse fluxo evita USB passthrough e costuma ser o mais limpo quando a meta e usar somente o ambiente Linux.

### 15.3. Emulador Android dentro do WSLg

E possivel, mas depende bastante da sua maquina e do suporte grafico. Se for usar:

1. crie um AVD no Android Studio Linux
2. inicie o emulador dentro do WSLg
3. confirme com `adb devices`
4. rode `flutter run`

Se o emulador ficar instavel ou muito lento, prefira dispositivo fisico via Wi-Fi.

### 15.4. Apenas buildar Android no WSL

Mesmo sem dispositivo, voce pode deixar o pipeline Android funcional:

```bash
flutter build apk --debug
flutter build apk --release
flutter build appbundle --release
```

Para este projeto, o build de producao tambem deve respeitar a configuracao de 16 KB ja aplicada no Gradle.

## 16. Comandos de bootstrap recomendados

Depois de tudo instalado, o fluxo do dia a dia fica basicamente assim:

```bash
cd /home/tfreitas/projetos/saolourenco_flutter
source ~/.bashrc
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter doctor -v
flutter devices
flutter run -d chrome --web-renderer html
```

Ou para Android:

```bash
cd /home/tfreitas/projetos/saolourenco_flutter
source ~/.bashrc
flutter pub get
dart run build_runner watch --delete-conflicting-outputs
adb devices
flutter run -d <device-id>
```

Se o seu fluxo for apenas web, voce pode ignorar qualquer comando relacionado a `adb`, Android SDK e build APK.

## 17. O que precisa deixar de existir no seu fluxo antigo do Windows

Para dizer que o projeto esta realmente pronto para rodar no WSL sem usar nada do Windows, evite depender de:

- Flutter instalado em `C:`
- Android SDK instalado em `C:`
- Android Studio do Windows
- Node, npm, Firebase CLI ou Java do Windows
- keystore apontando para caminho Windows
- abrir o repositorio em `/mnt/c/...`
- usar `flutter` ou `adb` vindos do PATH do Windows

Comandos uteis para confirmar que tudo vem do Linux:

```bash
which flutter
which dart
which java
which adb
which firebase
which node
```

Todos devem apontar para caminhos Linux dentro do WSL.

## 18. Checklist final

Considere o setup concluido quando todos os itens abaixo estiverem verdadeiros:

- [ ] projeto esta dentro de `/home/...`, nao em `/mnt/c/...`
- [ ] `flutter --version` funciona no WSL
- [ ] `java -version` retorna Java 17
- [ ] `node -v` e `firebase --version` funcionam no WSL
- [ ] `flutter doctor -v` passa sem erro bloqueante
- [ ] `.env` existe e esta preenchido
- [ ] `android/app/google-services.json` existe
- [ ] `lib/firebase_options_env.dart` existe
- [ ] `web/index.html` existe
- [ ] `flutter pub get` conclui com sucesso
- [ ] `dart run build_runner build --delete-conflicting-outputs` conclui com sucesso
- [ ] `flutter run -d chrome --web-renderer html` funciona
- [ ] se voce for usar Android no WSL, o Android SDK Linux esta instalado e o `adb devices` funciona
- [ ] se voce for usar Android no WSL, `flutter build apk --debug` funciona

Se o seu uso for somente web, os dois ultimos itens podem ser desconsiderados.

## 19. Problemas comuns

### `flutter` ou `dart` ainda apontam para o Windows

Corrija o `PATH` no `~/.bashrc` e reabra o shell.

### `flutter doctor` reclama de Android licenses

Rode:

```bash
flutter doctor --android-licenses
```

### `flutter run -d chrome` falha porque nao encontra navegador

Instale Chromium ou Chrome Linux e configure `CHROME_EXECUTABLE`.

### `Firebase.initializeApp` falha

Normalmente significa uma destas causas:

- `lib/firebase_options_env.dart` nao foi gerado
- o arquivo foi gerado sem as plataformas corretas
- `.env` esta incompleto, se voce estiver usando o template baseado em variaveis de ambiente
- `google-services.json` esta ausente ou inconsistente

### Push notifications falham ao subir o app

Confira se `ONESIGNAL_APP_ID` foi preenchido no `.env`.

### Build release Android falha por assinatura

Revise `android/key.properties` e o caminho Linux da keystore.

### `flutter run` ou `flutter build apk` falha com `org.gradle.java.home` apontando para `C:\...`

Esse erro indica que o arquivo `android/gradle.properties` ficou com um caminho local do Windows versionado ou reaproveitado no WSL.

Exemplo de erro:

```text
Value 'C:\Program Files\Java\jdk-17' given for org.gradle.java.home Gradle property is invalid
```

Passos para corrigir:

1. Abra `android/gradle.properties`.
2. Procure a linha `org.gradle.java.home=...`.
3. Se ela apontar para `C:\...`, remova a linha inteira.
4. Garanta que o Java do WSL esteja configurado no shell.

Comandos uteis:

```bash
grep -n "org.gradle.java.home" android/gradle.properties
echo "$JAVA_HOME"
java -version
```

O esperado no WSL e algo como:

```bash
/usr/lib/jvm/java-17-openjdk-amd64
```

Se precisar recriar a configuracao do shell:

```bash
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

Depois valide com:

```bash
cd android
./gradlew -version
```

Se o comando acima mostrar `JVM: 17...` em Linux, o bloqueio de Java foi resolvido.

### `flutter run` falha com `Cannot convert URL 'C:/...upload-keystore.jks' to a file`

Esse erro indica que o arquivo `android/key.properties` esta apontando a keystore para um caminho Windows, o que nao funciona no WSL.

Exemplo de erro:

```text
Cannot convert URL 'C:/src/upload-keystore.jks' to a file
```

Passos para corrigir:

1. Abra `android/key.properties`.
2. Localize a chave `storeFile`.
3. Troque o caminho Windows por um caminho Linux real da sua keystore.

Exemplo correto no WSL:

```properties
storeFile=/home/tfreitas/.android/upload-keystore.jks
```

Cheque tambem o template para nao reintroduzir o erro depois:

```bash
grep -n "storeFile" android/key.properties android/key.properties.template
```

Se a sua keystore ainda nao existir nesse caminho, ajuste para o local Linux correto do seu ambiente.

### `flutter run` falha com erro do Kotlin daemon ou com `Unable to delete directory` dentro de `build/`

Se o build Android comecar a falhar com mensagens como estas:

```text
Could not close incremental caches in .../build/firebase_analytics/kotlin/...
Unable to delete directory '.../build/sqflite/intermediates/javac/...'
```

o problema normalmente e cache local corrompido ou artefato travado por um daemon antigo do Gradle/Kotlin.

Passos de recuperacao usados neste projeto:

1. Pare os daemons do Gradle.
2. Apague os caches locais do projeto.
3. Rebaixe os pacotes do Flutter.
4. Refaça o build Android debug.

Comandos:

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

Se o `flutter build apk --debug` concluir com sucesso, tente novamente:

```bash
flutter run
```

Observacoes importantes:

- esse procedimento limpa apenas caches locais e artefatos gerados
- ele nao remove dependencias do sistema nem altera arquivos fonte do app
- e o caminho mais rapido quando o Android build no WSL para de compilar por travamento de cache

### Imagens nao aparecem no Flutter Web rodando no WSL

Isso acontece porque o CanvasKit (renderer padrao) depende de WebGL, que nao funciona corretamente no WSLg. Use sempre `--web-renderer html` ao rodar ou buildar para teste local no WSL:

```bash
flutter run -d chrome --web-renderer html
```

Esse problema nao afeta o deploy em producao, onde os usuarios acessam de navegadores reais com suporte a GPU.

## 20. Sequencia minima recomendada para este repositorio

Se voce quiser a ordem mais direta possivel, use a sequencia que combina com o seu fluxo.

### 20.1. Sequencia minima para web apenas

1. Instalar dependencias Linux basicas no Ubuntu.
2. Instalar Java 17 no WSL.
3. Instalar Flutter Linux no WSL.
4. Instalar Chrome Linux.
5. Instalar Node 22 e Firebase CLI no WSL.
6. Rodar `flutter doctor -v` e corrigir pendencias.
7. Criar `.env` a partir de `.env.example`.
8. Gerar `lib/firebase_options_env.dart` com `flutterfire configure`.
9. Criar `web/index.html` a partir de `web/index_template.html`.
10. Rodar `flutter clean`.
11. Rodar `flutter pub get`.
12. Rodar `dart run build_runner build --delete-conflicting-outputs`.
13. Validar com `flutter devices`.
14. Rodar `flutter run -d chrome --web-renderer html`.

### 20.2. Passos extras se voce tambem for usar Android no WSL

1. Instalar Android SDK no Linux, com ou sem Android Studio.
2. Instalar `platform-tools`, `platforms;android-35`, `build-tools;35.0.0`, `cmdline-tools;latest` e `ndk;27.0.12077973`.
3. Rodar `flutter doctor -v` e corrigir pendencias do toolchain Android.
4. Confirmar que `adb devices` enxerga o aparelho ou o emulador no WSL.
5. Rodar `flutter build apk --debug` ou `flutter run -d <device-id>`.

### 20.3. Observacao especifica para USB

Se voce usa dispositivo fisico por USB e quer operar tudo a partir do WSL, o teste decisivo e simples:

- se `adb devices` dentro do WSL lista o aparelho, o seu fluxo USB esta funcional no Linux
- se nao lista, ainda existe dependencia de integracao com o host ou falta expor corretamente o dispositivo ao WSL

Seguindo a sequencia correspondente ao seu caso, o projeto fica preparado para desenvolvimento e build a partir do WSL, com ou sem Android, dependendo do fluxo que voce realmente usa.
