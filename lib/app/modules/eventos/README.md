# Módulo Eventos

Este módulo foi criado para gerenciar os eventos da paróquia, utilizando o Firestore Database como fonte de dados.

## Estrutura do Módulo

```
eventos/
├── models/
│   └── evento_model.dart          # Modelo de dados do evento
├── repositories/
│   └── eventos_repository.dart    # Repository para operações no Firestore
├── widgets/
│   ├── evento_card.dart          # Widget para exibir um evento
│   ├── eventos_estados.dart      # Widgets para estados vazios e carregamento
│   └── eventos_filtros.dart      # Widgets para filtros e busca
├── eventos_controller.dart       # Controller MobX para gerenciar estado
├── eventos_controller.g.dart     # Arquivo gerado pelo MobX
├── eventos_module.dart           # Módulo Modular com dependências
├── eventos_page.dart             # Página principal do módulo
└── eventos_page_antiga.dart      # Backup da implementação anterior
```

## Estrutura de Dados no Firestore

A coleção "eventos" no Firestore contém documentos com os seguintes campos:

### Campos obrigatórios:
- **data** (Timestamp): Data e hora do evento
- **titulo** (String): Título do evento (compatível com Markdown)

### Campos opcionais:
- **descricao** (String): Descrição detalhada do evento (compatível com Markdown)
- **imagem** (String): URL da imagem do evento no Firebase Storage
- **link** (String): Link externo relacionado ao evento

## Funcionalidades Implementadas

### EventoModel
- Conversão entre DocumentSnapshot e modelo de dados
- Métodos utilitários para verificar:
  - Se tem imagem, link ou descrição
  - Se o evento já passou, é hoje ou é próximo
  - Comparações e validações

### EventosRepository
- Stream de eventos em tempo real
- Filtros por data (futuros, passados, período específico)
- Busca por título
- Eventos do mês atual
- Estatísticas (contagem de eventos)
- Métodos para administração (CRUD)

### EventosController (MobX)
- Gerenciamento de estado reativo
- Carregamento de eventos com diferentes filtros
- Busca em tempo real
- Estados de carregamento e erro
- Filtros por visualização
- Computed properties para dados derivados

### Interface do Usuário
- **EventoCard**: Exibe evento completo com imagem, título, descrição e link
- **EventoCardCompacto**: Versão resumida para listas
- **EventosFiltros**: Busca e filtros de visualização
- **EventosEstatisticas**: Estatísticas dos eventos
- **EventosEstados**: Estados vazios e carregamento

## Tipos de Visualização

1. **Todos**: Todos os eventos ordenados por data
2. **Futuros**: Apenas eventos futuros
3. **Passados**: Apenas eventos que já aconteceram
4. **Este mês**: Eventos do mês atual

## Recursos da Interface

- **Pull-to-refresh**: Atualizar lista puxando para baixo
- **Busca em tempo real**: Buscar por título ou descrição
- **Filtros visuais**: Chips para alternar visualização
- **FAB Próximos**: Botão flutuante para ver próximos eventos
- **Modal de detalhes**: Bottom sheet com detalhes completos
- **Tratamento de estados**: Loading, erro, vazio
- **Suporte a Markdown**: Título e descrição com formatação
- **Links externos**: Abrir URLs em app externo
- **Imagens do Storage**: Carregamento com cache e placeholder

## Dependências

O módulo utiliza as seguintes dependências já presentes no projeto:
- `cloud_firestore`: Para conexão com Firestore
- `mobx` e `flutter_mobx`: Para gerenciamento de estado
- `flutter_modular`: Para injeção de dependências
- `flutter_markdown`: Para renderização de Markdown
- `cached_network_image`: Para cache de imagens
- `url_launcher`: Para abrir links externos
- `intl`: Para formatação de datas

## Como usar

1. O módulo já está registrado no sistema de rotas
2. Para acessar: navigate to `/eventos`
3. Para injetar o controller: `Modular.get<EventosController>()`
4. Para injetar o repository: `Modular.get<EventosRepository>()`

## Configuração do Firestore

Para que o módulo funcione corretamente, certifique-se de que:

1. A coleção "eventos" existe no Firestore
2. As regras de segurança permitem leitura da coleção
3. Os documentos seguem a estrutura esperada
4. As imagens estão no Firebase Storage com URLs públicas

## Exemplo de documento no Firestore

```json
{
  "data": "2025-09-15T19:00:00Z",
  "titulo": "**Festa de São Lourenço**",
  "descricao": "Celebração anual do padroeiro da paróquia com *missa solene* e festividades.",
  "imagem": "https://firebasestorage.googleapis.com/v0/b/projeto/o/eventos%2Ffesta-sao-lourenco.jpg",
  "link": "https://paroquia.com.br/festa-sao-lourenco"
}
```
