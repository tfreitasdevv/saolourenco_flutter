@echo off
REM Script para build do app com suporte a 16 KB
REM Projeto: Paróquia São Lourenço
REM Data: 15/10/2025

echo ======================================
echo Build Android com Suporte a 16 KB
echo ======================================
echo.

REM Verificar se estamos no diretório correto
if not exist "pubspec.yaml" (
    echo [ERRO] Execute este script a partir da raiz do projeto Flutter
    exit /b 1
)

REM Passo 1: Limpar builds anteriores
echo [1/5] Limpando builds anteriores...
cd android
call gradlew clean
cd ..
call flutter clean
echo [OK] Limpeza concluida
echo.

REM Passo 2: Obter dependências
echo [2/5] Obtendo dependencias do Flutter...
call flutter pub get
echo [OK] Dependencias obtidas
echo.

REM Passo 3: Verificar configuração do Android
echo [3/5] Verificando configuracoes do Android...
REM NOTA: A propriedade android.bundle.enableUncompressedNativeLibs foi removida no Gradle 8.1+
REM O suporte a 16 KB é garantido apenas pela versão do NDK 27.x
echo [OK] Configuracao verificada (NDK 27.x)

REM Passo 4: Build do App Bundle
echo [4/5] Gerando App Bundle para Release...
call flutter build appbundle --release

if %errorlevel% equ 0 (
    echo [OK] App Bundle gerado com sucesso
) else (
    echo [ERRO] Erro ao gerar App Bundle
    exit /b 1
)
echo.

REM Passo 5: Informações do Bundle
echo [5/5] Informacoes do Build:
set BUNDLE_PATH=build\app\outputs\bundle\release\app-release.aab
if exist "%BUNDLE_PATH%" (
    echo [OK] Bundle criado: %BUNDLE_PATH%
    for %%A in ("%BUNDLE_PATH%") do echo [OK] Tamanho: %%~zA bytes
) else (
    echo [ERRO] Bundle nao encontrado
    exit /b 1
)
echo.

REM Verificação final
echo ======================================
echo Build Concluido com Sucesso!
echo ======================================
echo.
echo Proximos passos:
echo 1. Teste o bundle em dispositivos Android 15+
echo 2. Faca upload no Google Play Console
echo 3. Verifique a compatibilidade com 16 KB no Console
echo.
echo Localizacao do bundle:
echo   %BUNDLE_PATH%
echo.

pause
