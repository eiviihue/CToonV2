@echo off
REM CToon Maven Build Script - Windows
REM Builds the project locally before deployment

echo.
echo ========================================
echo  CToon Maven Build
echo ========================================
echo.

REM Check if Maven is installed
mvn --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo ✗ Maven is not installed or not in PATH
    echo Please install Maven from https://maven.apache.org/
    echo Or add Maven bin directory to your PATH
    echo.
    pause
    exit /b 1
)

REM Check if Java is installed
java -version >nul 2>&1
if errorlevel 1 (
    echo.
    echo ✗ Java is not installed or not in PATH
    echo Please install Java 11+ from https://www.oracle.com/java/
    echo.
    pause
    exit /b 1
)

echo Building CToon with Maven...
echo Compiling source code and packaging WAR file...
echo.

REM Build with Maven (show key output, skip tests for faster builds)
mvn clean package -DskipTests

if errorlevel 1 (
    echo.
    echo ========================================
    echo ✗ Build FAILED
    echo ========================================
    echo.
    echo Please check the error messages above
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo ✓ Build SUCCESSFUL!
echo ========================================
echo.
echo Output: target\ctoon-1.0-SNAPSHOT.war
echo.
echo Next steps:
echo   1. Docker build: docker build -t ctoon:latest .
echo   2. Docker run:   docker run -p 8080:8080 ctoon:latest
echo.
pause
exit /b 0
