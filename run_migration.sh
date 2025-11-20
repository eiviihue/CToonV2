#!/bin/bash
# CToon Database Migration - Linux/Mac

echo ""
echo "========================================"
echo " CToon Database Migration"
echo "========================================"
echo ""

if ! command -v python3 &> /dev/null; then
    echo "✗ Python3 is not installed"
    exit 1
fi

if ! python3 -c "import mysql.connector" &> /dev/null; then
    echo "⚠ Installing mysql-connector-python..."
    pip3 install mysql-connector-python -q
    if [ $? -ne 0 ]; then
        echo "✗ Failed to install mysql-connector-python"
        exit 1
    fi
fi

echo "Running migration..."
python3 run_migration.py

if [ $? -eq 0 ]; then
    echo "✓ Success"
    exit 0
else
    echo "✗ Migration failed"
    exit 1
fi
