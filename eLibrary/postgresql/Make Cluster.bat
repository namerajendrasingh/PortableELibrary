@echo off
chcp 65001 > nul 2>&1
setlocal enabledelayedexpansion

set "NombreCluster=data"
set /P "NombreCluster=Escriba el nombre del cluster (o presione Enter para usar 'data'): "

set "RutaCluster=%CD%\%NombreCluster%"

REM Verifica si el directorio del cluster ya existe
if exist "%RutaCluster%" (
    choice /M "El directorio del cluster ya existe. ¿Desea borrarlo y continuar?"
    if errorlevel 2 (
        echo El usuario eligió no borrar el directorio existente. Finalizando el script.
        pause
	exit /b
    ) else (
        echo Borrando el directorio existente...
        rmdir /s /q "%RutaCluster%"
    )
)

REM Creación del clúster
"%CD%\bin\initdb" -D "%RutaCluster%" -U postgres -W --encoding=UTF8

REM Guarda el nombre del cluster en un archivo de texto
echo %NombreCluster% > "%CD%\cluster_name.txt"

echo Clúster creado en '%RutaCluster%'.
pause