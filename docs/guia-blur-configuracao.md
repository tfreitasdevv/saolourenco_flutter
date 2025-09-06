# Guia de Configuração de Blur para Páginas

Este guia explica como implementar e configurar efeitos de blur nas páginas do aplicativo para melhorar a legibilidade do conteúdo.

## 🎯 Quando Usar Blur

O blur é recomendado quando:
- Há texto branco sobre imagem de fundo
- A imagem tem muitos detalhes que competem com o texto
- Precisa melhorar o contraste e legibilidade
- Quer criar um efeito visual mais moderno e sofisticado

## 🔧 Implementação

### 1. Adicionar Constantes

No arquivo `lib/app/shared/constants/constants.dart`:

```dart
// Configurações de Blur para [NOME_DA_PAGINA]
/// Intensidade do blur para a página
const double [pagina]BlurIntensity = 2.5;

/// Opacidade do overlay escuro sobre o fundo
const double [pagina]OverlayOpacity = 0.15;
```

### 2. Imports Necessários

```dart
import 'dart:ui'; // Para ImageFilter
```

### 3. Estrutura com Stack

```dart
body: Stack(
  children: [
    // Imagem de fundo
    Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(bg),
          fit: BoxFit.cover,
        ),
      ),
    ),
    // Blur e overlay
    BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: [pagina]BlurIntensity,
        sigmaY: [pagina]BlurIntensity,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withOpacity([pagina]OverlayOpacity),
      ),
    ),
    // Conteúdo da página
    SingleChildScrollView(
      child: YourContent(),
    ),
  ],
),
```

## 📊 Valores Recomendados

### Intensidade de Blur:

| Valor | Efeito | Uso Recomendado |
|-------|--------|-----------------|
| 0.0 | Sem blur | Imagens já otimizadas |
| 1.0 | Blur suave | Imagens com poucos detalhes |
| 2.5 | Blur médio | **Uso geral (recomendado)** |
| 4.0 | Blur intenso | Imagens muito detalhadas |
| 5.0+ | Blur muito intenso | Casos especiais |

### Opacidade do Overlay:

| Valor | Efeito | Uso Recomendado |
|-------|--------|-----------------|
| 0.0 | Transparente | Apenas blur |
| 0.1 | Muito sutil | Imagens claras |
| 0.15 | Suave | **Uso geral (recomendado)** |
| 0.3 | Médio | Imagens muito coloridas |
| 0.5+ | Forte | Máximo contraste |

## 🎨 Exemplos Práticos

### Para Texto Branco (como Confissões):
```dart
const double confissoesBlurIntensity = 2.5;
const double confissoesOverlayOpacity = 0.15;
```

### Para Texto Escuro:
```dart
const double paginaBlurIntensity = 1.5;
const double paginaOverlayOpacity = 0.0; // Sem overlay escuro
```

### Para Máxima Legibilidade:
```dart
const double paginaBlurIntensity = 4.0;
const double paginaOverlayOpacity = 0.3;
```

## 💡 Dicas de Design

1. **Teste em diferentes dispositivos**: O efeito pode variar
2. **Considere o conteúdo**: Mais texto = mais blur necessário
3. **Mantenha consistência**: Use valores similares em páginas relacionadas
4. **Performance**: Blur intenso pode impactar performance em dispositivos antigos
5. **Acessibilidade**: Garanta contraste suficiente para leitura

## 🚀 Aplicando em Outras Páginas

### Exemplo: Página de Avisos
```dart
// Em constants.dart
const double avisosBlurIntensity = 2.0;
const double avisosOverlayOpacity = 0.1;

// Na página
BackdropFilter(
  filter: ImageFilter.blur(
    sigmaX: avisosBlurIntensity,
    sigmaY: avisosBlurIntensity,
  ),
  child: Container(
    color: Colors.black.withOpacity(avisosOverlayOpacity),
  ),
),
```

## 🔄 Configuração Dinâmica (Avançado)

Para permitir que usuários ajustem o blur:

```dart
class BlurSettings {
  static double confissoesBlur = 2.5;
  static double confissoesOverlay = 0.15;
  
  static void updateBlur(double blur, double overlay) {
    confissoesBlur = blur;
    confissoesOverlay = overlay;
    // Salvar em SharedPreferences se necessário
  }
}
```

Este sistema permite máxima flexibilidade na configuração visual das páginas!
