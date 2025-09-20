@echo off
title Fechar Servidores EDCELL-TECH
color 0C

echo Parando servidor Node.js...
:: Mata todos os processos Node.js (que incluem server.js)
taskkill /IM node.exe /F >nul 2>&1

echo Parando Ngrok...
:: Mata todos os processos ngrok
taskkill /IM ngrok.exe /F >nul 2>&1

echo Todos os servidores e tunel Ngrok foram finalizados com sucesso!
timeout /t 2 >nul
exit
