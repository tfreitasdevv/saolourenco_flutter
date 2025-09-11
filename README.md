# 🏛️ Paróquia São Lourenço

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange.svg)
![Version](https://img.shields.io/badge/Version-2.0.2-green.svg)

App oficial para uso gerencial e comunitário da **Paróquia São Lourenço**. Este aplicativo foi desenvolvido para facilitar a comunicação e organização das atividades paroquiais, oferecendo uma plataforma digital integrada para toda a comunidade.

## ✨ Funcionalidades

### 👥 Gestão Comunitária
- **Avisos e Comunicados** - Sistema de notificações para a comunidade
- **Eventos Paroquiais** - Calendário e informações sobre eventos
- **Horários de Missas** - Consulta aos horários litúrgicos
- **Informações Institucionais** - História, clero e estrutura da paróquia

### 🙏 Pastorais e Movimentos
- **Catequese** - Gestão de turmas e atividades catequéticas
- **Crisma** - Acompanhamento do sacramento de confirmação
- **Batismo** - Informações e agendamentos
- **EJC (Encontro de Jovens com Cristo)** - Portal para jovens
- **MEJ (Movimento Eucarístico Jovem)** - Atividades eucarísticas
- **Pastoral da Saúde** - Cuidado aos enfermos
- **Pastoral da Rua** - Assistência social
- **Grupo de Oração** - Encontros de oração
- **Conferência São Vicente de Paulo** - Obras de caridade
- **Coral** - Atividades musicais litúrgicas
- **Coroinhas e Acólitos** - Formação para servir ao altar

### 📱 Recursos Digitais
- **Interface Responsiva** - Adaptada para mobile e web
- **Autenticação Segura** - Sistema de login integrado
- **Armazenamento em Nuvem** - Backup automático dos dados
- **Notificações Push** - Comunicação direta com os usuários

## 🚀 Tecnologias Utilizadas

### Frontend
- **Flutter 3.0+** - Framework multiplataforma
- **Dart** - Linguagem de programação
- **Material Design** - Design System do Google

### Arquitetura e Estado
- **MobX** - Gerenciamento de estado reativo
- **Flutter Modular** - Arquitetura modular e injeção de dependências
- **Padrão MVC** - Separação clara de responsabilidades

### Backend e Serviços
- **Firebase Core** - Plataforma de desenvolvimento
- **Firebase Auth** - Autenticação de usuários
- **Cloud Firestore** - Banco de dados NoSQL
- **Firebase Storage** - Armazenamento de arquivos
- **Firebase Hosting** - Hospedagem web

### Bibliotecas Principais
- `flutter_mobx` - Integração MobX com Flutter
- `cached_network_image` - Cache otimizado de imagens
- `url_launcher` - Abertura de URLs externas
- `mask_text_input_formatter` - Formatação de inputs
- `flutter_staggered_animations` - Animações fluidas

## 📋 Pré-requisitos

- Flutter SDK 3.0 ou superior
- Dart SDK 3.0 ou superior
- Android Studio / VS Code
- Conta Firebase ativa
- Git para controle de versão

## Versões utilizadas

- Flutter 3.22.0
- Node 22.19.0
- Java 17.0.12
- Firebase 14.15.1
- Google Cloud SDK 537.0.0
- bq 2.1.22
- core 2025.08.29
- gcloud-crc32c 1.0.0
- gsutil 5.35

## 🛠️ Instalação e Configuração

### 1. Clone o Repositório
```bash
git clone https://github.com/tfreitasdevv/saolourenco_flutter.git
cd saolourenco_flutter
```

### 2. Instale as Dependências
```bash
flutter pub get
```

### 3. Configuração de Segurança
Siga as instruções detalhadas no arquivo [`SECURITY_SETUP.md`](SECURITY_SETUP.md) para:
- Configurar variáveis de ambiente Firebase
- Configurar keystore para build de produção
- Configurar certificados de segurança

### 4. Configuração do Firebase
```bash
# Instale o Firebase CLI
npm install -g firebase-tools

# Faça login no Firebase
firebase login

# Configure o projeto
firebase init
```

### 5. Execute o Projeto
```bash
# Para desenvolvimento
flutter run

# Para build de produção (Android)
flutter build apk --release

# Para build de produção (Web)
flutter build web
```

## � Deploy e Publicação

### 📱 Android (Google Play Store)
```bash
# Build para produção
flutter build appbundle --release

# O arquivo será gerado em: build/app/outputs/bundle/release/app-release.aab
```

### 🌐 Web (Firebase Hosting)
A aplicação web está disponível gratuitamente em: **https://sao-lourenco.web.app**

```bash
# Build para web
flutter build web --release

# Deploy para Firebase Hosting
firebase deploy --only hosting
```

### 🔄 Updates Futuros

#### Método Automático (Recomendado)
Execute o script de deploy automático:
```bash
# Windows
./deploy-web.bat

# Linux/macOS
chmod +x deploy-web.sh
./deploy-web.sh
```

#### Método Manual
Para atualizações na versão web:
```bash
# 1. Faça as alterações no código
# 2. Gere o build para produção
flutter build web --release

# 3. Faça o deploy
firebase deploy --only hosting

# 4. Confirme no console: https://console.firebase.google.com/project/sao-lourenco/overview
```

#### URLs da Aplicação Web
- **Principal**: https://sao-lourenco.web.app
- **Alternativa**: https://sao-lourenco.firebaseapp.com
- **Console Firebase**: https://console.firebase.google.com/project/sao-lourenco/overview

#### ⚠️ Importante
- ✅ Updates na web **NÃO** afetam o app Android em produção
- ✅ Dados do Firestore são compartilhados entre Android e Web
- ✅ Usuários podem usar a mesma conta em ambas plataformas
- ✅ Deploy web é instantâneo e gratuito

## �📱 Estrutura do Projeto

```
lib/
├── app/
│   ├── modules/          # Módulos funcionais
│   │   ├── home/         # Tela inicial
│   │   ├── login/        # Autenticação
│   │   ├── pastorais/    # Gestão das pastorais
│   │   ├── eventos/      # Eventos paroquiais
│   │   ├── avisos/       # Sistema de avisos
│   │   └── ...
│   ├── shared/           # Componentes compartilhados
│   │   ├── widgets/      # Widgets reutilizáveis
│   │   ├── services/     # Serviços da aplicação
│   │   └── utils/        # Utilitários
│   ├── app_controller.dart
│   ├── app_module.dart
│   └── app_widget.dart
├── firebase_options.dart
└── main.dart
```

## 🎨 Design System

O aplicativo utiliza uma identidade visual consistente baseada em:
- **Fonte Principal**: Raleway (Regular, Bold, Light, Medium, Black)
- **Fonte Decorativa**: Cinzel Decorative
- **Paleta de Cores**: Tons terrosos e dourados
- **Componentes**: Material Design 3

## 🔒 Segurança

- Autenticação Firebase com múltiplos provedores
- Regras de segurança no Firestore
- Validação de entrada em todos os formulários
- Criptografia de dados sensíveis
- Backup automático na nuvem

## 🤝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -m '✨ Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

### Padrões de Commit
Utilizamos [Gitmoji](https://gitmoji.dev/) para padronizar as mensagens de commit:
- ✨ `:sparkles:` Nova funcionalidade
- 🐛 `:bug:` Correção de bug
- 📝 `:memo:` Documentação
- 🎨 `:art:` Melhorias de código
- ⚡ `:zap:` Performance
- 🔒 `:lock:` Segurança

## 📄 Licença

Este projeto é proprietário da **Paróquia São Lourenço**. Todos os direitos reservados.

## 📞 Contato

**Paróquia São Lourenço**
- 📧 Email: contato@paroquiasaolourenco.org.br
- 🌐 Website: [www.paroquiasaolourenco.org.br](https://www.paroquiasaolourenco.org.br)
- 📱 Desenvolvedor: [@tfreitasdevv](https://github.com/tfreitasdevv)

---

**Desenvolvido com ❤️ para a comunidade da Paróquia São Lourenço**
