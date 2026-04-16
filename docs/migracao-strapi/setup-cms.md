# Setup do CMS em um Novo Computador (WSL)

> Guia completo para clonar e rodar o projeto `saolourenco-cms` em uma máquina nova com WSL.

---

## Pré-requisitos do sistema

- **WSL 2** com Ubuntu 22.04+ (recomendado: 24.04)
- **Node.js** v22+ (via nvm ou nodesource)
- **Git** configurado com acesso ao repositório

## 1. Instalar Docker Engine no WSL (sem Docker Desktop)

```bash
# Adicionar repositório oficial do Docker
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker Engine + Compose
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Permitir uso sem sudo (requer reinício da sessão WSL)
sudo usermod -aG docker $USER
```

## 2. Clonar o projeto e instalar dependências

```bash
cd ~/projetos  # ou o diretório de sua preferência
git clone <url-do-repositorio> saolourenco-cms
cd saolourenco-cms
npm install
```

## 3. Criar o arquivo `.env`

Copiar o template e preencher os valores:

```bash
cp .env.example .env
```

**Gerar secrets criptográficos** (substituir os valores `toBeModified`):

```bash
# Gerar cada secret individualmente
openssl rand -base64 32  # Executar uma vez para cada campo
```

Preencher no `.env`:

- `APP_KEYS` — duas chaves separadas por vírgula
- `API_TOKEN_SALT`, `ADMIN_JWT_SECRET`, `TRANSFER_TOKEN_SALT`, `JWT_SECRET`, `ENCRYPTION_KEY` — um secret cada

Preencher credenciais do **ImageKit** (obtidas em https://imagekit.io/dashboard):

- `IMAGEKIT_PUBLIC_KEY`
- `IMAGEKIT_PRIVATE_KEY`
- `IMAGEKIT_URL_ENDPOINT`

As configurações do **PostgreSQL local** já vêm preenchidas no template (user: `strapi`, senha: `strapi`, db: `strapi`).

## 4. Subir o banco de dados

```bash
# Iniciar o daemon Docker (necessário após cada reinício do WSL)
sudo service docker start

# Subir o container PostgreSQL 16
cd ~/projetos/saolourenco-cms
docker compose up -d

# Verificar se está rodando e saudável
docker ps
```

Saída esperada: container `strapi-pg` com status `healthy`.

## 5. Iniciar o Strapi

```bash
# Primeiro start — faz build e cria as tabelas automaticamente
npm run develop
```

Acessar `http://localhost:1337/admin` e **criar a conta de administrador**.

As permissões públicas de leitura (find + findOne) para as 9 APIs são criadas automaticamente pelo bootstrap em `src/index.ts`.

## 6. Popular dados

Inserir os registros manualmente pelo painel admin do Strapi:

- Avisos, Clero, Como Ajudar, Confissões, Eventos, Horários, Imagens de Capelas, Pastorais
- Upload de imagens pela Media Library (enviadas automaticamente ao ImageKit)

---

## Comandos do dia a dia

```bash
# Após reiniciar o WSL
sudo service docker start          # Iniciar Docker daemon
docker compose up -d                # Subir PostgreSQL (se não estiver rodando)
npm run develop                     # Iniciar Strapi em modo desenvolvimento

# Parar tudo
# Ctrl+C no terminal do Strapi
docker compose down                 # Parar PostgreSQL (dados persistem no volume)

# Verificar status
docker ps                           # Ver containers rodando
docker compose logs postgres        # Ver logs do PostgreSQL
```

## Observações

- O volume Docker `strapi-pg-data` persiste os dados mesmo após `docker compose down`.
- Para apagar completamente o banco: `docker compose down -v` (remove o volume).
- Os secrets do `.env` são únicos por máquina — não compartilhar entre ambientes.
- A conta admin do Strapi é criada no banco, então cada ambiente terá a sua.

---

## docker-compose.yml (referência)

```yaml
services:
  postgres:
    image: postgres:16-alpine
    container_name: strapi-pg
    restart: unless-stopped
    ports:
      - "5432:5432"
    environment:
      POSTGRES_DB: strapi
      POSTGRES_USER: strapi
      POSTGRES_PASSWORD: strapi
    volumes:
      - strapi-pg-data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U strapi -d strapi"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  strapi-pg-data:
```
