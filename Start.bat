@echo off
title Servidor EDCELL-TECH - Auto com Ngrok API
color 0E

:: Caminho do arquivo index.html
set INDEX_PATH=public\index.html

:: ===============================
:: Verifica se ngrok está instalado
:: ===============================
where ngrok >nul 2>&1
if %ERRORLEVEL%==0 (
    echo Ngrok ja esta instalado.
) else (
    echo Ngrok nao encontrado. Instalando globalmente...
    npm install -g ngrok
    if %ERRORLEVEL% neq 0 (
        echo Erro ao instalar Ngrok. Verifique sua conexao e permissao de administrador.
        pause
        exit
    )
)

:: ===============================
:: Inicia o servidor Node.js
:: ===============================
echo Iniciando servidor Node.js...
start "" cmd /k "node server.js"

:: Aguarda 2 segundos para o servidor iniciar
timeout /t 2 >nul

:: ===============================
:: Inicia o Ngrok
:: ===============================
echo Iniciando Ngrok para servidor publico...
start "" ngrok http 3000 --log=stdout >nul 2>&1

:: ===============================
:: Aguarda Ngrok criar túnel e pega link público via API
:: ===============================
echo Aguardando link publico do Ngrok...
set "PUBLIC_URL="

:WAIT_NGROK_API
timeout /t 1 >nul
for /f "usebackq tokens=*" %%a in (`powershell -Command "try { (Invoke-RestMethod -Uri 'http://127.0.0.1:4040/api/tunnels').tunnels[0].public_url } catch { echo '' }"`) do set "PUBLIC_URL=%%a"
if "%PUBLIC_URL%"=="" goto WAIT_NGROK_API

:: ===============================
:: Abre navegador com link público
:: ===============================
echo Abrindo navegador com link publico: %PUBLIC_URL%
start "" "%PUBLIC_URL%"

:: ===============================
:: Abre index.html local caso exista
:: ===============================
if exist "%INDEX_PATH%" (
    echo Abrindo navegador com index.html local...
    start "" "%INDEX_PATH%"
) else (
    echo Nenhum arquivo index.html encontrado na pasta public!
)

echo Servidor e Ngrok iniciados com sucesso!
pause
