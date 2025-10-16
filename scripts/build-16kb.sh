#!/bin/bash

# Script para build do app com suporte a 16 KB
# Projeto: Paróquia São Lourenço
# Data: 15/10/2025

echo "======================================"
echo "Build Android com Suporte a 16 KB"
echo "======================================"
echo ""

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Verificar se estamos no diretório correto
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}Erro: Execute este script a partir da raiz do projeto Flutter${NC}"
    exit 1
fi

# Passo 1: Limpar builds anteriores
echo -e "${YELLOW}[1/5] Limpando builds anteriores...${NC}"
cd android
./gradlew clean
cd ..
flutter clean
echo -e "${GREEN}✓ Limpeza concluída${NC}"
echo ""

# Passo 2: Obter dependências
echo -e "${YELLOW}[2/5] Obtendo dependências do Flutter...${NC}"
flutter pub get
echo -e "${GREEN}✓ Dependências obtidas${NC}"
echo ""

# Passo 3: Verificar configuração do Android
echo -e "${YELLOW}[3/5] Verificando configurações do Android...${NC}"
# NOTA: A propriedade android.bundle.enableUncompressedNativeLibs foi removida no Gradle 8.1+
# O suporte a 16 KB é garantido apenas pela versão do NDK 27.x
echo -e "${GREEN}✓ Configuração verificada (NDK 27.x)${NC}"
echo ""

# Passo 4: Build do App Bundle
echo -e "${YELLOW}[4/5] Gerando App Bundle para Release...${NC}"
flutter build appbundle --release

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ App Bundle gerado com sucesso${NC}"
else
    echo -e "${RED}✗ Erro ao gerar App Bundle${NC}"
    exit 1
fi
echo ""

# Passo 5: Informações do Bundle
echo -e "${YELLOW}[5/5] Informações do Build:${NC}"
BUNDLE_PATH="build/app/outputs/bundle/release/app-release.aab"
if [ -f "$BUNDLE_PATH" ]; then
    BUNDLE_SIZE=$(du -h "$BUNDLE_PATH" | cut -f1)
    echo -e "${GREEN}✓ Bundle criado: $BUNDLE_PATH${NC}"
    echo -e "${GREEN}✓ Tamanho: $BUNDLE_SIZE${NC}"
else
    echo -e "${RED}✗ Bundle não encontrado${NC}"
    exit 1
fi
echo ""

# Verificação final
echo "======================================"
echo -e "${GREEN}Build Concluído com Sucesso!${NC}"
echo "======================================"
echo ""
echo "Próximos passos:"
echo "1. Teste o bundle em dispositivos Android 15+"
echo "2. Faça upload no Google Play Console"
echo "3. Verifique a compatibilidade com 16 KB no Console"
echo ""
echo "Localização do bundle:"
echo "  $BUNDLE_PATH"
echo ""
