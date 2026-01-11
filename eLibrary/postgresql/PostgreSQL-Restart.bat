@echo off
chcp 65001 > nul 2>&1
setlocal enabledelayedexpansion

if not exist "%CD%\cluster_name.txt" (
    echo El archivo 'cluster_name.txt' no existe. No se puede reiniciar el cluster.
    pause
    exit /b
)

set /P "NombreCluster="<"%CD%\cluster_name.txt"

rem Elimina espacios en blanco al principio del nombre del cluster
set "NombreCluster=!NombreCluster: =!"

set "RutaCluster=%CD%\%NombreCluster%"

if not exist "%RutaCluster%" (
    echo El directorio del cluster '%NombreCluster%' no existe. El cluster no puede ser reiniciado.
    pause
    exit /b
)

REM Verificar si el servidor PostgreSQL está en ejecución
tasklist /FI "IMAGENAME eq postgres.exe" 2>NUL | find /I "postgres.exe" >NUL
if errorlevel 1 (
    echo El servidor PostgreSQL no está en ejecución.
    pause
    exit /b
)

REM Reinicio del clúster
"%CD%\bin\pg_ctl" restart -D "%RutaCluster%"
