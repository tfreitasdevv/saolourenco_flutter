# Migração Firebase → Strapi v5 — Índice

> **⚠️ INSTRUÇÃO OBRIGATÓRIA PARA AGENTES:**
> Esta documentação (diretório `docs/migracao-strapi/`) é a **única fonte de verdade** para dar continuidade à migração.
> Ao final de cada sessão de trabalho, o agente **DEVE** atualizar os arquivos relevantes com:
>
> 1. Todas as alterações realizadas (arquivos criados, modificados, removidos).
> 2. O estado atualizado de cada módulo (migrado / pendente / em andamento).
> 3. Código-fonte de referência atualizado para refletir os padrões vigentes.
> 4. Quaisquer decisões técnicas tomadas, problemas encontrados e soluções aplicadas.
> 5. Próximos passos claros e acionáveis.
>
> O objetivo é que **qualquer agente consiga retomar o trabalho sem acesso ao contexto da sessão anterior**.
> Esta instrução deve ser preservada em todas as atualizações futuras.

> **Criado em**: 11/04/2026
> **Última atualização**: 15/04/2026 — Fase 3.8 (Login/Auth) reescrito do zero com Strapi JWT

---

## Documentos

| Arquivo                                          | Conteúdo                                                                                           |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------- |
| [README.md](README.md)                           | Este índice, decisões finais e como usar                                                           |
| [arquitetura-flutter.md](arquitetura-flutter.md) | Stack, estrutura de diretórios, padrão de módulo e código Firebase original (referência histórica) |
| [colecoes-firestore.md](colecoes-firestore.md)   | Estrutura completa das 11 coleções Firestore (referência para migração)                            |
| [padroes-strapi.md](padroes-strapi.md)           | Padrões de código já migrado para Strapi + formato da API Strapi v5                                |
| [plano-migracao.md](plano-migracao.md)           | Fases 1–4, tabela de módulos, verificações e pendências                                            |
| [setup-cms.md](setup-cms.md)                     | Setup do Strapi CMS em novo computador (WSL, Docker, PostgreSQL)                                   |
| [progresso.md](progresso.md)                     | Registro detalhado de tudo já concluído (Fases 1, 2, 3 parcial)                                    |

---

## Decisões Finais

| Item                          | Decisão                                                                                |
| ----------------------------- | -------------------------------------------------------------------------------------- |
| Versão Strapi                 | **v5** (mais recente)                                                                  |
| Banco de dados                | **PostgreSQL** (local via Docker + Render.com free tier em produção)                   |
| Hospedagem                    | **Render.com** (free tier: Web Service + PostgreSQL)                                   |
| Ambiente de dev               | **WSL** (Windows Subsystem for Linux) — projetos clonados no filesystem Linux          |
| Imagens                       | **ImageKit** (free tier: 20GB) via `strapi-plugin-imagekit`                            |
| Migração                      | **Gradual** — módulo a módulo, Firebase fica ativo durante transição                   |
| Dados em tempo real           | **Não** — busca sob demanda (sem streams/real-time)                                    |
| Gerenciamento de conteúdo     | **Somente painel Strapi** (app é read-only)                                            |
| **Autenticação**              | **Implementar do zero com Strapi** — NÃO herdar do Firebase Auth (ver detalhes abaixo) |
| Coleção `musica_mes_corrente` | **Não migrar** neste momento                                                           |

### Decisão sobre autenticação (15/04/2026)

A autenticação será **implementada do zero** utilizando o sistema Users & Permissions do Strapi v5. **Não haverá herança, adaptação ou reaproveitamento** do código Firebase Auth existente (`auth_repository.dart`, `local_user.dart`).

**Motivação:**

- O código Firebase Auth atual está fortemente acoplado a `FirebaseAuth` e `Firestore` — adaptar seria mais trabalhoso e frágil do que reimplementar.
- O Strapi v5 oferece autenticação JWT nativa com endpoints prontos (`/api/auth/local`, `/api/auth/local/register`, `/api/users/me`), dispensando lógica customizada complexa.
- A `StrapiAuthService` já foi criada na Fase 2 com todos os métodos necessários (`login`, `register`, `logout`, `getMe`, `updateProfile`).
- Começar do zero permite modelar o estado de autenticação (`LocalUser`) de forma limpa, sem referências a `User` do Firebase, e com arquitetura pensada desde o início para JWT.

**Impacto na Fase 3.8 (detalhes em [plano-migracao.md](plano-migracao.md)):**

- `auth_repository.dart` → será **reescrito do zero**, não adaptado.
- `local_user.dart` → será **reescrito do zero** — sem `User? firebaseUser`, estado baseado em JWT e dados do Strapi.
- `login_page.dart`, `signup_page.dart`, `profile_page.dart` → serão reescritos para usar as novas interfaces.
- `recuperarSenha()` → implementar via endpoint do Strapi (plugin users-permissions com configuração de email, ou endpoint customizado).
- Todo o fluxo de login/registro/perfil será validado nas 3 plataformas (Android, iOS, Web).

---

## Como usar esta documentação na nova sessão

Para continuar a migração:

> "Leia os arquivos em `docs/migracao-strapi/` e vamos continuar a migração."

Para uma fase específica:

> "Leia `docs/migracao-strapi/plano-migracao.md` e `docs/migracao-strapi/progresso.md` e vamos implementar o passo 3.8 (Login/Auth do zero)."

Para consultar padrões já aplicados:

> "Leia `docs/migracao-strapi/padroes-strapi.md` e aplique o mesmo padrão no módulo X."

---

## Para iniciar o ambiente de desenvolvimento (WSL)

```bash
sudo service docker start
cd /home/tfreitas/projetos/saolourenco-cms && sudo docker compose up -d && npm run develop
```
