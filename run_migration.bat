@echo off
REM CToon Database Migration - Windows

echo.
echo ========================================
echo  CToon Database Migration
echo ========================================
echo.

python --version >nul 2>&1
if errorlevel 1 (
    echo ✗ Python is not installed
    pause
    exit /b 1
)

python -c "import mysql.connector" >nul 2>&1
if errorlevel 1 (
    echo ⚠ Installing mysql-connector-python...
    pip install mysql-connector-python -q
    if errorlevel 1 (
        echo ✗ Failed to install mysql-connector-python
        pause
        exit /b 1
    )
)

echo Running migration...
python run_migration.py

if errorlevel 1 (
    echo ✗ Migration failed
    pause
    exit /b 1
) else (
    echo ✓ Success
    pause
    exit /b 0
)
