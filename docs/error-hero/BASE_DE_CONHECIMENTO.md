# Error Hero

Indice da base de conhecimento de erros do projeto para uso recorrente durante desenvolvimento, build, validacao e manutencao.

## Regra de registro

Toda entrada deve declarar explicitamente a origem da evidencia:

- `Usuario`: erro relatado pelo usuario no prompt, logs, anexos ou capturas.
- `Agente Copilot`: erro observado pelo agente durante comandos, build, teste, validacao ou leitura de saidas.
- `Usuario + Agente Copilot`: erro relatado pelo usuario e tambem observado, reproduzido ou validado pelo agente.

Se a causa raiz nao estiver confirmada, isso deve ser informado claramente no campo correspondente.

## Estrutura da base

- este arquivo funciona como indice principal
- cada incidente deve ganhar um arquivo proprio em `docs/error-hero/incidentes/`
- o indice deve conter apenas resumo, status e link para o detalhe
- novos incidentes podem ser iniciados a partir de [TEMPLATE_INCIDENTE.md](./incidentes/TEMPLATE_INCIDENTE.md)

## Convencao de nomenclatura

- todo novo incidente deve receber um ID sequencial no formato `EH-NNN`
- o proximo registro deve usar o proximo numero livre da base, sem reutilizar IDs antigos
- o titulo do arquivo deve seguir o padrao `EH-NNN-slug-descritivo.md`
- o slug deve ser curto, minusculo, com palavras separadas por hifen
- cada incidente deve declarar uma categoria funcional

## Categorias padrao

- `Android`
- `Web`
- `Firebase`
- `Build`
- `Infra`
- `Dados`
- `UI`
- `Outros`

Se um erro atingir mais de uma area, use a categoria predominante e explique o cruzamento no campo `Contexto`.

## Modelo de entrada nos arquivos de incidente

Template pronto: [TEMPLATE_INCIDENTE.md](./incidentes/TEMPLATE_INCIDENTE.md)

```markdown
## EH-000 - Titulo do erro

- Categoria: Android | Web | Firebase | Build | Infra | Dados | UI | Outros
- Origem da evidencia: Usuario | Agente Copilot | Usuario + Agente Copilot
- Contexto: onde e quando aconteceu
- Sintoma: mensagem principal do erro
- Causa raiz: causa confirmada ou hipotese validada
- Solucao: alteracao aplicada ou procedimento recomendado
- Validacao: como foi confirmado que a correcao funcionou
- Arquivos envolvidos: caminhos relevantes
- Status: resolvido | mitigado | em investigacao
```

## Incidentes registrados

### EH-001 - Gradle usando `org.gradle.java.home` com caminho Windows no WSL

- Categoria: Build
- Origem da evidencia: Usuario + Agente Copilot
- Status: resolvido
- Detalhes: [EH-001-gradle-java-home-windows-no-wsl.md](./incidentes/EH-001-gradle-java-home-windows-no-wsl.md)

### EH-002 - Keystore Android apontando para caminho Windows

- Categoria: Android
- Origem da evidencia: Usuario + Agente Copilot
- Status: resolvido
- Detalhes: [EH-002-keystore-android-caminho-windows.md](./incidentes/EH-002-keystore-android-caminho-windows.md)

### EH-003 - Caches Kotlin e artefatos Java travados no build Android

- Categoria: Build
- Origem da evidencia: Usuario + Agente Copilot
- Status: resolvido
- Detalhes: [EH-003-caches-kotlin-e-javac-travados.md](./incidentes/EH-003-caches-kotlin-e-javac-travados.md)

### EH-004 - Download do Android Studio retorna 404 no WSL

- Categoria: Infra
- Origem da evidencia: Usuario + Agente Copilot
- Status: resolvido
- Detalhes: [EH-004-download-android-studio-404-wsl.md](./incidentes/EH-004-download-android-studio-404-wsl.md)
