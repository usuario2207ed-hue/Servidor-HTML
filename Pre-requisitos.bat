@echo off
title Verificacao de Pre-Requisitos - EDCELLTECH
color 0E

:: ===============================
:: Função para download (usa PowerShell)
:: ===============================
set "DOWNLOAD_CMD=powershell -Command "Invoke-WebRequest -Uri"
set "DOWNLOAD_SAVE=-OutFile"

:: ===============================
:: Verifica Windows 10 ou 11
:: ===============================
ver | findstr /i "10." >nul
if %ERRORLEVEL% neq 0 (
    ver | findstr /i "11." >nul
    if %ERRORLEVEL% neq 0 (
        echo Este script requer Windows 10 ou 11.
        pause
        exit
    )
)
echo [OK] Windows 10/11 detectado.

:: ===============================
:: Verifica Node.js
:: ===============================
set NODE_VER=
for /f "tokens=*" %%i in ('node -v 2^>nul') do set NODE_VER=%%i

if "%NODE_VER%"=="" (
    echo Node.js nao encontrado. Baixando e instalando...
    %DOWNLOAD_CMD% "https://nodejs.org/dist/v20.17.0/node-v20.17.0-x64.msi" %DOWNLOAD_SAVE% "%temp%\node.msi"
    start /wait msiexec /i "%temp%\node.msi" /quiet /norestart
    for /f "tokens=*" %%i in ('node -v 2^>nul') do set NODE_VER=%%i
    if "%NODE_VER%"=="" (
        echo Erro ao instalar Node.js. Verifique permissões de administrador.
        pause
        exit
    )
)
echo [OK] Node.js %NODE_VER% instalado.

:: ===============================
:: Verifica NPM
:: ===============================
set NPM_VER=
for /f "tokens=*" %%i in ('npm -v 2^>nul') do set NPM_VER=%%i

if "%NPM_VER%"=="" (
    echo NPM nao encontrado. Verifique instalacao do Node.js.
    pause
    exit
)
echo [OK] NPM %NPM_VER% instalado.

:: ===============================
:: Verifica Ngrok
:: ===============================
set NGROK_VER=
for /f "tokens=*" %%i in ('ngrok version 2^>nul') do set NGROK_VER=%%i

if "%NGROK_VER%"=="" (
    echo Ngrok nao encontrado. Instalando via NPM globalmente...
    npm install -g ngrok
    for /f "tokens=*" %%i in ('ngrok version 2^>nul') do set NGROK_VER=%%i
    if "%NGROK_VER%"=="" (
        echo Erro ao instalar Ngrok. Verifique conexao e permissao de administrador.
        pause
        exit
    )
)
echo [OK] %NGROK_VER%

:: ===============================
:: Resumo Final
:: ===============================
echo.
echo ======================================
echo  Lista de Pre-Requisitos Instalados
echo ======================================
echo Windows 10/11
echo Node.js: %NODE_VER%
echo NPM:     %NPM_VER%
echo Ngrok:   %NGROK_VER%
echo ======================================
echo.
echo >>> Tudo OK! Ambiente pronto para uso. <<<
echo.

pause
