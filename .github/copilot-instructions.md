# Padroes de desenvolvimento do projeto SAOLOURENCO

## Instrucoes para geracao de mensagens de commit

- Escreva a mensagem em portugues brasileiro.
- Seja detalhado ao descrever as alteracoes realizadas e o motivo de cada mudanca.
- Use gitmoji no inicio da mensagem de commit.
- Estruture a mensagem com bullets.

## Instrucoes para geracao de codigo

- Use as melhores praticas e as convencoes padrao do ecossistema Flutter.
- Escreva comentarios em portugues brasileiro quando eles forem realmente necessarios.
- Garanta que o codigo seja limpo, legivel e bem estruturado.
- Mantenha o codigo DRY (Don't Repeat Yourself), evitando duplicacao desnecessaria.
- Escreva codigo modular, reutilizavel e de facil manutencao.
- Use nomes significativos e descritivos para variaveis, funcoes, classes e arquivos.
- Inclua tratamento de erros e validacao de entrada sempre que fizer sentido.
- Preserve consistencia com a arquitetura, os padroes e o estilo ja adotados no projeto.

## Compatibilidade multiplataforma obrigatoria

- Toda alteracao e toda implementacao devem considerar que o aplicativo precisa funcionar em Android, iOS e Web.
- No contexto Web, considere o uso tanto em desktop quanto em dispositivos moveis, incluindo navegacao em aparelhos Android e iPhone.
- Evite solucoes que funcionem apenas em uma plataforma sem tratamento equivalente, fallback ou justificativa tecnica clara.
- Sempre que tocar em UI, navegacao, armazenamento, arquivos, plugins nativos, permissoes, notificacoes, autenticacao ou integracoes externas, avalie os impactos nas tres plataformas.
- Prefira abordagens compativeis com Flutter multiplataforma e use condicionais por plataforma apenas quando forem realmente necessarias.

## Validacao esperada das alteracoes

- Ao implementar uma funcionalidade, considere comportamento, layout e fluxo nas plataformas Android, iOS e Web.
- Ao corrigir bugs, verifique se a correcao nao introduz regressao em outra plataforma.
- Quando uma solucao tiver limitacao conhecida em alguma plataforma, isso deve ser explicitado claramente.
- Sempre que possivel, descreva quais plataformas foram consideradas na implementacao ou validacao.

## Preferencias de qualidade

- Priorize correcao na causa raiz, e nao apenas mitigacoes superficiais.
- Evite complexidade desnecessaria e dependencias sem justificativa.
- Prefira componentes, servicos e utilitarios reutilizaveis em vez de logica duplicada.
- Mantenha separacao clara de responsabilidades entre interface, estado, dominio e integracoes.

## Atualizacao obrigatoria do changelog

- Toda alteracao relevante no projeto deve atualizar o arquivo `CHANGELOG.md`.
- O changelog deve seguir boas praticas de mercado, preferencialmente no estilo Keep a Changelog.
- Organize as entradas por versao e, quando ainda nao houver release definida, use a secao `Unreleased`.
- Classifique as mudancas em categorias claras, como `Added`, `Changed`, `Fixed`, `Removed`, `Security` e outras quando realmente necessario.
- Registre apenas mudancas relevantes para produto, manutencao, arquitetura, comportamento, seguranca, compatibilidade ou fluxo de desenvolvimento.
- Nao polua o changelog com ruido de refatoracoes triviais sem impacto perceptivel ou ajustes internos irrelevantes.
- Sempre descreva as entradas de forma objetiva, orientada a impacto e compreensivel para outras pessoas do time.
- Ao corrigir bugs, indique o problema resolvido e, quando fizer sentido, o contexto afetado, como Android, iOS, Web, Firebase, build ou infraestrutura.
- Ao introduzir limitacoes, migracoes ou breaking changes, isso deve ficar explicito no changelog.
- Se uma alteracao afetar compatibilidade multiplataforma, registre isso claramente no `CHANGELOG.md`.
