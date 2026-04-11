## Mudanças detalhadas no módulo EAC

### 1. Imports adicionados

**Antes:** Apenas `cloud_firestore`, `material` e `constants`.

**Depois:** Adicionados dois imports:
- url_launcher_utils.dart — utilitário para abrir URLs e WhatsApp
- rich_text_markdown.dart — widget que renderiza texto com formatação Markdown

---

### 2. Método `_extrairSecoes` (novo)

Substituiu a leitura fixa de campos (`snapshot.data!["texto"]`, `snapshot.data!["coordenacao"]`, `snapshot.data!["contato"]`).

**O que faz:**
- Converte o documento Firebase em `Map<String, dynamic>`
- Itera por **todos os campos** do documento
- Filtra apenas campos cujo valor é do tipo `Map` (ignora campos que não são maps)
- Para cada map encontrado, extrai:
  - `titulo` — o nome do campo no Firebase (usado como título da seção)
  - `tipo` — classifica: `'botao'` (se nome começa com `>botao`), `'imagem'` (se começa com `>imagem`), ou `'texto'` (padrão)
  - `texto` — subcampo `texto` do map (string)
  - `link` — subcampo `link` do map (apenas para botões)
  - `url` — subcampo `url` do map (apenas para imagens)
  - `ordem` — subcampo `ordem` do map (int), com fallback para 999
- Ordena todas as seções por `ordem` ascendente (menores primeiro)

---

### 3. Regex `_regexTelefone` e método `_converterTelefonesEmLinks` (novos)

**Regex:** Detecta números de telefone brasileiros nos formatos:
- `(21) 99999-9999`, `21 99999-9999`, `+55 21 99999-9999`
- Com ou sem parênteses, pontos, hífens, espaços

**Método:** Substitui cada número encontrado no texto por um link Markdown no formato `[número](whatsapp:soDigitos)`, onde `soDigitos` contém apenas os dígitos do número.

---

### 4. Build — estrutura do body

**Antes:**
- `SingleChildScrollView` > `FutureBuilder` > leitura fixa de 3 campos string
- Texto exibido com `Text()` simples
- Títulos "Coordenação" e "Contato" hardcoded

**Depois:**
- `SafeArea` > `SingleChildScrollView` > `FutureBuilder` > chamada a `_extrairSecoes`
- Verificação de seções vazias (exibe "Nenhum conteúdo disponível.")
- Loop `for` sobre as seções ordenadas, com 3 tipos de renderização:

#### Tipo `imagem` (campo cujo nome começa com `>imagem`):
- Renderiza `Image.network` com a URL do subcampo `url`
- Inclui `loadingBuilder` (progress indicator) e `errorBuilder` (ícone de erro)

#### Tipo `botao` (campo cujo nome começa com `>botao`):
- Renderiza `ElevatedButton` centralizado
- Texto do botão vem do subcampo `texto`
- Ao clicar, abre a URL do subcampo `link` via `UrlLauncherUtils.abrirUrl`

#### Tipo `texto` (padrão):
- Se o nome do campo for `_`, o título **não é exibido** (apenas o texto)
- Caso contrário, exibe o nome do campo como título em negrito
- Texto renderizado com `RichTextMarkdown` (suporte a Markdown)
- Texto pré-processado por `_converterTelefonesEmLinks` para transformar telefones em links
- `onTapLink` trata dois tipos de link:
  - Links `whatsapp:` → abre WhatsApp via `UrlLauncherUtils.abrirWhatsApp`
  - Outros links → abre URL via `UrlLauncherUtils.abrirUrl`

#### Espaçamento:
- `SizedBox(height: 22)` entre cada seção (exceto após a última)
- `SizedBox(height: 22)` no final da coluna

---

### 5. Variável `isWide`

**Antes:** `MediaQuery.of(context).size.width > 400` repetida em cada widget.

**Depois:** Extraída para `final isWide = ...` no início do build, reutilizada em todo o corpo.

---

### 6. Estrutura esperada no Firebase

**Antes (campos fixos):**
```
documento: conteudo_pagina_pastoral/eac
  texto: "string"
  coordenacao: "string"  
  contato: "string"
```

**Depois (maps dinâmicos):**
```
documento: conteudo_pagina_pastoral/eac
  _: { texto: "descrição geral...", ordem: 1 }
  Coordenação: { texto: "nome do coordenador", ordem: 2 }
  Contato: { texto: "(21) 99999-9999", ordem: 3 }
  >botao1: { texto: "Nosso Facebook", link: "https://...", ordem: 4 }
  >imagem1: { url: "https://...", ordem: 5 }
```

---

### 7. Dependência no `RichTextMarkdown`

Foi adicionado o parâmetro `onTapLink` ao widget rich_text_markdown.dart (callback opcional que é repassado ao `MarkdownBody`). Essa alteração já foi feita e está disponível para todos os módulos.

---

### Resumo para preparar prompts

Para aplicar a cada módulo, as mudanças necessárias são:
1. Adicionar imports de url_launcher_utils.dart e rich_text_markdown.dart
2. Adicionar o método `_extrairSecoes` (idêntico em todos os módulos)
3. Adicionar a regex `_regexTelefone` e o método `_converterTelefonesEmLinks` (idênticos)
4. Substituir o corpo do `FutureBuilder` (leitura fixa de campos → loop dinâmico)
5. Manter o `.doc('nome_do_documento')` correto de cada módulo
6. Manter quaisquer funcionalidades extras do módulo (ex: botão de Facebook no grupo_de_oracao, botão de acesso de membros no musica)