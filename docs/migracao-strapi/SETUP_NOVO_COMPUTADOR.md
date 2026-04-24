# Setup Completo em Novo Computador (WSL)

> Guia passo a passo para clonar e rodar **todo o projeto** (app Flutter + CMS Strapi) do zero em um novo computador com Windows + WSL.
>
> Escrito para quem não domina Linux — todos os comandos estão incluídos.
>
> Tempo estimado: ~1 hora (dependendo da velocidade da internet).

---

## Pré-requisitos no Windows

- **WSL 2** instalado com **Ubuntu 24.04** (ou 22.04+)
- **Git** com acesso aos repositórios (GitHub, etc.)
- **VS Code** com a extensão "WSL" (recomendado)
- **Windows 11** ou **Windows 10 build 19044+** se quiser abrir apps GUI Linux com **WSLg** (necessário para rodar o Android Studio dentro do WSL)

Se o WSL ainda não estiver instalado, abra o **PowerShell como administrador** no Windows e execute:

```powershell
wsl --install -d Ubuntu-24.04
```

Reinicie o computador e configure usuário/senha do Ubuntu na primeira abertura.

---

## Parte 1 — Preparar o ambiente Linux (WSL)

Abra o terminal do Ubuntu (WSL) e execute os comandos abaixo.

### 1.1. Atualizar o sistema

```bash
sudo apt update && sudo apt upgrade -y
```

> `sudo` executa o comando como administrador. Vai pedir sua senha do Ubuntu.

### 1.2. Instalar ferramentas essenciais

```bash
sudo apt install -y git curl unzip xz-utils zip libglu1-mesa clang cmake ninja-build pkg-config libgtk-3-dev
```

> Esses pacotes são necessários para o Flutter (compilação Linux) e ferramentas gerais.

### 1.3. Criar pasta dos projetos

```bash
mkdir -p ~/projetos
```

> `~` é um atalho para `/home/seu_usuario/`. O `-p` cria a pasta sem erro se ela já existir.

---

## Parte 2 — Instalar Node.js (para o Strapi)

O Strapi precisa do Node.js v18 ou superior. Vamos instalar via **nvm** (gerenciador de versões):

```bash
# Baixar e instalar o nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Recarregar o terminal para o nvm funcionar
source ~/.bashrc

# Instalar a versão 22 do Node.js (LTS)
nvm install 22

# Verificar se funcionou (deve mostrar v22.x.x)
node --version
npm --version
```

---

## Parte 3 — Instalar Docker (para o banco de dados PostgreSQL)

O banco de dados roda dentro de um container Docker. Não precisa instalar PostgreSQL diretamente.

```bash
# Adicionar a chave e o repositório oficial do Docker
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker Engine + Docker Compose
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Permitir usar o Docker sem sudo (evita ter que digitar sudo toda vez)
sudo usermod -aG docker $USER
```

> **IMPORTANTE:** Após esse último comando, feche o terminal do WSL e abra novamente para a mudança de grupo ter efeito. No Windows, você pode fechar a janela e abrir o Ubuntu de novo pelo menu Iniciar.

Depois de reabrir o terminal, verifique:

```bash
# Deve mostrar a versão sem erros
docker --version

# Iniciar o serviço do Docker (necessário após cada reinício do WSL)
sudo service docker start

# Testar se funciona (deve baixar e executar uma imagem de teste)
docker run --rm hello-world
```

---

## Parte 4 — Instalar o Flutter

```bash
cd ~

# Baixar o Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable ~/flutter

# Adicionar o Flutter ao PATH (para funcionar de qualquer pasta)
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Verificar se funcionou
flutter --version

# O Flutter vai baixar o que precisar na primeira execução. Isso pode demorar.
# Depois, rode o diagnóstico:
flutter doctor
```

> `flutter doctor` vai mostrar o que falta. Para desenvolvimento Android, você precisará do Android SDK. Para Web, normalmente já funciona de imediato.

### 4.1. Instalar o Android Studio no WSL (opcional, recomendado para Android)

Se voce quiser usar a IDE completa dentro do Linux/WSL, use o Android Studio via **WSLg**.

> **Quando usar esta opcao?**
>
> - Se voce quer abrir projeto Android com interface grafica no proprio WSL
> - Se voce quer usar SDK Manager, Logcat, Device Manager e ferramentas da IDE
> - Se voce quer manter Flutter, Gradle e Android SDK no mesmo ambiente Linux
>
> **Importante:** o Android Studio funciona no WSL com GUI, mas o **emulador Android acelerado por hardware nao e a melhor opcao dentro do WSL**. Para testar no Android, prefira:
>
> - **dispositivo fisico** conectado com depuracao USB
> - **emulador rodando no Windows host**
>
> Motivo: o emulador precisa de aceleracao por virtualizacao, e a propria documentacao do Android alerta que nao se deve executar emulador com VM acceleration dentro de outra VM. Como o WSL ja roda em ambiente virtualizado, esse cenario costuma ser limitado ou instavel.

#### 4.1.1. Garantir suporte a apps GUI no WSL

No **PowerShell do Windows como administrador**, execute:

```powershell
wsl --update
wsl --shutdown
```

Depois, abra novamente o Ubuntu no WSL.

Se quiser confirmar rapidamente que apps GUI estao funcionando no Linux, rode no Ubuntu:

```bash
sudo apt install -y x11-apps
xcalc
```

Se a calculadora abrir, o WSLg esta OK.

#### 4.1.2. Instalar dependencias adicionais

```bash
sudo apt update
sudo apt install -y libgtk2.0-0 libgtk-3-0 libgbm1 libasound2t64 openjdk-17-jdk
```

> O `openjdk-17-jdk` ajuda a manter o ambiente Android/Gradle compativel no WSL. Se o `flutter doctor` reclamar de Java, esta etapa resolve.

#### 4.1.3. Baixar e instalar o Android Studio

```bash
cd /tmp
ANDROID_STUDIO_URL=$(curl -fsSL https://developer.android.com/studio \
  | grep -o 'https://edgedl.me.gvt1.com/android/studio/ide-zips/[0-9.]\+/android-studio-[^" ]*linux\.tar\.gz' \
  | head -n 1)

wget "$ANDROID_STUDIO_URL" -O android-studio.tar.gz

# Instalar em /opt
sudo tar -xzf android-studio.tar.gz -C /opt

# Criar atalho no PATH para abrir pelo terminal
sudo ln -sf /opt/android-studio/bin/studio /usr/local/bin/android-studio
```

> Esse comando busca o link Linux atual diretamente da pagina oficial do Android Studio. Isso evita `404 Not Found` quando o Google muda a versao numerica ou o codinome do pacote.

Para abrir pela primeira vez:

```bash
android-studio
```

No primeiro start:

- escolha `Do not import settings` se for instalacao nova
- conclua o `Setup Wizard`
- mantenha os componentes recomendados do Android SDK

#### 4.1.4. Configurar variaveis de ambiente do Android SDK

Depois que o Setup Wizard terminar, adicione o SDK ao ambiente do WSL:

```bash
echo 'export ANDROID_HOME="$HOME/Android/Sdk"' >> ~/.bashrc
echo 'export ANDROID_SDK_ROOT="$HOME/Android/Sdk"' >> ~/.bashrc
echo 'export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"' >> ~/.bashrc
echo 'export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Verifique:

```bash
flutter doctor -v
sdkmanager --list | head
adb version
java -version
```

> Se o `sdkmanager` ainda nao for encontrado, abra o Android Studio e confirme em **More Actions > SDK Manager** se o pacote **Android SDK Command-line Tools (latest)** esta instalado.

#### 4.1.5. Criar atalho no menu do Windows (opcional)

Se quiser que o Android Studio apareca no menu iniciar do Windows via WSLg, rode o proprio Android Studio e use:

- `Tools > Create Desktop Entry`

### 4.2. Instalar o Android SDK via linha de comando (alternativa leve)

Se for trabalhar com Android:

```bash
# Baixar o Android command-line tools
mkdir -p ~/android-sdk/cmdline-tools
cd ~/android-sdk/cmdline-tools
curl -o tools.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
unzip tools.zip
mv cmdline-tools latest
rm tools.zip

# Adicionar ao PATH
echo 'export ANDROID_HOME="$HOME/android-sdk"' >> ~/.bashrc
echo 'export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Instalar os componentes necessários
yes | sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

> Use esta opcao se voce **nao** quiser instalar o Android Studio. Se instalar o Android Studio pela secao anterior, prefira usar o SDK gerenciado por ele em `$HOME/Android/Sdk` para evitar dois SDKs diferentes no mesmo ambiente.

### 4.3. Instalar o Chrome (para debug Web)

```bash
# Instalar Google Chrome no WSL (necessário para flutter run -d chrome)
cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb
```

---

## Parte 5 — Clonar os repositórios

```bash
cd ~/projetos

# Clonar o app Flutter
git clone <URL_DO_REPOSITORIO_FLUTTER> saolourenco_flutter

# Clonar o CMS Strapi
git clone <URL_DO_REPOSITORIO_CMS> saolourenco-cms
```

> Substitua `<URL_DO_REPOSITORIO_...>` pelas URLs reais dos seus repositórios no GitHub.

### 5.1. Mudar para a branch da migração (Flutter)

```bash
cd ~/projetos/saolourenco_flutter
git checkout preparacao-migracao-strapi
```

---

## Parte 6 — Configurar e rodar o CMS Strapi

### 6.1. Instalar dependências do Strapi

```bash
cd ~/projetos/saolourenco-cms
npm install
```

### 6.2. Criar o arquivo `.env`

```bash
# Copiar o template
cp .env.example .env
```

Agora edite o arquivo `.env` para preencher os valores secretos:

```bash
# Abrir o arquivo no editor de texto do terminal
nano .env
```

> **Usando o nano** (editor de texto no terminal):
>
> - Use as setas do teclado para navegar
> - Digite normalmente para editar
> - **Ctrl + O** depois **Enter** para salvar
> - **Ctrl + X** para sair

Dentro do `.env`, você precisa gerar chaves criptográficas para os campos que dizem `toBeModified`.
Para cada campo, execute este comando em outro terminal e cole o resultado:

```bash
# Gerar uma chave aleatória (execute uma vez para cada campo)
openssl rand -base64 32
```

**Campos que precisam de chaves geradas:**

- `APP_KEYS` — duas chaves separadas por vírgula (gerar 2x)
- `API_TOKEN_SALT` — uma chave
- `ADMIN_JWT_SECRET` — uma chave
- `TRANSFER_TOKEN_SALT` — uma chave
- `JWT_SECRET` — uma chave

**Campos do ImageKit** (obter em https://imagekit.io/dashboard → API Keys):

- `IMAGEKIT_PUBLIC_KEY`
- `IMAGEKIT_PRIVATE_KEY`
- `IMAGEKIT_URL_ENDPOINT`

**Campos do PostgreSQL** — já vêm preenchidos no template (user: `strapi`, senha: `strapi`, db: `strapi`).

### 6.3. Subir o banco de dados

```bash
# Garantir que o Docker está rodando
sudo service docker start

# Subir o container do PostgreSQL
cd ~/projetos/saolourenco-cms
docker compose up -d
```

> O `-d` faz o container rodar em segundo plano. Os dados ficam salvos em um volume Docker e persistem mesmo se o container for parado.

Verificar se está rodando:

```bash
docker ps
```

Deve aparecer um container chamado `strapi-pg` com status `healthy`.

### 6.4. Iniciar o Strapi

```bash
cd ~/projetos/saolourenco-cms
npm run develop
```

> Na primeira vez, o Strapi vai fazer o build e criar as tabelas no banco. Pode demorar alguns minutos.

Quando aparecer a mensagem de sucesso, abra no navegador:

**http://localhost:1337/admin**

Crie sua conta de administrador (email + senha). As permissões públicas de leitura são configuradas automaticamente.

### 6.5. Popular os dados

No painel admin do Strapi, insira os dados manualmente em cada coleção:

- Avisos, Clero, Como Ajudar, Confissões, Eventos, Horários, Imagens de Capelas, Pastorais
- Faça upload das imagens pela Media Library (são enviadas ao ImageKit)

---

## Parte 7 — Configurar e rodar o app Flutter

### 7.1. Instalar dependências do Flutter

```bash
cd ~/projetos/saolourenco_flutter
flutter pub get
```

### 7.2. Configurar o arquivo `.env`

O projeto Flutter já tem um `.env` versionado com as configurações do Firebase e a URL do Strapi.
Verifique se a URL do Strapi aponta para o local correto:

```bash
# Ver o conteúdo do .env
cat .env
```

A linha importante é:

```
STRAPI_URL=http://localhost:1337
```

Se precisar editar:

```bash
nano .env
```

### 7.3. Gerar código MobX (se necessário)

```bash
cd ~/projetos/saolourenco_flutter
dart run build_runner build --delete-conflicting-outputs
```

> Isso regenera os arquivos `.g.dart` do MobX. Só é necessário se os arquivos `.g.dart` não estiverem no Git ou estiverem desatualizados.

### 7.4. Rodar o app

**Para Web (mais rápido para testar):**

```bash
flutter run -d chrome --web-renderer html
```

**Para Android (conecte um dispositivo ou use emulador):**

```bash
flutter run
```

> Para listar dispositivos disponíveis: `flutter devices`

> Se estiver usando Android Studio dentro do WSL, o caminho mais estavel e testar em **dispositivo fisico** ou em **emulador iniciado no Windows host**. O app Flutter pode continuar rodando a partir do WSL normalmente, desde que o `adb devices` enxergue o dispositivo.

---

## Parte 8 — Comandos do dia a dia

### Ao ligar o computador / abrir o WSL

```bash
# 1. Iniciar o Docker (necessário toda vez que reiniciar o WSL)
sudo service docker start

# 2. Subir o banco de dados
cd ~/projetos/saolourenco-cms
docker compose up -d

# 3. Iniciar o Strapi (em um terminal)
npm run develop

# 4. Em outro terminal, rodar o Flutter
cd ~/projetos/saolourenco_flutter
flutter run -d chrome --web-renderer html
```

### Parar tudo

```bash
# Parar o Strapi: Ctrl+C no terminal onde ele está rodando

# Parar o banco de dados (os dados NÃO são perdidos)
cd ~/projetos/saolourenco-cms
docker compose down
```

### Comandos Linux úteis

| Comando             | O que faz                                    |
| ------------------- | -------------------------------------------- |
| `cd pasta`          | Entrar em uma pasta                          |
| `cd ..`             | Voltar uma pasta                             |
| `cd ~`              | Ir para a pasta home (`/home/seu_usuario/`)  |
| `cd ~/projetos`     | Ir direto para a pasta projetos              |
| `ls`                | Listar arquivos e pastas                     |
| `ls -la`            | Listar incluindo arquivos ocultos e detalhes |
| `cat arquivo.txt`   | Mostrar o conteúdo de um arquivo             |
| `nano arquivo.txt`  | Editar um arquivo no terminal                |
| `pwd`               | Mostrar em qual pasta você está              |
| `mkdir pasta`       | Criar uma pasta                              |
| `rm arquivo`        | Deletar um arquivo                           |
| `rm -r pasta`       | Deletar uma pasta e tudo dentro dela         |
| `cp origem destino` | Copiar um arquivo                            |
| `mv origem destino` | Mover ou renomear um arquivo                 |
| `clear`             | Limpar a tela do terminal                    |
| `Ctrl + C`          | Interromper um comando em execução           |
| `Ctrl + L`          | Limpar a tela (atalho)                       |
| `seta ↑`            | Repetir o último comando                     |
| `Tab`               | Autocompletar nomes de pastas/arquivos       |

### Comandos Git frequentes

| Comando                          | O que faz                              |
| -------------------------------- | -------------------------------------- |
| `git status`                     | Ver o que mudou                        |
| `git add -A`                     | Preparar todas as mudanças para commit |
| `git commit -m "mensagem"`       | Fazer o commit                         |
| `git push origin nome-da-branch` | Enviar para o repositório remoto       |
| `git pull`                       | Baixar atualizações do repositório     |
| `git checkout nome-da-branch`    | Mudar de branch                        |
| `git log --oneline -10`          | Ver os últimos 10 commits              |

### Comandos Flutter frequentes

| Comando                                     | O que faz                                  |
| ------------------------------------------- | ------------------------------------------ |
| `flutter pub get`                           | Instalar dependências                      |
| `flutter run -d chrome --web-renderer html` | Rodar no Chrome (Web)                      |
| `flutter run`                               | Rodar no dispositivo conectado             |
| `flutter analyze lib/`                      | Verificar erros no código                  |
| `flutter devices`                           | Listar dispositivos disponíveis            |
| `flutter clean`                             | Limpar cache de build (resolver problemas) |
| `dart run build_runner build`               | Regenerar código MobX                      |

### Comandos Docker frequentes

| Comando                     | O que faz                             |
| --------------------------- | ------------------------------------- |
| `sudo service docker start` | Iniciar o Docker (após reiniciar WSL) |
| `docker compose up -d`      | Subir os containers em segundo plano  |
| `docker compose down`       | Parar os containers (dados persistem) |
| `docker ps`                 | Ver containers rodando                |
| `docker logs strapi-pg`     | Ver logs do banco de dados            |

---

## Versões utilizadas (referência)

| Ferramenta     | Versão               |
| -------------- | -------------------- |
| Flutter        | 3.22.0 (stable)      |
| Dart           | (incluso no Flutter) |
| Android Studio | 2025.3.4+            |
| Node.js        | v22.22.2             |
| Strapi         | v5.42.0              |
| PostgreSQL     | 16 (via Docker)      |
| Java/OpenJDK   | 17                   |
| Docker Engine  | 29.4.0+              |
| Docker Compose | v5.1.2+              |

---

## Solução de problemas comuns

### "Docker daemon is not running"

```bash
sudo service docker start
```

### "Port 1337 already in use"

Outro processo está usando a porta do Strapi. Encerre-o:

```bash
# Descobrir qual processo está na porta 1337
sudo lsof -i :1337

# Matar o processo (substitua PID pelo número mostrado)
kill PID
```

### "flutter: command not found"

O Flutter não está no PATH. Adicione novamente:

```bash
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### "Android Studio nao abre no WSL"

Primeiro, atualize o WSL no Windows:

```powershell
wsl --update
wsl --shutdown
```

Depois, reabra o Ubuntu e teste uma GUI simples:

```bash
sudo apt install -y x11-apps
xcalc
```

Se o `xcalc` nao abrir, o problema esta no WSLg/GUI do Windows, nao no Android Studio.

### "sdkmanager: command not found"

Confirme se o Android SDK Command-line Tools foi instalado e se o PATH esta correto:

```bash
echo $ANDROID_HOME
echo $PATH
ls -la $ANDROID_HOME/cmdline-tools
```

Se estiver usando Android Studio, abra **SDK Manager** e instale **Android SDK Command-line Tools (latest)**.

### Emulador Android lento ou nao inicia no WSL

Prefira uma destas opcoes:

- usar **dispositivo fisico** com USB debugging
- rodar o **emulador no Windows host**

O emulador acelerado depende de virtualizacao/hypervisor e esse fluxo dentro do WSL pode falhar ou ficar muito lento.

### "node: command not found"

O nvm não carregou. Execute:

```bash
source ~/.bashrc
# ou, se não funcionar:
source ~/.nvm/nvm.sh
```

### Build do Flutter com erro de cache

```bash
cd ~/projetos/saolourenco_flutter
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Container PostgreSQL não inicia

```bash
# Ver os logs do container
docker logs strapi-pg

# Se o volume estiver corrompido, recrear (APAGA os dados locais):
docker compose down -v
docker compose up -d
```

> **CUIDADO:** `docker compose down -v` apaga os dados do banco. Você precisará popular os dados novamente pelo painel admin.
