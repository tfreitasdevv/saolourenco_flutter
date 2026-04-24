## EH-004 - Download do Android Studio retorna 404 no WSL

- Categoria: Infra
- Origem da evidencia: Usuario + Agente Copilot
- Contexto: falha ao seguir a nova secao de instalacao do Android Studio em `docs/migracao-strapi/SETUP_NOVO_COMPUTADOR.md` dentro do fluxo de setup de um novo computador com WSL.
- Sintoma: `wget` para `https://redirector.gvt1.com/edgedl/android/studio/ide-zips/latest/android-studio-2025.1.4.14-linux.tar.gz` seguia os redirects e terminava em `404 Not Found`.
- Causa raiz: a documentacao usava um nome de arquivo versionado e desatualizado (`android-studio-2025.1.4.14-linux.tar.gz`) sob o alias `latest`. A pagina oficial do Android Studio passou a publicar o pacote Linux atual com outro nome e outra versao (`android-studio-panda4-linux.tar.gz` em `2025.3.4.6`).
- Solucao: substituir a URL fixa por um comando que extrai da pagina oficial `https://developer.android.com/studio` o link Linux atual em `https://edgedl.me.gvt1.com/android/studio/ide-zips/.../android-studio-...-linux.tar.gz` antes de executar o `wget`.
- Validacao: o agente confirmou que a URL antiga retornava `404`; depois extraiu dinamicamente o link atual da pagina oficial e validou `HTTP/2 200` para o artefato Linux publicado.
- Arquivos envolvidos: `docs/migracao-strapi/SETUP_NOVO_COMPUTADOR.md`, `CHANGELOG.md`
- Status: resolvido

## Evidencias

- Prompt do usuario: relato completo do erro `404 Not Found` ao executar o `wget` no WSL.
- Saida de terminal: redirects `redirector.gvt1.com -> r5---sn-...gvt1.com -> dl.google.com` terminando em `404 Not Found`.
- Logs adicionais: a pagina oficial `https://developer.android.com/studio` expunha o link Linux atual `https://edgedl.me.gvt1.com/android/studio/ide-zips/2025.3.4.6/android-studio-panda4-linux.tar.gz`.

## Passos de reproducao

1. Abrir o Ubuntu no WSL.
2. Executar o comando `wget` documentado com a URL fixa antiga do Android Studio.
3. Observar que os redirects terminam em `404 Not Found`.

## Recuperacao rapida

```bash
cd /tmp
ANDROID_STUDIO_URL=$(curl -fsSL https://developer.android.com/studio \
  | grep -o 'https://edgedl.me.gvt1.com/android/studio/ide-zips/[0-9.]\+/android-studio-[^" ]*linux\.tar\.gz' \
  | head -n 1)
wget "$ANDROID_STUDIO_URL" -O android-studio.tar.gz
```

## Observacoes

- O nome do arquivo e o codinome do Android Studio mudam com novas releases; evitar URLs hardcoded reduz manutencao reativa.
- A validacao foi feita sem baixar o arquivo inteiro: extracao do link na pagina oficial e confirmacao de `HTTP/2 200` no artefato atual.