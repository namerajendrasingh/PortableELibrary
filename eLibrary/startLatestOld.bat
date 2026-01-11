@echo off
cd /d "%~dp0"
set PGDATA=%CD%\data\pgdata
set PGPORT=5412
set PG_BIN=%CD%\postgresql\bin
set JAR_PATH=%CD%\e-Library.jar

echo === eLibrary Portable (Data Safe) ===

REM Verify JAR exists
if not exist "%JAR_PATH%" (
    echo ERROR: e-Library.jar not found!
    dir *.jar
    pause
    exit /b 1
)

REM CHECK IF PG SERVER ALREADY RUNNING
"%PG_BIN%\pg_isready.exe" -h localhost -p %PGPORT% >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo PostgreSQL already running on port %PGPORT%...
    goto :launch_app
)

REM FIRST TIME OR RESTART - CHECK CLUSTER VALIDITY
if exist "%PGDATA%\postgresql.conf" (
    echo Found existing database cluster, starting...
    "%PG_BIN%\pg_ctl.exe" -D "%PGDATA%" -l "%CD%\postgresql.log" -o "-p %PGPORT%" start
    timeout /t 3 /nobreak >nul
) else (
    echo [1/4] FIRST TIME: Creating database cluster...
    "%PG_BIN%\initdb.exe" -D "%PGDATA%" -U postgres --locale=C --encoding=UTF8 -A trust
    "%PG_BIN%\pg_ctl.exe" -D "%PGDATA%" -l "%CD%\postgresql.log" -o "-p %PGPORT%" start
    timeout /t 5 /nobreak >nul
    
    echo [2/4] Creating elibrary database...
    "%PG_BIN%\createdb.exe" -h localhost -p %PGPORT% -U postgres elibrary
    
    echo [3/4] Loading initial schema...
    if exist "%CD%\data\elibrary.sql" (
        "%PG_BIN%\psql.exe" -h localhost -p %PGPORT% -U postgres -d elibrary -f "%CD%\data\elibrary.sql"
    )
)

REM VERIFY DATABASE EXISTS
"%PG_BIN%\psql.exe" -h localhost -p %PGPORT% -U postgres -d postgres -t -c "SELECT 1 FROM pg_database WHERE datname='elibrary'"

REM === AUTO-BACKUP BEFORE APP LAUNCH ===
echo Creating daily backup...
for /f "tokens=2 delims==" %%i in ('wmic OS Get localdatetime /value') do set datetime=%%i
set YYYY=%datetime:~0,4%
set MM=%datetime:~4,2%
set DD=%datetime:~6,2%
set backupfile=%CD%\data\backup_%YYYY%%MM%%DD%.sql
"%PG_BIN%\pg_dump.exe" -h localhost -p %PGPORT% -U postgres -d elibrary -f "%backupfile%"
echo Backup saved: %backupfile%

:launch_app
echo [LAUNCH] Starting e-Library.jar (Data preserved in %PGDATA%)...
"%CD%\jre\bin\javaw.exe" -jar "%JAR_PATH%"

:stop_server
echo.
choice /c YN /m "Stop PostgreSQL and exit? (Y/N)"
if errorlevel 2 exit /b 0
"%PG_BIN%\pg_ctl.exe" -D "%PGDATA%" stop
echo Data safely preserved in data/pgdata/
pause
