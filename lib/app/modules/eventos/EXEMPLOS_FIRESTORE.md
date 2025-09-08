# Exemplo de Documentos para Coleção "eventos"

Este arquivo contém exemplos de como os documentos devem ser estruturados na coleção "eventos" do Firestore Database.

## Estrutura da Coleção

- **Nome da Coleção**: `eventos`
- **Tipo de ID**: Aleatório (gerado automaticamente pelo Firestore)

## Campos Obrigatórios

- **data**: Timestamp
- **titulo**: String (compatível com Markdown)

## Campos Opcionais

- **descricao**: String (compatível com Markdown)
- **imagem**: String (URL do Firebase Storage)
- **link**: String (URL externa)

## Exemplos de Documentos

### Exemplo 1: Evento Completo
```json
{
  "data": "2025-09-15T19:00:00.000Z",
  "titulo": "**Festa de São Lourenço** - Padroeiro da Paróquia",
  "descricao": "Celebração anual em honra ao padroeiro da nossa paróquia. A festividade incluirá:\n\n- **19h00**: Missa Solene\n- **20h30**: Procissão\n- **21h30**: Festividades na praça\n\n*Toda a comunidade está convidada!*",
  "imagem": "https://firebasestorage.googleapis.com/v0/b/seu-projeto/o/eventos%2Ffesta-sao-lourenco.jpg?alt=media",
  "link": "https://paroquia.com.br/festa-sao-lourenco"
}
```

### Exemplo 2: Evento Simples (apenas campos obrigatórios)
```json
{
  "data": "2025-09-22T09:00:00.000Z",
  "titulo": "Missa Dominical das Famílias"
}
```

### Exemplo 3: Evento com Descrição e Link
```json
{
  "data": "2025-09-30T18:00:00.000Z",
  "titulo": "**Terço Mariano** - Outubro Mês de Maria",
  "descricao": "Durante todo o mês de outubro, realizaremos o terço mariano todas as noites.\n\n### Horário\n- **18h00**: Início do terço\n- **18h30**: Bênção final\n\n### Local\n- Igreja Principal\n\n*Venha rezar conosco!*",
  "link": "https://paroquia.com.br/terco-mariano"
}
```

### Exemplo 4: Evento com Imagem
```json
{
  "data": "2025-10-12T14:00:00.000Z",
  "titulo": "Festa das Crianças",
  "descricao": "Uma tarde especial para nossos pequenos com:\n\n- Brincadeiras\n- Lanche especial\n- Apresentações\n- Brindes para todos",
  "imagem": "https://firebasestorage.googleapis.com/v0/b/seu-projeto/o/eventos%2Ffesta-criancas.jpg?alt=media"
}
```

### Exemplo 5: Evento de Formação
```json
{
  "data": "2025-11-05T20:00:00.000Z",
  "titulo": "Curso de **Preparação para o Batismo**",
  "descricao": "Curso destinado aos pais e padrinhos que desejam batizar seus filhos.\n\n### Programa\n1. **Encontro 1**: O significado do Batismo\n2. **Encontro 2**: A vida cristã em família\n3. **Encontro 3**: Responsabilidades dos pais e padrinhos\n\n### Duração\n- 3 encontros de 2 horas cada\n- Aos sábados, das 20h às 22h\n\n### Inscrições\nProcurar a secretaria paroquial",
  "link": "https://paroquia.com.br/inscricoes-batismo"
}
```

## Exemplo de Timestamp para JavaScript

Se você estiver inserindo dados via JavaScript/Node.js:

```javascript
import { Timestamp } from 'firebase/firestore';

const evento = {
  data: Timestamp.fromDate(new Date('2025-09-15T19:00:00')),
  titulo: "**Festa de São Lourenço** - Padroeiro da Paróquia",
  descricao: "Celebração anual em honra ao padroeiro...",
  imagem: "https://firebasestorage.googleapis.com/...",
  link: "https://paroquia.com.br/festa-sao-lourenco"
};
```

## Regras de Segurança do Firestore

Para que o app funcione corretamente, certifique-se de que as regras do Firestore permitam leitura da coleção "eventos":

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permitir leitura pública da coleção eventos
    match /eventos/{documento} {
      allow read: if true;
      // Para escrita, adicione suas regras de autenticação aqui
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
  }
}
```

## Upload de Imagens para o Storage

As imagens devem ser salvas no Firebase Storage em uma estrutura como:

```
gs://seu-bucket/eventos/
├── festa-sao-lourenco.jpg
├── festa-criancas.jpg
├── terco-mariano.jpg
└── ...
```

E as URLs devem seguir o padrão:
```
https://firebasestorage.googleapis.com/v0/b/seu-projeto/o/eventos%2Fnome-da-imagem.jpg?alt=media
```
