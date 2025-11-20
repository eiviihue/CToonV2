#!/usr/bin/env python3
"""Run a single SQL file against Railway DB"""
import mysql.connector
import sys
import os

DB_CONFIG = {
    'host': 'shinkansen.proxy.rlwy.net',
    'port': 54128,
    'user': 'root',
    'password': 'oRsqyOGrDWrBUBLYeGBxajubkknNXcuu',
    'database': 'railway'
}

SQL_FILE = 'create_pages_fixed.sql'


def run_file(path):
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        print("✓ Connected to Railway database\n")

        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()

        statements = [s.strip() for s in content.split(';') if s.strip()]
        for i, stmt in enumerate(statements, 1):
            try:
                cursor.execute(stmt)
                conn.commit()
                print(f"✓ Executed statement {i}/{len(statements)}")
            except mysql.connector.Error as e:
                print(f"✗ Statement {i} error: {e}")
                conn.rollback()
            except Exception as e:
                print(f"✗ Statement {i} error: {e}")
                conn.rollback()

        cursor.close()
        conn.close()
        print("\n✓ Done")
        return True
    except Exception as err:
        print(f"✗ Failed to run SQL file: {err}")
        return False


if __name__ == '__main__':
    script_dir = os.path.dirname(os.path.abspath(__file__))
    sql_path = os.path.join(script_dir, SQL_FILE)
    if not os.path.exists(sql_path):
        print(f"✗ SQL file not found: {sql_path}")
        sys.exit(1)
    ok = run_file(sql_path)
    sys.exit(0 if ok else 1)
