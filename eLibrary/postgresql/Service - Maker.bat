@ECHO OFF
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"


if not exist "%CD%\cluster_name.txt" (
    echo El archivo 'cluster_name.txt' no existe. No se puede iniciar el cluster.
    pause
    exit /b
)


set /P "NombreCluster="<"%CD%\cluster_name.txt"

rem Elimina espacios en blanco al principio del nombre del cluster
set "NombreCluster=!NombreCluster: =!"

set "RutaCluster=%CD%\%NombreCluster%"

if not exist "%RutaCluster%" (
    echo El directorio del cluster '%NombreCluster%' no existe. El cluster no puede ser iniciado.
    pause
    exit /b
)

SET /P Servicio=Enter the new name of the PostgreSQL Windows service: 
"%CD%\bin\pg_ctl.exe" register -N "%Servicio%" -D "%CD%\data"
pause