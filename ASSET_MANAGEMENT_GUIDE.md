# CToon Asset Management Guide

## Directory Structure

```
webapp/
├── assets/
│   ├── covers/
│   │   ├── Kimetsu-no-Yaiba/
│   │   │   ├── coverA.png
│   │   │   ├── coverB.png
│   │   │   └── ...
│   │   ├── Chainsaw-Man/
│   │   │   ├── coverC.png
│   │   │   └── ...
│   │   └── Attack-on-Titan/
│   │       ├── coverD.png
│   │       └── ...
│   │
│   └── comics/
│       ├── Kimetsu no Yaiba/
│       │   ├── chapter-1/
│       │   │   ├── 01.png
│       │   │   ├── 02.png
│       │   │   ├── 03.png
│       │   │   └── ...
│       │   ├── chapter-2/
│       │   │   ├── 01.png
│       │   │   ├── 02.png
│       │   │   └── ...
│       │   └── ...
│       ├── Chainsaw Man/
│       │   ├── chapter-1/
│       │   │   ├── 01.png
│       │   │   └── ...
│       │   └── ...
│       └── Attack on Titan/
│           ├── chapter-1/
│           │   └── ...
│           └── ...
```

## Naming Conventions

### Comic Names
- **Covers directory**: Use hyphens for spaces (`Kimetsu-no-Yaiba`)
- **Comics directory**: Use actual spaces (`Kimetsu no Yaiba`)
- The script automatically converts between these formats

### Chapter Names
- Format: `chapter-{number}` (e.g., `chapter-1`, `chapter-2`)
- Numbers must be in sequential order for proper sorting
- Supports single or multi-digit numbers

### Page Files
- Format: `{number}.png` or `{number}.jpg` (e.g., `01.png`, `02.png`)
- Should be zero-padded (01, 02, 03... for organization)
- Supported formats: PNG, JPG, JPEG
- Order determined by filename (01 comes before 02, etc.)

## Database Automation Script

### Quick Start

#### Windows
```bash
# Populate database from assets
run_db_automation.bat

# Check database status
run_db_automation.bat --status

# Show help
run_db_automation.bat --help
```

#### Linux/Mac
```bash
# Make script executable
chmod +x run_db_automation.sh

# Populate database from assets
./run_db_automation.sh

# Check database status
./run_db_automation.sh --status

# Show help
./run_db_automation.sh --help
```

### Python Usage

```bash
# Populate database
python populate_database.py

# Check database status
python populate_database.py --status
```

### How It Works

The automation script:

1. **Scans Covers Directory**
   - Finds all comic folders in `webapp/assets/covers/`
   - Identifies cover images (PNG, JPG, JPEG)
   - Uses first cover as main comic cover in database

2. **Scans Comics Directory**
   - Finds all comic folders in `webapp/assets/comics/`
   - Finds all chapter folders within each comic
   - Extracts chapter numbers from folder names
   - Counts pages in each chapter

3. **Populates Database**
   - Creates comic entries if they don't exist
   - Links cover paths to database
   - Creates chapter records with page counts
   - Skips existing entries (safe to run multiple times)

4. **Shows Results**
   - Displays created/existing comics and chapters
   - Shows number of pages per chapter
   - Confirms successful database population

## Adding New Comics

### Step 1: Create Cover Directory
```
webapp/assets/covers/New-Comic-Name/
└── cover.png (main cover image)
```

### Step 2: Create Comics Directory
```
webapp/assets/comics/New Comic Name/
├── chapter-1/
│   ├── 01.png
│   ├── 02.png
│   └── ...
└── chapter-2/
    ├── 01.png
    ├── 02.png
    └── ...
```

### Step 3: Run Automation Script
```bash
# Windows
run_db_automation.bat

# Linux/Mac
./run_db_automation.sh

# Or Python directly
python populate_database.py
```

### Step 4: Verify
```bash
# Windows
run_db_automation.bat --status

# Linux/Mac
./run_db_automation.sh --status

# Or Python directly
python populate_database.py --status
```

## Database Connection Details

**Host**: shinkansen.proxy.rlwy.net  
**Port**: 54128  
**Database**: railway  
**Username**: root  
**Password**: oRsqyOGrDWrBUBLYeGBxajubkknNXcuu  

The script automatically uses these credentials.

## Example: Adding "Jujutsu Kaisen"

```
# Step 1: Create directory for covers
mkdir webapp/assets/covers/Jujutsu-Kaisen
cp jujutsu-kaisen-cover.png webapp/assets/covers/Jujutsu-Kaisen/

# Step 2: Create directory for chapters
mkdir -p webapp/assets/comics/Jujutsu Kaisen/chapter-1
mkdir -p webapp/assets/comics/Jujutsu Kaisen/chapter-2

# Step 3: Add chapter pages
cp chapter1-page*.png webapp/assets/comics/Jujutsu Kaisen/chapter-1/
cp chapter2-page*.png webapp/assets/comics/Jujutsu Kaisen/chapter-2/

# Step 4: Rename pages to proper format
# 01.png, 02.png, 03.png, etc.

# Step 5: Run automation
python populate_database.py

# Step 6: Verify
python populate_database.py --status
```

## Display in Web Application

### Comics are automatically served at:

**Cover images**:
```
/assets/covers/{Comic-Name}/{cover-image}.png
```

**Chapter pages**:
```
/assets/comics/{Comic Name}/chapter-{number}/{page}.png
```

### In JSP pages, access with:
```jsp
<!-- Show cover image -->
<img src="${pageContext.request.contextPath}/assets/covers/Kimetsu-no-Yaiba/cover.png" />

<!-- Show chapter pages -->
<img src="${pageContext.request.contextPath}/assets/comics/Kimetsu no Yaiba/chapter-1/01.png" />
```

## Database Tables Updated

### comics table
- `id`: Auto-increment primary key
- `title`: Comic name
- `description`: Auto-generated description
- `cover_path`: Path to cover image
- `category`: Comic category (Action, Romance, etc.)
- `average_rating`: Rating (default: 0)
- `views`: View count (default: 0)

### chapters table
- `id`: Auto-increment primary key
- `comic_id`: Foreign key to comics table
- `title`: Chapter title (e.g., "Chapter 1")
- `number`: Chapter number (extracted from folder)

## Troubleshooting

### Script not finding assets
- Ensure covers directory is: `webapp/assets/covers/`
- Ensure comics directory is: `webapp/assets/comics/`
- Check folder names don't have extra spaces
- Use hyphens for covers folder names, spaces for comics folder names

### Database connection failed
- Verify internet connection (Railway DB is cloud-hosted)
- Check credentials in `populate_database.py`
- Test connection: `mysql -h shinkansen.proxy.rlwy.net -P 54128 -u root -p`

### Python packages missing
- Install mysql-connector: `pip install mysql-connector-python`
- Verify Python version: `python --version` (requires Python 3.6+)

### Duplicate entries
- Script checks for existing comics before inserting
- Safe to run multiple times
- Won't create duplicates for same comic name

## Performance Notes

- Script scans directories once at startup
- Database operations are optimized with existence checks
- Can handle hundreds of comics and thousands of chapters
- Typical execution time: < 30 seconds for 100+ comics

## Security Notes

- Database credentials are stored in Python file
- Consider moving to environment variables in production
- Create read-only database user for public access
- Use HTTPS when serving images in production

---

**Last Updated**: November 20, 2025  
**Status**: ✅ Ready for use
