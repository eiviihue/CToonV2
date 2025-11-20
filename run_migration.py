#!/usr/bin/env python3
"""Execute database migration on Railway MySQL"""

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

def run_migration():
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        print("✓ Connected to Railway database\n")
        
        # Read migration SQL
        script_dir = os.path.dirname(os.path.abspath(__file__))
        sql_file = os.path.join(script_dir, 'database_migration.sql')
        
        if not os.path.exists(sql_file):
            print(f"✗ Migration file not found: {sql_file}")
            return False
        
        with open(sql_file, 'r', encoding='utf-8') as f:
            sql_content = f.read()
        
        # Split by semicolon and execute each statement
        statements = [s.strip() for s in sql_content.split(';') if s.strip()]
        
        executed = 0
        for i, statement in enumerate(statements):
            try:
                cursor.execute(statement)
                conn.commit()
                executed += 1
                print(f"✓ Executed statement {executed}/{len(statements)}")
            except mysql.connector.Error as e:
                if e.errno == 1050:  # Table already exists
                    print(f"⚠ Table already exists (skipping)")
                else:
                    print(f"✗ Error: {e}")
                conn.rollback()
            except Exception as e:
                print(f"✗ Error: {e}")
                conn.rollback()
        
        cursor.close()
        conn.close()
        
        print(f"\n{'='*50}")
        print(f"✓ Migration complete!")
        print(f"{'='*50}\n")
        return True
        
    except Exception as err:
        print(f"✗ Migration failed: {err}\n")
        return False

if __name__ == '__main__':
    success = run_migration()
    sys.exit(0 if success else 1)
