# Módulo Confissões - Versão com 4 Seções

Este módulo implementa a funcionalidade de confissões da aplicação da Paróquia São Lourenço, com **4 seções dinâmicas** exibidas diretamente na tela.

# Módulo Confissões - Versão com 4 Seções e Blur Configurável

Este módulo implementa a funcionalidade de confissões da aplicação da Paróquia São Lourenço, com **4 seções dinâmicas** exibidas diretamente na tela e **blur configurável** no fundo.

## 🎨 Nova Estrutura Visual

A página agora exibe **4 seções sequenciais** sem cards, diretamente sobre o plano de fundo com blur:

1. **Primeira Seção**: O que é o Sacramento da Penitência
2. **Segunda Seção**: Como se Confessar (passo a passo)
3. **Terceira Seção**: Horários e Local das Confissões  
4. **Quarta Seção**: Palavra Bíblica e Orientações Finais

## 🔧 Configuração de Blur

### Constantes de Configuração:

No arquivo `lib/app/shared/constants/constants.dart`:

```dart
/// Intensidade do blur para a página de Confissões
/// Valores recomendados: 0.0 (sem blur) a 5.0 (blur intenso)
const double confissoesBlurIntensity = 2.5;

/// Opacidade do overlay escuro sobre o fundo com blur
/// Valores: 0.0 (transparente) a 1.0 (opaco)
const double confissoesOverlayOpacity = 0.15;
```

### Como Personalizar:

#### Intensidade do Blur (`confissoesBlurIntensity`):
- **0.0**: Sem blur (imagem nítida)
- **1.0**: Blur suave
- **2.5**: Blur médio (padrão recomendado)
- **4.0**: Blur intenso
- **5.0**: Blur muito intenso

#### Opacidade do Overlay (`confissoesOverlayOpacity`):
- **0.0**: Sem escurecimento
- **0.1**: Escurecimento muito sutil
- **0.15**: Escurecimento suave (padrão)
- **0.3**: Escurecimento médio
- **0.5**: Escurecimento forte

### Efeito Visual:
- **Blur**: Desfoca a imagem de fundo para melhor legibilidade
- **Overlay**: Adiciona uma camada escura semitransparente
- **Resultado**: Texto branco com excelente contraste e legibilidade

## 📝 Estrutura dos Dados no Firebase

### Coleção: `confissoes`

Cada documento tem dois campos obrigatórios:

```
confissoes/
├── primeira_secao
│   ├── titulo (string)
│   └── texto (string - Markdown)
├── segunda_secao
│   ├── titulo (string)
│   └── texto (string - Markdown)
├── terceira_secao
│   ├── titulo (string)
│   └── texto (string - Markdown)
└── quarta_secao
    ├── titulo (string)
    └── texto (string - Markdown)
```

## 🎨 Estilos Aplicados

### Títulos das Seções:
- **Fonte**: CinzelDecorative
- **Tamanho**: 16px
- **Peso**: 500 (Medium)
- **Cor**: Branco

### Texto das Seções:
- **Fonte**: Raleway Regular
- **Formatação**: Markdown completo
- **Cor**: Branco
- **Funcionalidades**: Negrito, itálico, listas, citações, etc.

## 🔧 Funcionalidades

- ✅ **4 seções independentes** carregadas do Firebase
- ✅ **Formatação Markdown** em texto branco
- ✅ **Loading individual** para cada seção
- ✅ **Tratamento de erros** por seção
- ✅ **Mensagens informativas** para seções não encontradas
- ✅ **Layout responsivo** sem cards
- ✅ **Fundo transparente** (apenas texto sobre imagem)

## 📱 Como Editar o Conteúdo

### 1. Acessar Firebase Console
1. Vá em Firestore Database
2. Abra a coleção `confissoes`
3. Selecione um dos documentos:
   - `primeira_secao`
   - `segunda_secao` 
   - `terceira_secao`
   - `quarta_secao`

### 2. Editar Campos
- **titulo**: Texto simples para o título da seção
- **texto**: Conteúdo em formato Markdown

### 3. Exemplo de Edição:

```markdown
**Documento**: terceira_secao

**Campo titulo**: 
Horários de Confissão

**Campo texto**:
**Na Igreja Matriz São Lourenço:**

• **Sábados**: 16h às 17h30
• **Domingos**: 7h às 8h e 17h às 18h  
• **Mediante agendamento** com o pároco

*Para casos urgentes, entre em contato com a paróquia.*
```

## 🚀 Script de População Inicial

Para criar os documentos iniciais no Firebase:

```dart
// Execute o script em: lib/scripts/criar_confissoes_firebase.dart
await criarDocumentosConfissoes();
```

O script criará automaticamente os 4 documentos com conteúdo de exemplo.

## 🔄 Estados da Interface

### Loading State:
- Indicador de carregamento pequeno
- Texto "Carregando seção..."
- Cor branca semitransparente

### Error State:
- Título em vermelho claro
- Descrição do erro
- ID do documento que falhou

### Not Found State:
- Título em laranja claro  
- Mensagem informando documento não encontrado
- Orientação sobre o ID esperado

## 💡 Vantagens da Nova Estrutura

1. **Mais Flexível**: Cada seção pode ser editada independentemente
2. **Melhor UX**: Carregamento progressivo das seções
3. **Visual Limpo**: Texto direto sobre fundo, sem cards
4. **Manutenível**: Fácil adicionar/remover/reordenar seções
5. **Responsivo**: Adapta-se a diferentes tamanhos de tela
6. **Acessível**: Texto selecionável e bom contraste

## 📖 Formatação Markdown Suportada

- **Negrito**: `**texto**`
- *Itálico*: `*texto*`
- ### Subtítulos: `### Título`
- • Listas: `• item` ou `- item`
- > Citações: `> texto`
- Links: `[texto](url)`
- Código: `` `código` ``

Todas as formatações aparecem em **branco** sobre o fundo da página.
