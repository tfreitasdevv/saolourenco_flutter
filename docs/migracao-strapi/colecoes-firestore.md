# Coleções Firestore — Estrutura Completa

> Referência da estrutura original do Firestore, usada como base para mapear os Content Types do Strapi.

---

## `avisos`

- IDs aleatórios
- Campos: `data` (timestamp), `descrição` (string), `imagem` (URL Storage), `prioridade` (int64), `titulo` (string)

## `avisos_musica`

- IDs aleatórios
- Campos: `data` (timestamp), `descrição` (string), `prioridade` (int64), `titulo` (string)

## `clero`

- IDs = nome da função (ex: "pároco")
- Campos: `data_ordenacao` (string), `historia` (string), `imagem` (URL Storage), `nome` (string)

## `como_ajudar`

- IDs aleatórios
- Campos: `como ajudar` (string), `imagem` (URL Storage), `link` (string), `ordem` (int64), `titulo` (string)

## `confissoes`

- IDs fixos: "primeira_secao", "segunda_secao", "terceira_secao", "quarta_secao"
- **Também possui** documento `texto_confissoes` (usado pelo controller)
- Campos: `texto` (string), `titulo` (string)

## `conteudo_pagina_pastoral`

- IDs = slug da pastoral (ex: "acolitos", "eac", "batismo", "catecumenato_crismal")
- Campos: maps dinâmicos onde o nome do map = título da seção
  - Cada map tem: `texto` (string), `ordem` (int64)
  - Maps `>botao*`: `link` (string), `texto` (string), `ordem` (int64)
  - Maps `>imagem*`: `url` (string), `ordem` (int64)

## `eventos`

- IDs aleatórios
- Campos: `data` (timestamp), `descricao` (string), `imagem` (URL Storage), `link` (string), `titulo` (string)

## `horarios_missas`

- IDs fixos: "domingos", "sabados", "segunda", "terca_a_sexta"
- Campos: `missas` (array de strings), `ordem` (int64), `titulo` (string)

## `imagens_capelas`

- IDs fixos: "conceicao", "guadalupe", "indios", "menino"
- Campos: `imagem` (URL Storage)

## `administradores`

- IDs aleatórios
- Campos: `addedAt` (timestamp), `addedBy` (string), `email` (string), `isInitialAdmin` (boolean), `name` (string)

## `usuarios`

- IDs = Firebase Auth UID
- Campos: `celular` (string), `email` (string), `endereco` (map: bairro, cidade, complemento, estado, logradouro, numero), `nascimento` (timestamp), `nome` (string), `sexo` (string "F"/"M")
