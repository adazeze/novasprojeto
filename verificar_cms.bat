@echo off
setlocal enabledelayedexpansion

:: Arquivos de entrada e saída
set "input=sites.txt"
set "output=resultados.txt"

echo Verificando CMS dos sites...
echo Resultado da verificacao - %date% %time% > "%output%"
echo ------------------------------------------ >> "%output%"

if not exist "%input%" (
    echo Erro: O arquivo %input% nao foi encontrado.
    pause
    exit /b
)

for /f "tokens=*" %%a in (%input%) do (
    set "url=%%a"
    echo Processando: !url!
    echo Site: !url! >> "%output%"
    
    :: Usa PowerShell para baixar o HTML e findstr para filtrar a meta generator
    powershell -command "(Invoke-WebRequest -Uri '!url!' -UserAgent 'Mozilla/5.0' -TimeoutSec 10).Content" 2>nul | findstr /I "generator" >> "%output%"
    
    if errorlevel 1 (
        echo Nenhuma tag generator encontrada ou erro de conexao. >> "%output%"
    )
    
    echo ------------------------------------------ >> "%output%"
)

echo Concluido! Verifique o arquivo %output%
pause
