@echo off
REM CToon Database Automation Script for Windows
REM Requires Python 3 and mysql-connector-python

echo.
echo ========================================
echo CToon Database Automation Setup
echo ========================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Python is not installed or not in PATH
    echo Please install Python 3 from https://www.python.org/
    pause
    exit /b 1
)

echo Checking for required Python packages...
python -m pip show mysql-connector-python >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing mysql-connector-python...
    python -m pip install mysql-connector-python
    if %errorlevel% neq 0 (
        echo Error: Failed to install mysql-connector-python
        pause
        exit /b 1
    )
)

echo.
echo ========================================
echo Running Database Population Script
echo ========================================
echo.

if "%1"=="--status" (
    python populate_database.py --status
) else if "%1"=="--help" (
    echo Usage: run_db_automation.bat [options]
    echo.
    echo Options:
    echo   (none)     Populate database from assets
    echo   --status   Show database status
    echo   --help     Show this help message
) else (
    python populate_database.py
)

echo.
pause
