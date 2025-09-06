# Guia de Formatação Markdown para Textos do App

Este guia explica como usar a formatação Markdown nos textos dinâmicos do Firebase para criar conteúdo rico e bem formatado.

## Formatações Básicas

### Títulos
```markdown
# Título Principal (H1)
## Título Secundário (H2)  
### Subtítulo (H3)
```

### Texto em Negrito e Itálico
```markdown
**Texto em negrito**
*Texto em itálico*
***Texto em negrito e itálico***
```

### Listas

#### Lista com bullet points:
```markdown
- Item 1
- Item 2
- Item 3
```

#### Lista numerada:
```markdown
1. Primeiro item
2. Segundo item
3. Terceiro item
```

### Citações
```markdown
> Esta é uma citação bíblica ou destaque especial
```

### Linha Horizontal (Separador)
```markdown
---
```

### Links
```markdown
[Texto do link](https://www.exemplo.com)
```

## Exemplos Práticos

### Exemplo 1: Texto de Confissões
```markdown
# O Sacramento da Penitência

O **Sacramento da Penitência** é um dos sete sacramentos da Igreja.

## Como se Confessar

### 1. Exame de Consciência
Antes de se confessar, reflita sobre:
- Suas ações
- Seus pensamentos  
- Suas omissões

### 2. Arrependimento
Sinta *verdadeiro pesar* pelos pecados cometidos.

## Horários
- **Sábados**: 16h às 17h30
- **Domingos**: 7h às 8h

---

> *"Recebei o Espírito Santo"*  
> **João 20, 22-23**
```

### Exemplo 2: Texto de Avisos
```markdown
# Avisos Paroquiais

## Missa Especial
**Data**: 15 de setembro  
**Horário**: 19h  
**Local**: Igreja Matriz

### Programação:
1. Abertura com canto
2. Celebração da Missa
3. Bênção final

*Para mais informações, procure a secretaria paroquial.*
```

## Dicas Importantes

1. **Sempre teste**: Após editar no Firebase, verifique como fica no app
2. **Use títulos**: Organize o conteúdo com títulos e subtítulos
3. **Destaque importante**: Use **negrito** para informações importantes
4. **Listas são úteis**: Use listas para organizar informações
5. **Citações bíblicas**: Use `>` para destacar versículos

## Como Editar no Firebase

1. Acesse o Firebase Console
2. Vá em Firestore Database
3. Encontre a coleção (ex: `confissoes`)
4. Abra o documento (ex: `texto_confissoes`)
5. Edite o campo `texto` usando a sintaxe Markdown
6. Salve as alterações

As mudanças aparecerão automaticamente no app na próxima vez que o texto for carregado!
