@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul

set "SCRIPT_VERSION=2.0.0"
set "DEFAULT_TIMEOUT_SECONDS=1800"
set "STATUS_TIMEOUT_SECONDS=%DEFAULT_TIMEOUT_SECONDS%"

if defined INSTALL_TIMEOUT_SECONDS (
  set /a STATUS_TIMEOUT_SECONDS=INSTALL_TIMEOUT_SECONDS 2>nul
  if !STATUS_TIMEOUT_SECONDS! LEQ 0 set "STATUS_TIMEOUT_SECONDS=%DEFAULT_TIMEOUT_SECONDS%"
)

:main_loop
cls
echo ========================================
echo  INSTALADOR AUTOMATICO - JANELA IMORTAL
echo ========================================
echo  Versao: %SCRIPT_VERSION%
echo  Esta janela nao fecha automaticamente.
echo ========================================
echo.

call :ensure_admin
if errorlevel 1 goto :main_loop

echo MENU PRINCIPAL:
echo.
echo 1. Instalar App Installer (winget)
echo 2. Instalar PowerShell 7
echo 3. Instalar Python
echo 4. Instalar TUDO (sequencial)
echo 5. Verificar status das instalacoes
echo 6. Sair
echo.
choice /c 123456 /n /m "Digite sua escolha (1-6): "
if errorlevel 6 goto :exit_script
if errorlevel 5 call :check_status & goto :return_menu
if errorlevel 4 call :install_all & goto :return_menu
if errorlevel 3 call :install_python & goto :return_menu
if errorlevel 2 call :install_powershell & goto :return_menu
if errorlevel 1 call :install_app_installer & goto :return_menu

:return_menu
echo.
echo Pressione qualquer tecla para voltar ao menu principal...
pause >nul
goto :main_loop

:ensure_admin
net session >nul 2>&1
if %errorLevel% neq 0 (
  echo [ERRO] Este script precisa ser executado como Administrador.
  echo        Clique com o botao direito no arquivo e selecione "Executar como administrador".
  echo.
  pause
  exit /b 1
)
exit /b 0

:install_app_installer
echo.
echo ========================================
echo  INSTALANDO APP INSTALLER
echo ========================================
echo.

winget --version >nul 2>&1
if %errorLevel% equ 0 (
  echo [OK] App Installer ja esta instalado.
  goto :eof
)

set "status_file=%TEMP%\winget_status_%RANDOM%.txt"
set "task_script=%TEMP%\install_winget_%RANDOM%.bat"

(
  echo @echo off
  echo echo Instalando App Installer...
  echo powershell -NoProfile -Command "try { Invoke-WebRequest -Uri 'https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle' -OutFile '$env:TEMP\winget.msixbundle'; Add-AppxPackage '$env:TEMP\winget.msixbundle'; Set-Content -Path '%status_file%' -Value 'OK' } catch { Set-Content -Path '%status_file%' -Value 'ERRO' }"
  echo pause
) > "%task_script%"

echo [INFO] Abrindo janela para instalar App Installer...
start "Instalacao App Installer" "%task_script%"

call :wait_for_status "%status_file%" "App Installer"
del "%task_script%" 2>nul
if /I "!last_status!"=="OK" (
  echo [OK] App Installer instalado com sucesso.
) else (
  echo [ERRO] Falha na instalacao do App Installer.
)
goto :eof

:install_powershell
echo.
echo ========================================
echo  INSTALANDO POWERSHELL 7
echo ========================================
echo.

where pwsh >nul 2>&1
if %errorLevel% equ 0 (
  echo [OK] PowerShell 7 ja esta instalado.
  goto :eof
)

winget --version >nul 2>&1
if %errorLevel% neq 0 (
  echo [INFO] winget nao encontrado. Iniciando instalacao do App Installer primeiro...
  call :install_app_installer
)

set "status_file=%TEMP%\ps7_status_%RANDOM%.txt"
set "task_script=%TEMP%\install_ps7_%RANDOM%.bat"

(
  echo @echo off
  echo echo Instalando PowerShell 7...
  echo winget install Microsoft.PowerShell --accept-package-agreements --accept-source-agreements --silent
  echo if %%errorlevel%% equ 0 ^(
  echo   echo OK ^> "%status_file%"
  echo ^) else ^(
  echo   echo ERRO ^> "%status_file%"
  echo ^)
  echo pause
) > "%task_script%"

echo [INFO] Abrindo janela para instalar PowerShell 7...
start "Instalacao PowerShell 7" "%task_script%"

call :wait_for_status "%status_file%" "PowerShell 7"
del "%task_script%" 2>nul
if /I "!last_status!"=="OK" (
  echo [OK] PowerShell 7 instalado com sucesso.
  echo [INFO] Reinicie o terminal para atualizar o PATH se necessario.
) else (
  echo [ERRO] Falha na instalacao do PowerShell 7.
)
goto :eof

:install_python
echo.
echo ========================================
echo  INSTALANDO PYTHON
echo ========================================
echo.

winget --version >nul 2>&1
if %errorLevel% neq 0 (
  echo [INFO] winget nao encontrado. Iniciando instalacao do App Installer primeiro...
  call :install_app_installer
)

set "status_file=%TEMP%\python_status_%RANDOM%.txt"
set "ps_script=%TEMP%\install_python_%RANDOM%.ps1"

echo Write-Host "========================================" > "%ps_script%"
echo Write-Host " INSTALADOR DE PYTHON" >> "%ps_script%"
echo Write-Host "========================================" >> "%ps_script%"
echo Write-Host "" >> "%ps_script%"
echo Write-Host "Versoes disponiveis:" >> "%ps_script%"
echo Write-Host "1. Python 3.12" >> "%ps_script%"
echo Write-Host "2. Python 3.11" >> "%ps_script%"
echo Write-Host "3. Python 3.10" >> "%ps_script%"
echo Write-Host "" >> "%ps_script%"
echo do { >> "%ps_script%"
echo   $choice = Read-Host "Digite o numero (1-3)" >> "%ps_script%"
echo } while ($choice -notmatch "^[1-3]$") >> "%ps_script%"
echo $versions = @("Python.Python.3.12", "Python.Python.3.11", "Python.Python.3.10") >> "%ps_script%"
echo $selected = $versions[[int]$choice - 1] >> "%ps_script%"
echo Write-Host "Instalando $selected..." >> "%ps_script%"
echo try { >> "%ps_script%"
echo   winget install $selected --accept-package-agreements --accept-source-agreements --silent >> "%ps_script%"
echo   if ($LASTEXITCODE -eq 0) { >> "%ps_script%"
echo     Set-Content -Path "%status_file%" -Value "OK" >> "%ps_script%"
echo     Write-Host "Python instalado com sucesso!" >> "%ps_script%"
echo   } else { >> "%ps_script%"
echo     Set-Content -Path "%status_file%" -Value "ERRO" >> "%ps_script%"
echo     Write-Host "Falha na instalacao do Python." >> "%ps_script%"
echo   } >> "%ps_script%"
echo } catch { >> "%ps_script%"
echo   Set-Content -Path "%status_file%" -Value "ERRO" >> "%ps_script%"
echo   Write-Host "Erro: $($_.Exception.Message)" >> "%ps_script%"
echo } >> "%ps_script%"
echo Read-Host "Pressione Enter para fechar" >> "%ps_script%"

echo [INFO] Abrindo janela para escolher e instalar Python...
start "Instalacao Python" powershell -NoProfile -ExecutionPolicy Bypass -File "%ps_script%"

call :wait_for_status "%status_file%" "Python"
del "%ps_script%" 2>nul
if /I "!last_status!"=="OK" (
  echo [OK] Python instalado com sucesso.
) else (
  echo [ERRO] Falha na instalacao do Python.
)
goto :eof

:install_all
echo.
echo ========================================
echo  INSTALACAO COMPLETA - SEQUENCIAL
echo ========================================
echo.
echo [1/3] Instalando App Installer...
call :install_app_installer
echo.
echo [2/3] Instalando PowerShell 7...
call :install_powershell
echo.
echo [3/3] Instalando Python...
call :install_python
echo.
echo [OK] Processo completo finalizado.
goto :eof

:check_status
echo.
echo ========================================
echo  STATUS DAS INSTALACOES
echo ========================================
echo.

winget --version >nul 2>&1
if %errorLevel% equ 0 (
  for /f "delims=" %%v in ('winget --version 2^>^&1') do echo [OK] App Installer ^(winget^): %%v
) else (
  echo [X] App Installer ^(winget^): NAO instalado
)

where pwsh >nul 2>&1
if %errorLevel% equ 0 (
  for /f "delims=" %%v in ('pwsh --version 2^>^&1') do echo [OK] PowerShell: %%v
) else (
  echo [X] PowerShell 7: NAO instalado
)

py --version >nul 2>&1
if %errorLevel% equ 0 (
  for /f "delims=" %%v in ('py --version 2^>^&1') do echo [OK] Python: %%v
) else (
  python --version >nul 2>&1
  if %errorLevel% equ 0 (
    for /f "delims=" %%v in ('python --version 2^>^&1') do echo [OK] Python: %%v
  ) else (
    echo [X] Python: NAO encontrado
  )
)
goto :eof

:wait_for_status
set "status_path=%~1"
set "task_label=%~2"
set "last_status="
set /a elapsed=0

:wait_loop
if exist "%status_path%" (
  set /p "last_status="<"%status_path%"
  del "%status_path%" 2>nul
  goto :eof
)
timeout /t 2 >nul
set /a elapsed+=2
if !elapsed! geq %STATUS_TIMEOUT_SECONDS% (
  set "last_status=TIMEOUT"
  echo [ERRO] Timeout aguardando conclusao da tarefa: !task_label!.
  goto :eof
)
goto :wait_loop

:exit_script
echo.
echo ========================================
echo  SAINDO DO INSTALADOR
echo ========================================
echo.
echo Obrigado por usar o instalador automatico.
echo.
pause
exit /b 0
