@echo off
chcp 65001 > nul 2>&1
setlocal enabledelayedexpansion

if not exist "%CD%\cluster_name.txt" (
    echo El archivo 'cluster_name.txt' no existe. No se puede detener el cluster.
    pause
    exit /b
)

set /P "NombreCluster="<"%CD%\cluster_name.txt"

rem Elimina espacios en blanco al principio del nombre del cluster
set "NombreCluster=!NombreCluster: =!"

set "RutaCluster=%CD%\%NombreCluster%"

if not exist "%RutaCluster%" (
    echo El directorio del cluster '%NombreCluster%' no existe. El cluster no puede ser detenido.
    pause
    exit /b
)

REM Detención del clúster
"%CD%\bin\pg_ctl" stop -D "%RutaCluster%"
