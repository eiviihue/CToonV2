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

# Database Configuration - use environment variables for security
DB_CONFIG = {
    'host': 'shinkansen.proxy.rlwy.net',
    'port': 54128,
    'user': 'root',
    'password': 'oRsqyOGrDWrBUBLYeGBxajubkknNXcuu',
    'database': 'railway'
}

# Asset paths
COVERS_DIR = os.path.join(os.path.dirname(__file__), 'src/main/webapp/assets/covers')
COMICS_DIR = os.path.join(os.path.dirname(__file__), 'src/main/webapp/assets/comics')

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
                            page_files = [f for f in os.listdir(chapter_path) if f.lower().endswith(('.png', '.jpg', '.jpeg'))]
                            # natural sort pages (01.png, 2.png, etc.)
                            def natural_key(s):
                                parts = re.split(r'(\d+)', s)
                                return [int(p) if p.isdigit() else p.lower() for p in parts]

                            page_files = sorted(page_files, key=natural_key)
                            if page_files:
                                chapters[chapter_num] = {
                                    'dir': chapter_dir,
                                    'pages': len(page_files),
                                    'path': f'/assets/comics/{comic_name}/{chapter_dir}',
                                    'files': page_files,
                                    'comic_dir_name': comic_name
                                }

                if chapters:
                    comics[comic_name] = chapters
                    print(f"  Found {len(chapters)} chapter(s) in '{comic_name}'")
        
        return comics
    
    def get_or_create_comic(self, title, description, cover_path, genres):
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
                # Insert new comic (no category column anymore)
                query = "INSERT INTO comics (title, description, cover_path, average_rating, views) VALUES (%s, %s, %s, %s, %s)"
                self.cursor.execute(query, (title, description, cover_path, 0.0, 0))
                self.conn.commit()
                comic_id = self.cursor.lastrowid
                print(f"  ✓ Comic '{title}' created (ID: {comic_id})")
                
                # Add genres for this comic
                if genres:
                    for genre_name in genres:
                        try:
                            # Get genre ID
                            query = "SELECT id FROM genres WHERE name = %s"
                            self.cursor.execute(query, (genre_name,))
                            genre = self.cursor.fetchone()
                            
                            if genre:
                                # Link comic to genre
                                insert_query = "INSERT INTO comic_genres (comic_id, genre_id) VALUES (%s, %s)"
                                self.cursor.execute(insert_query, (comic_id, genre['id']))
                                self.conn.commit()
                        except mysql.connector.Error as err:
                            print(f"    Error adding genre '{genre_name}': {err}")
                
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

    def get_or_create_page(self, chapter_id, page_number, image_path):
        """Get existing page by chapter+page_number or insert it"""
        try:
            query = "SELECT id FROM pages WHERE chapter_id = %s AND page_number = %s"
            self.cursor.execute(query, (chapter_id, page_number))
            result = self.cursor.fetchone()
            if result:
                return result['id']
            else:
                query = "INSERT INTO pages (chapter_id, page_number, image_path) VALUES (%s, %s, %s)"
                self.cursor.execute(query, (chapter_id, page_number, image_path))
                self.conn.commit()
                return self.cursor.lastrowid
        except mysql.connector.Error as err:
            print(f"    ✗ Error inserting page {page_number} for chapter_id {chapter_id}: {err}")
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
        
        # Map genres for each comic (can have multiple)
        comic_genres = {
            'Kimetsu no Yaiba': ['Action', 'Adventure'],
            'Chainsaw Man': ['Action', 'Adventure'],
            'Attack on Titan': ['Action', 'Adventure']
        }
        
        # Process each comic
        for comic_name, chapter_list in chapters.items():
            cover_info = covers.get(comic_name, {})
            cover_path = cover_info.get('main_cover', '/assets/covers/default.png')
            genres = comic_genres.get(comic_name, ['Manga'])

            description = f"A popular manga series with {len(chapter_list)} chapters available."

            print(f"\n📖 Processing '{comic_name}'...")
            comic_id = self.get_or_create_comic(comic_name, description, cover_path, genres)

            if comic_id:
                # Add chapters and pages
                for chapter_num in sorted(chapter_list.keys()):
                    chapter_info = chapter_list[chapter_num]
                    chapter_title = f"Chapter {chapter_num}"
                    print(f"    Chapter {chapter_num}: {chapter_info['pages']} pages")
                    chapter_id = self.get_or_create_chapter(comic_id, chapter_title, chapter_num)
                    if chapter_id and 'files' in chapter_info:
                        # Insert pages for the chapter
                        for idx, filename in enumerate(chapter_info['files'], start=1):
                            image_path = f"/assets/comics/{chapter_info['comic_dir_name']}/{chapter_info['dir']}/{filename}"
                            page_id = self.get_or_create_page(chapter_id, idx, image_path)
                            if page_id:
                                # optional: print per-page insert for verbose feedback
                                if idx <= 3 or idx == len(chapter_info['files']):
                                    print(f"      ✓ Page {idx} -> {image_path}")
        
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
            self.cursor.execute("SELECT id, title FROM comics")
            for comic in self.cursor.fetchall():
                self.cursor.execute("SELECT COUNT(*) as count FROM chapters WHERE comic_id = %s", (comic['id'],))
                chapters = self.cursor.fetchone()['count']
                print(f"  - {comic['title']} - {chapters} chapters")
        
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
