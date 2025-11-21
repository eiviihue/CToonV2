#!/bin/bash
# CToon Maven Build Script - Linux/Mac
# Builds the project locally before deployment

echo ""
echo "========================================"
echo "  CToon Maven Build"
echo "========================================"
echo ""

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo ""
    echo "✗ Maven is not installed or not in PATH"
    echo "Please install Maven from https://maven.apache.org/"
    echo "Or add Maven bin directory to your PATH"
    echo ""
    exit 1
fi

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo ""
    echo "✗ Java is not installed or not in PATH"
    echo "Please install Java 11+ from https://www.oracle.com/java/"
    echo ""
    exit 1
fi

echo "Building CToon with Maven..."
echo "Compiling source code and packaging WAR file..."
echo ""

# Build with Maven (skip tests for faster builds)
mvn clean package -DskipTests

if [ $? -ne 0 ]; then
    echo ""
    echo "========================================"
    echo "✗ Build FAILED"
    echo "========================================"
    echo ""
    echo "Please check the error messages above"
    echo ""
    exit 1
fi

echo ""
echo "========================================"
echo "✓ Build SUCCESSFUL!"
echo "========================================"
echo ""
echo "Output: target/ctoon-1.0-SNAPSHOT.war"
echo ""
echo "Next steps:"
echo "   1. Docker build: docker build -t ctoon:latest ."
echo "   2. Docker run:   docker run -p 8080:8080 ctoon:latest"
echo ""
exit 0
