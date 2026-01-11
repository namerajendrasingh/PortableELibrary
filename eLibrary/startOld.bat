@echo off
cd /d "%~dp0"
set PGDATA=%CD%\data\pgdata
set PGPORT=5412
set PG_BIN=%CD%\postgresql\bin

echo === eLibrary Portable Startup ===

REM Verify binaries exist
if not exist "%PG_BIN%\initdb.exe" (
    echo ERROR: initdb.exe missing! Re-download PostgreSQL portable ZIP
    pause
    exit /b 1
)

REM Clean start - always delete old data
if exist "%PGDATA%" (
    echo Removing old database cluster...
    rmdir /s /q "%PGDATA%"
)

REM CREATE FRESH DATABASE CLUSTER
echo [1/5] Creating database cluster...
"%PG_BIN%\initdb.exe" -D "%PGDATA%" -U postgres --locale=C --encoding=UTF8 -A trust -N -E UTF8
if %ERRORLEVEL% neq 0 (
    echo initdb FAILED. Check postgresql.log
    pause
    exit /b 1
)

REM Start server
echo [2/5] Starting PostgreSQL...
"%PG_BIN%\pg_ctl.exe" -D "%PGDATA%" -l "%CD%\postgresql.log" -o "-p %PGPORT%" start
timeout /t 6 /nobreak >nul

REM Verify server running
"%PG_BIN%\pg_isready.exe" -h localhost -p %PGPORT%
if %ERRORLEVEL% neq 0 (
    echo Server not ready! Check postgresql.log
    "%PG_BIN%\pg_ctl.exe" -D "%PGDATA%" stop
    pause
    exit /b 1
)

REM Create database
echo [3/5] Creating 'elibrary' database...
"%PG_BIN%\createdb.exe" -h localhost -p %PGPORT% -U postgres elibrary
if %ERRORLEVEL% neq 0 (
    echo createdb FAILED
    goto :stop_server
)

REM Load schema
echo [4/5] Loading elibraray.sql...
"%PG_BIN%\psql.exe" -h localhost -p %PGPORT% -U postgres -d elibrary -f "%CD%\data\elibrary.sql"
if %ERRORLEVEL% neq 0 (
    echo SQL load FAILED - empty DB created
)

echo [5/5] Database ready! Launching app...
"%CD%\jre\bin\javaw.exe" -jar "e-Library.jar"
goto :stop_server

:stop_server
"%PG_BIN%\pg_ctl.exe" -D "%PGDATA%" stop
pause
