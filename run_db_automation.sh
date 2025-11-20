#!/bin/bash

# CToon Database Automation Script for Linux/Mac
# Requires Python 3 and mysql-connector-python

echo ""
echo "========================================"
echo "CToon Database Automation Setup"
echo "========================================"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed"
    echo "Please install Python 3 first:"
    echo "  Ubuntu/Debian: sudo apt-get install python3 python3-pip"
    echo "  Mac: brew install python3"
    exit 1
fi

echo "Checking for required Python packages..."
python3 -m pip show mysql-connector-python > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Installing mysql-connector-python..."
    python3 -m pip install mysql-connector-python
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install mysql-connector-python"
        exit 1
    fi
fi

echo ""
echo "========================================"
echo "Running Database Population Script"
echo "========================================"
echo ""

if [ "$1" = "--status" ]; then
    python3 populate_database.py --status
elif [ "$1" = "--help" ]; then
    echo "Usage: ./run_db_automation.sh [options]"
    echo ""
    echo "Options:"
    echo "  (none)     Populate database from assets"
    echo "  --status   Show database status"
    echo "  --help     Show this help message"
else
    python3 populate_database.py
fi

echo ""
