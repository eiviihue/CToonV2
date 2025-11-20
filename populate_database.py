#!/usr/bin/env python3
"""
CToon Database Automation Script
Scans comic assets directory and populates MySQL database automatically
"""

import os
import sys
import re
import mysql.connector
from pathlib import Path
from mysql.connector import errorcode

# Database Configuration
DB_CONFIG = {
    'host': 'shinkansen.proxy.rlwy.net',
    'port': 54128,
    'user': 'root',
    'password': 'oRsqyOGrDWrBUBLYeGBxajubkknNXcuu',
    'database': 'railway'
}

# Asset paths
COVERS_DIR = os.path.join(os.path.dirname(__file__), 'webapp/assets/covers')
COMICS_DIR = os.path.join(os.path.dirname(__file__), 'webapp/assets/comics')

class CToonDBAutomation:
    def __init__(self):
        self.conn = None
        self.cursor = None
        self.comics_data = {}
        
    def connect(self):
        """Connect to MySQL database"""
        try:
            self.conn = mysql.connector.connect(**DB_CONFIG)
            self.cursor = self.conn.cursor(dictionary=True)
            print("✓ Connected to MySQL database")
            return True
        except mysql.connector.Error as err:
            if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
                print("✗ Invalid username or password")
            elif err.errno == errorcode.ER_BAD_DB_ERROR:
                print("✗ Database does not exist")
            else:
                print(f"✗ Connection error: {err}")
            return False
    
    def disconnect(self):
        """Disconnect from database"""
        if self.cursor:
            self.cursor.close()
        if self.conn:
            self.conn.close()
        print("✓ Database connection closed")
    
    def scan_covers(self):
        """Scan covers directory and map to comic names"""
        if not os.path.exists(COVERS_DIR):
            print(f"✗ Covers directory not found: {COVERS_DIR}")
            return {}
        
        covers = {}
        for comic_dir in os.listdir(COVERS_DIR):
            comic_path = os.path.join(COVERS_DIR, comic_dir)
            if os.path.isdir(comic_path):
                # Convert folder name to comic name (Kimetsu-no-Yaiba -> Kimetsu no Yaiba)
                comic_name = comic_dir.replace('-', ' ')
                cover_files = [f for f in os.listdir(comic_path) if f.lower().endswith(('.png', '.jpg', '.jpeg'))]
                if cover_files:
                    covers[comic_name] = {
                        'dir': comic_dir,
                        'covers': cover_files,
                        'main_cover': f'/assets/covers/{comic_dir}/{cover_files[0]}'
                    }
                    print(f"  Found {len(cover_files)} cover(s) for '{comic_name}'")
        
        return covers
    
    def scan_chapters(self):
        """Scan comics directory and extract chapter data"""
        if not os.path.exists(COMICS_DIR):
            print(f"✗ Comics directory not found: {COMICS_DIR}")
            return {}
        
        comics = {}
        for comic_name in os.listdir(COMICS_DIR):
            comic_path = os.path.join(COMICS_DIR, comic_name)
            if os.path.isdir(comic_path):
                chapters = {}
                for chapter_dir in sorted(os.listdir(comic_path)):
                    chapter_path = os.path.join(comic_path, chapter_dir)
                    if os.path.isdir(chapter_path):
                        # Extract chapter number (chapter-1 -> 1)
                        match = re.search(r'(\d+)', chapter_dir)
                        if match:
                            chapter_num = int(match.group(1))
                            pages = [f for f in os.listdir(chapter_path) if f.lower().endswith(('.png', '.jpg', '.jpeg'))]
                            if pages:
                                chapters[chapter_num] = {
                                    'dir': chapter_dir,
                                    'pages': len(pages),
                                    'path': f'/assets/comics/{comic_name}/{chapter_dir}'
                                }
                
                if chapters:
                    comics[comic_name] = chapters
                    print(f"  Found {len(chapters)} chapter(s) in '{comic_name}'")
        
        return comics
    
    def get_or_create_comic(self, title, description, cover_path, category):
        """Get existing comic or create new one"""
        try:
            # Check if comic exists
            query = "SELECT id FROM comics WHERE title = %s"
            self.cursor.execute(query, (title,))
            result = self.cursor.fetchone()
            
            if result:
                comic_id = result['id']
                print(f"  ✓ Comic '{title}' exists (ID: {comic_id})")
                return comic_id
            else:
                # Insert new comic
                query = "INSERT INTO comics (title, description, cover_path, category, average_rating, views) VALUES (%s, %s, %s, %s, %s, %s)"
                self.cursor.execute(query, (title, description, cover_path, category, 0.0, 0))
                self.conn.commit()
                comic_id = self.cursor.lastrowid
                print(f"  ✓ Comic '{title}' created (ID: {comic_id})")
                return comic_id
        except mysql.connector.Error as err:
            print(f"  ✗ Error with comic '{title}': {err}")
            return None
    
    def get_or_create_chapter(self, comic_id, title, chapter_num):
        """Get existing chapter or create new one"""
        try:
            # Check if chapter exists
            query = "SELECT id FROM chapters WHERE comic_id = %s AND number = %s"
            self.cursor.execute(query, (comic_id, chapter_num))
            result = self.cursor.fetchone()
            
            if result:
                return result['id']
            else:
                # Insert new chapter
                query = "INSERT INTO chapters (comic_id, title, number) VALUES (%s, %s, %s)"
                self.cursor.execute(query, (comic_id, title, chapter_num))
                self.conn.commit()
                return self.cursor.lastrowid
        except mysql.connector.Error as err:
            print(f"  ✗ Error with chapter '{title}': {err}")
            return None
    
    def populate_database(self):
        """Scan assets and populate database"""
        print("\n" + "="*60)
        print("CToon Database Automation")
        print("="*60)
        
        if not self.connect():
            return False
        
        print("\n📁 Scanning covers directory...")
        covers = self.scan_covers()
        
        print("\n📚 Scanning chapters directory...")
        chapters = self.scan_chapters()
        
        print("\n" + "="*60)
        print("💾 Populating database...")
        print("="*60)
        
        # Map categories based on comic names
        categories = {
            'Kimetsu no Yaiba': 'Action',
            'Chainsaw Man': 'Action',
            'Attack on Titan': 'Action'
        }
        
        # Process each comic
        for comic_name, chapter_list in chapters.items():
            cover_info = covers.get(comic_name, {})
            cover_path = cover_info.get('main_cover', '/assets/covers/default.png')
            category = categories.get(comic_name, 'Manga')
            
            description = f"A popular manga series with {len(chapter_list)} chapters available."
            
            print(f"\n📖 Processing '{comic_name}'...")
            comic_id = self.get_or_create_comic(comic_name, description, cover_path, category)
            
            if comic_id:
                # Add chapters
                for chapter_num in sorted(chapter_list.keys()):
                    chapter_info = chapter_list[chapter_num]
                    chapter_title = f"Chapter {chapter_num}"
                    print(f"    Chapter {chapter_num}: {chapter_info['pages']} pages")
                    self.get_or_create_chapter(comic_id, chapter_title, chapter_num)
        
        print("\n" + "="*60)
        print("✓ Database population complete!")
        print("="*60)
        
        self.disconnect()
        return True
    
    def list_database_status(self):
        """Show database status"""
        if not self.connect():
            return
        
        print("\n" + "="*60)
        print("📊 Database Status")
        print("="*60)
        
        try:
            # Count comics
            self.cursor.execute("SELECT COUNT(*) as count FROM comics")
            comic_count = self.cursor.fetchone()['count']
            print(f"Total Comics: {comic_count}")
            
            # Count chapters
            self.cursor.execute("SELECT COUNT(*) as count FROM chapters")
            chapter_count = self.cursor.fetchone()['count']
            print(f"Total Chapters: {chapter_count}")
            
            # List comics
            print("\n📚 Comics:")
            self.cursor.execute("SELECT id, title, category FROM comics")
            for comic in self.cursor.fetchall():
                self.cursor.execute("SELECT COUNT(*) as count FROM chapters WHERE comic_id = %s", (comic['id'],))
                chapters = self.cursor.fetchone()['count']
                print(f"  - {comic['title']} ({comic['category']}) - {chapters} chapters")
        
        except mysql.connector.Error as err:
            print(f"✗ Error: {err}")
        
        self.disconnect()

def main():
    automation = CToonDBAutomation()
    
    if len(sys.argv) > 1:
        if sys.argv[1] == '--status':
            automation.list_database_status()
        elif sys.argv[1] == '--clear':
            print("⚠️  Clear database? (Not implemented)")
        else:
            print(f"Unknown option: {sys.argv[1]}")
    else:
        automation.populate_database()

if __name__ == '__main__':
    main()
