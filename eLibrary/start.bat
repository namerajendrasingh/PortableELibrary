@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"
set PGDATA=%CD%\data\pgdata
set PGPORT=5412
set PG_BIN=%CD%\postgresql\bin
set JAR_PATH=%CD%\e-Library.jar

echo ========================================
echo    eLibrary Portable - Production Ready
echo ========================================

REM CREATE BACKUPS FOLDER
if not exist "%CD%\backups" mkdir "%CD%\backups"

REM START PG SERVER FIRST
call :ensure_postgresql_running
if !ERRORLEVEL! neq 0 (
    echo PostgreSQL failed to start. Check postgresql.log
    pause
    exit /b 1
)

REM CHECK/RESTORE/CREATE DATABASE
call :ensure_database_ready
if !ERRORLEVEL! neq 0 (
    echo Database setup failed
    pause
    goto :stop_postgresql
)

REM CREATE DAILY BACKUP
call :create_daily_backup

REM LAUNCH APP
echo.
echo ========================================
echo [SUCCESS] e-Library ready! Port: 5412
echo ========================================
echo JDBC: jdbc:postgresql://localhost:5412/elibrary?user=postgres^&password=
echo Data: %PGDATA%
start "" "%CD%\jre\bin\javaw.exe" -jar "%JAR_PATH%"

echo Server running... Close this window to stop
pause
goto :stop_postgresql

:ensure_postgresql_running
if exist "%PGDATA%\postgresql.conf" (
    echo Starting existing PostgreSQL...
    "%PG_BIN%\pg_ctl.exe" -D "%PGDATA%" -l "%CD%\postgresql.log" -o "-p %PGPORT% -F -i" start
    timeout /t 3 /nobreak >nul
) else (
    echo [1/4] Creating new database cluster...
    "%PG_BIN%\initdb.exe" -D "%PGDATA%" -U postgres -A trust --encoding=UTF8
    "%PG_BIN%\pg_ctl.exe" -D "%PGDATA%" -l "%CD%\postgresql.log" -o "-p %PGPORT% -F -i" start
    timeout /t 5 /nobreak >nul
)
"%PG_BIN%\pg_isready.exe" -h localhost -p %PGPORT% >nul
exit /b !ERRORLEVEL!

:ensure_database_ready
REM Check if elibrary exists
"%PG_BIN%\psql.exe" -h localhost -p %PGPORT% -U postgres -d postgres -t -c "SELECT 1 FROM pg_database WHERE datname='elibrary'" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    echo [OK] elibrary database exists ^(live data ready^)
    exit /b 0
)

REM Database missing - CREATE
echo [2/4] elibrary missing - creating new database...
"%PG_BIN%\createdb.exe" -h localhost -p %PGPORT% -U postgres elibrary

REM Try latest backup from backups/ FIRST
set "LATEST_BACKUP="
for /f "delims=" %%f in ('dir /b /od "%CD%\backups\backup_*.sql" 2^>nul') do set "LATEST_BACKUP=%%f"

if defined LATEST_BACKUP (
    echo [3/4] Restoring latest backup: !LATEST_BACKUP!
    "%PG_BIN%\psql.exe" -h localhost -p %PGPORT% -U postgres -d elibrary -f "%CD%\backups\!LATEST_BACKUP!"
    if !ERRORLEVEL! equ 0 (
        echo [OK] Latest backup restored
        exit /b 0
    )
)

REM Fallback to initial schema
if exist "%CD%\data\elibrary.sql" (
    echo [3/4] Loading initial schema: elibraray.sql
    "%PG_BIN%\psql.exe" -h localhost -p %PGPORT% -U postgres -d elibrary -f "%CD%\data\elibrary.sql"
    exit /b !ERRORLEVEL!
)

echo [ERROR] No restore files found
exit /b 1

:create_daily_backup
echo [4/4] Creating daily backup...
for /f "tokens=2 delims==" %%i in ('wmic OS Get localdatetime /value') do set "datetime=%%i"
set "YYYY=!datetime:~0,4!"
set "MM=!datetime:~4,2!"
set "DD=!datetime:~6,2!"
set "backupfile=%CD%\backups\backup_!YYYY!!MM!!DD!.sql"
"%PG_BIN%\pg_dump.exe" -h localhost -p %PGPORT% -U postgres -d elibrary --no-owner --no-privileges -f "!backupfile!"
echo Backup saved: !backupfile!
exit /b 0

:stop_postgresql
"%PG_BIN%\pg_ctl.exe" -D "%PGDATA%" -m fast stop
echo.
echo ========================================
echo Data LIVE in:     %PGDATA%
echo Backups stored in:%CD%\backups\
echo ========================================
pause
