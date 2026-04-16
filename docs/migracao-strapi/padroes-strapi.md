# Padrões de Código Strapi (Referência para Migração)

> Padrões já aplicados nos módulos 3.1–3.7. Use como referência para migrar os módulos restantes.

---

## Padrão 1: Página com FutureBuilder simples

Usado em: Horários, Avisos, Avisos Música, Como Ajudar, Confissões.

```dart
// Substituir: cloud_firestore → strapi_client + api_config + flutter_modular
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/shared/config/api_config.dart';
import 'package:paroquia_sao_lourenco/app/shared/services/strapi_client.dart';

// StatefulWidget com Future no initState (evitar rebuilds)
class _PageState extends State<Page> {
  late final Future<List<Map<String, dynamic>>> _dataFuture;

  @override
  void initState() {
    super.initState();
    final strapi = Modular.get<StrapiClient>();
    _dataFuture = strapi
        .get(ApiConfig.avisos, queryParameters: {'sort': 'data:desc', 'populate': 'imagem'})
        .then((r) => List<Map<String, dynamic>>.from(r.data['data'] ?? []));
  }

  // FutureBuilder<List<Map<String, dynamic>>> em vez de FutureBuilder<QuerySnapshot>
}
```

## Padrão 2: Card widgets

Usado em: AvisoCard, ComoAjudarCard, AvisoMusicaCard.

```dart
// ANTES: final DocumentSnapshot snapshot;
// DEPOIS: final Map<String, dynamic> data;

// ANTES: Timestamp → DateTime
//   Timestamp dataTS = data["data"];
//   DateTime dataDT = DateTime.fromMillisecondsSinceEpoch(dataTS.seconds * 1000);
// DEPOIS: ISO 8601 string → DateTime
//   DateTime dataDT = DateTime.parse(data['data']);

// ANTES: imagem como URL string direta
// DEPOIS: imagem como objeto media Strapi (popular com ?populate=imagem)
//   final imagem = data['imagem'];
//   final imagemUrl = imagem is Map ? imagem['url'] ?? '' : '';
```

## Padrão 3: Repository com filtros

Usado em: EventosRepository.

```dart
// Filtros Strapi equivalentes a queries Firestore:
//   .where('data', isGreaterThanOrEqualTo: ...)  →  'filters[data][$gte]': isoString
//   .where('data', isLessThan: ...)               →  'filters[data][$lt]': isoString
//   .where('titulo', contains: ...)               →  'filters[titulo][$containsi]': texto
//   .orderBy('data', descending: false)           →  'sort': 'data:asc'
//   .limit(n)                                     →  'pagination[pageSize]': n
//   .count()                                      →  response.data['meta']['pagination']['total']

// Streams → Futures (sem real-time no Strapi)
// Stream<List<Model>>  →  Future<List<Model>>
// StreamSubscription removido do controller
```

## Padrão 4: PastoralPage (componente repetível Strapi)

Migra 23 módulos de pastorais de uma vez.

```dart
// Query: filters[slug][$eq]=<slug>&populate=secoes,secoes.url_imagem
// Extração de seções:
final pastoralData = (response.data['data'] as List).first;
final secoesList = pastoralData['secoes'] as List? ?? [];
for (final secao in secoesList) {
  final tipo = secao['tipo'] ?? 'texto';  // enum: texto, botao, imagem
  final urlImagem = secao['url_imagem'];   // pode ser Map (media) ou null
  // ...
}
```

## Padrão 5: Busca por filtro único

Usado em: Clero.

```dart
// ANTES: FirebaseFirestore.instance.collection('clero').doc('paroco').get()
// DEPOIS: StrapiClient.get(ApiConfig.cleros, queryParameters: {
//   'filters[funcao][$eq]': 'paroco',
//   'populate': 'imagem',
// })
// Resultado: lista com 1 item → .first
```

---

## Formato de Resposta da API Strapi v5

```json
// GET /api/avisos?sort=data:desc&populate=imagem
// ⚠️ Strapi v5 usa formato FLAT (sem "attributes" aninhados, diferente do v4)
{
  "data": [
    {
      "id": 1,
      "documentId": "abc123def456",
      "titulo": "Título do aviso",
      "descricao": "Texto do aviso...",
      "data": "2026-04-10T00:00:00.000Z",
      "prioridade": 1,
      "createdAt": "2026-04-10T00:00:00.000Z",
      "updatedAt": "2026-04-10T00:00:00.000Z",
      "publishedAt": "2026-04-10T00:00:00.000Z",
      "imagem": {
        "id": 5,
        "documentId": "img789xyz",
        "url": "https://ik.imagekit.io/.../imagem.jpg",
        "width": 800,
        "height": 600,
        "formats": { "thumbnail": { "url": "..." }, "small": { "url": "..." } }
      }
    }
  ],
  "meta": {
    "pagination": { "page": 1, "pageSize": 25, "pageCount": 1, "total": 3 }
  }
}
```

> **Nota importante sobre Strapi v5**: Os campos ficam diretamente no objeto de cada item em `data[]`, sem o wrapper `attributes` que existia no Strapi v4. Campos de media (imagem) também seguem formato flat quando populados.

## Filtros úteis da API Strapi

| Filtro                    | Exemplo                                       |
| ------------------------- | --------------------------------------------- |
| Ordenação                 | `?sort=campo:asc` ou `:desc`                  |
| Igualdade                 | `?filters[campo][$eq]=valor`                  |
| Maior ou igual            | `?filters[data][$gte]=2026-01-01`             |
| Menor que                 | `?filters[data][$lt]=2026-12-31`              |
| Contém (case-insensitive) | `?filters[titulo][$containsi]=texto`          |
| Popular relação/media     | `?populate=imagem`                            |
| Popular tudo              | `?populate=*`                                 |
| Paginação                 | `?pagination[page]=1&pagination[pageSize]=10` |
