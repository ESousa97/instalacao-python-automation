@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul

:main_loop
cls
echo ========================================
echo  INSTALADOR AUTOMÁTICO - JANELA IMORTAL
echo ========================================
echo  Esta janela NUNCA vai fechar automaticamente!
echo ========================================
echo.

REM Verificar se está executando como administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERRO] Este script precisa ser executado como Administrador!
    echo        Clique com o botão direito no script e selecione "Executar como administrador"
    echo.
    pause
    goto :main_loop
)

echo MENU PRINCIPAL:
echo.
echo 1. Instalar App Installer (winget)
echo 2. Instalar PowerShell 7.5
echo 3. Instalar Python
echo 4. Instalar TUDO (sequencial)
echo 5. Verificar status das instalações (Nao implementado)
echo 6. Sair
echo.

set /p "choice=Digite sua escolha (1-6): "

if "%choice%"=="1" call :install_app_installer
if "%choice%"=="2" call :install_powershell
if "%choice%"=="3" call :install_python
if "%choice%"=="4" call :install_all
if "%choice%"=="5" call :check_status
if "%choice%"=="6" goto :exit_script

echo.
echo Pressione qualquer tecla para voltar ao menu principal...
pause >nul
goto :main_loop

REM ==========================================
REM FUNÇÃO: Instalar App Installer
REM ==========================================
:install_app_installer
echo.
echo ========================================
echo  INSTALANDO APP INSTALLER
echo ========================================
echo.

winget --version >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] App Installer já está instalado!
    goto :eof
)

echo [INFO] Abrindo janela para instalar App Installer...

REM Criar script simples
echo @echo off > "%TEMP%\install_winget.bat"
echo echo Instalando App Installer... >> "%TEMP%\install_winget.bat"
echo powershell -Command "try { Invoke-WebRequest -Uri 'https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle' -OutFile '$env:TEMP\winget.msixbundle'; Add-AppxPackage '$env:TEMP\winget.msixbundle'; echo 'OK' > '$env:TEMP\winget_status.txt' } catch { echo 'ERRO' > '$env:TEMP\winget_status.txt' }" >> "%TEMP%\install_winget.bat"
echo pause >> "%TEMP%\install_winget.bat"

start "Instalação App Installer" "%TEMP%\install_winget.bat"

echo [AGUARDANDO] Instalação em andamento na nova janela...

:wait_winget
timeout /t 3 >nul
if exist "%TEMP%\winget_status.txt" (
    set /p status=<"%TEMP%\winget_status.txt"
    del "%TEMP%\winget_status.txt" 2>nul
    del "%TEMP%\install_winget.bat" 2>nul
    if "!status!"=="OK" (
        echo [OK] App Installer instalado com sucesso!
    ) else (
        echo [ERRO] Falha na instalação do App Installer
    )
) else (
    goto :wait_winget
)
goto :eof

REM ==========================================
REM FUNÇÃO: Instalar PowerShell 7.5
REM ==========================================
:install_powershell
echo.
echo ========================================
echo  INSTALANDO POWERSHELL 7.5
echo ========================================
echo.

pwsh -Command "exit 0" >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] PowerShell 7.5 já está instalado!
    goto :eof
)

echo [INFO] Abrindo janela para instalar PowerShell 7.5...

REM Criar script simples
echo @echo off > "%TEMP%\install_ps7.bat"
echo echo Instalando PowerShell 7.5... >> "%TEMP%\install_ps7.bat"
echo winget install Microsoft.PowerShell --accept-package-agreements --accept-source-agreements --silent >> "%TEMP%\install_ps7.bat"
echo if %%errorLevel%% equ 0 ( >> "%TEMP%\install_ps7.bat"
echo     echo OK ^> "%TEMP%\ps7_status.txt" >> "%TEMP%\install_ps7.bat"
echo ) else ( >> "%TEMP%\install_ps7.bat"
echo     echo ERRO ^> "%TEMP%\ps7_status.txt" >> "%TEMP%\install_ps7.bat"
echo ) >> "%TEMP%\install_ps7.bat"
echo pause >> "%TEMP%\install_ps7.bat"

start "Instalação PowerShell 7.5" "%TEMP%\install_ps7.bat"

echo [AGUARDANDO] Instalação em andamento na nova janela...

:wait_ps7
timeout /t 3 >nul
if exist "%TEMP%\ps7_status.txt" (
    set /p status=<"%TEMP%\ps7_status.txt"
    del "%TEMP%\ps7_status.txt" 2>nul
    del "%TEMP%\install_ps7.bat" 2>nul
    if "!status!"=="OK" (
        echo [OK] PowerShell 7.5 instalado com sucesso!
        echo [INFO] Reinicie o terminal para usar PowerShell 7.5
    ) else (
        echo [ERRO] Falha na instalação do PowerShell 7.5
    )
) else (
    goto :wait_ps7
)
goto :eof

REM ==========================================
REM FUNÇÃO: Instalar Python
REM ==========================================
:install_python
echo.
echo ========================================
echo  INSTALANDO PYTHON
echo ========================================
echo.

echo [INFO] Abrindo janela para escolher e instalar Python...

REM Criar script PowerShell para Python
echo Write-Host "========================================" > "%TEMP%\install_python.ps1"
echo Write-Host " INSTALADOR DE PYTHON" >> "%TEMP%\install_python.ps1"
echo Write-Host "========================================" >> "%TEMP%\install_python.ps1"
echo Write-Host "" >> "%TEMP%\install_python.ps1"
echo Write-Host "Versões disponíveis:" >> "%TEMP%\install_python.ps1"
echo Write-Host "1. Python 3.12" >> "%TEMP%\install_python.ps1"
echo Write-Host "2. Python 3.11" >> "%TEMP%\install_python.ps1"
echo Write-Host "3. Python 3.10" >> "%TEMP%\install_python.ps1"
echo Write-Host "" >> "%TEMP%\install_python.ps1"
echo do { >> "%TEMP%\install_python.ps1"
echo     $choice = Read-Host "Digite o número (1-3)" >> "%TEMP%\install_python.ps1"
echo } while ($choice -notmatch "^[1-3]$") >> "%TEMP%\install_python.ps1"
echo $versions = @("Python.Python.3.12", "Python.Python.3.11", "Python.Python.3.10") >> "%TEMP%\install_python.ps1"
echo $selected = $versions[[int]$choice - 1] >> "%TEMP%\install_python.ps1"
echo Write-Host "Instalando $selected..." >> "%TEMP%\install_python.ps1"
echo try { >> "%TEMP%\install_python.ps1"
echo     winget install $selected --accept-package-agreements --accept-source-agreements --silent >> "%TEMP%\install_python.ps1"
echo     if ($LASTEXITCODE -eq 0) { >> "%TEMP%\install_python.ps1"
echo         "OK" ^| Out-File -FilePath "$env:TEMP\python_status.txt" >> "%TEMP%\install_python.ps1"
echo         Write-Host "Python instalado com sucesso!" >> "%TEMP%\install_python.ps1"
echo     } else { >> "%TEMP%\install_python.ps1"
echo         "ERRO" ^| Out-File -FilePath "$env:TEMP\python_status.txt" >> "%TEMP%\install_python.ps1"
echo         Write-Host "Erro na instalação" >> "%TEMP%\install_python.ps1"
echo     } >> "%TEMP%\install_python.ps1"
echo } catch { >> "%TEMP%\install_python.ps1"
echo     "ERRO" ^| Out-File -FilePath "$env:TEMP\python_status.txt" >> "%TEMP%\install_python.ps1"
echo     Write-Host "Erro: $_" >> "%TEMP%\install_python.ps1"
echo } >> "%TEMP%\install_python.ps1"
echo Read-Host "Pressione Enter para fechar" >> "%TEMP%\install_python.ps1"

REM Criar script BAT que chama o PowerShell
echo @echo off > "%TEMP%\install_python.bat"
echo powershell -ExecutionPolicy Bypass -File "%TEMP%\install_python.ps1" >> "%TEMP%\install_python.bat"

start "Instalação Python" "%TEMP%\install_python.bat"

echo [AGUARDANDO] Escolha e instalação em andamento na nova janela...

:wait_python
timeout /t 3 >nul
if exist "%TEMP%\python_status.txt" (
    set /p status=<"%TEMP%\python_status.txt"
    del "%TEMP%\python_status.txt" 2>nul
    del "%TEMP%\install_python.ps1" 2>nul
    del "%TEMP%\install_python.bat" 2>nul
    if "!status!"=="OK" (
        echo [OK] Python instalado com sucesso!
    ) else (
        echo [ERRO] Falha na instalação do Python
    )
) else (
    goto :wait_python
)
goto :eof

REM ==========================================
REM FUNÇÃO: Instalar tudo sequencialmente
REM ==========================================
:install_all
echo.
echo ========================================
echo  INSTALAÇÃO COMPLETA - SEQUENCIAL
echo ========================================
echo.

echo [1/3] Instalando App Installer...
call :install_app_installer

echo.
echo [2/3] Instalando PowerShell 7.5...
call :install_powershell

echo.
echo [3/3] Instalando Python...
call :install_python

echo.
echo [OK] Processo completo finalizado!
goto :eof

REM ==========================================
REM FUNÇÃO: Verificar status
REM ==========================================
:check_status
echo.
echo ========================================
echo  STATUS DAS INSTALAÇÕES
echo ========================================
echo.

REM Verificar winget
winget --version >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] App Installer (winget): Instalado
) else (
    echo [X] App Installer (winget): NÃO instalado
)

REM Verificar PowerShell 7
pwsh -Command "exit 0" >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] PowerShell 7.5: Instalado
) else (
    echo [X] PowerShell 7.5: NÃO instalado
)

REM Verificar Python
python --version >nul 2>&1
if %errorLevel% equ 0 (
    for /f "delims=" %%v in ('python --version 2^>^&1') do echo [OK] Python: %%v
) else (
    echo [X] Python: NÃO encontrado
)

echo.
goto :eof

REM ==========================================
REM SAÍDA CONTROLADA
REM ==========================================
:exit_script
echo.
echo ========================================
echo  SAINDO DO INSTALADOR
echo ========================================
echo.
echo Obrigado por usar o instalador automático!
echo.
pause
exit /b 0