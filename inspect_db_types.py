#!/usr/bin/env python3
import mysql.connector, os
DB_CONFIG = {
    'host': 'shinkansen.proxy.rlwy.net',
    'port': 54128,
    'user': 'root',
    'password': 'oRsqyOGrDWrBUBLYeGBxajubkknNXcuu',
    'database': 'railway'
}

def show(table):
    conn = mysql.connector.connect(**DB_CONFIG)
    cur = conn.cursor()
    cur.execute("SELECT COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_KEY FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA=%s AND TABLE_NAME=%s", (DB_CONFIG['database'], table))
    rows = cur.fetchall()
    print(f"\nTable: {table}")
    for r in rows:
        print(f"  {r[0]}: {r[1]}, nullable={r[2]}, key={r[3]}")
    cur.close(); conn.close()

if __name__ == '__main__':
    for t in ['users','chapters','pages','covers','profiles']:
        try:
            show(t)
        except Exception as e:
            print(f"Error reading {t}: {e}")
