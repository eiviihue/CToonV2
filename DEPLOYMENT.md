# CToon V2 - Deployment Guide

## Quick Start

### Local Deployment (Windows)
```bash
./deploy-war.bat
```

### Railway Deployment
```bash
railway login
railway up
```

---

## Environment Variables

Set the following environment variables for database connectivity:

```bash
DB_HOST=your-database-host
DB_PORT=3306
DB_NAME=database_name
DB_USER=root
DB_PASSWORD=your-secure-password
```

**Important**: Never commit credentials to Git. Use Railway's environment variable UI or `.env` files (excluded from Git).

---

## Database Setup

### 1. Create Tables
```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    profile_photo VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE comics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    cover_path VARCHAR(255),
    category VARCHAR(50),
    average_rating DOUBLE DEFAULT 0,
    views INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE chapters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    comic_id INT NOT NULL,
    title VARCHAR(255),
    number INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (comic_id) REFERENCES comics(id) ON DELETE CASCADE
);

CREATE TABLE pages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    chapter_id INT NOT NULL,
    page_number INT NOT NULL,
    image_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (chapter_id) REFERENCES chapters(id) ON DELETE CASCADE
);

CREATE TABLE comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    chapter_id INT NOT NULL,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (chapter_id) REFERENCES chapters(id) ON DELETE CASCADE
);

CREATE TABLE ratings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    comic_id INT NOT NULL,
    stars INT CHECK (stars >= 1 AND stars <= 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_rating (user_id, comic_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (comic_id) REFERENCES comics(id) ON DELETE CASCADE
);

CREATE TABLE bookmarks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    comic_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_bookmark (user_id, comic_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (comic_id) REFERENCES comics(id) ON DELETE CASCADE
);
```

### 2. Populate Database
```powershell
python populate_database.py
```

---

## Configuration Files

### `nixpacks.toml`
- Railway-specific build configuration
- Installs JDK 17, Maven, and Tomcat
- Builds WAR file and deploys to Tomcat

### `deploy-war.bat`
- Local build and deployment script
- Copies WAR to Tomcat webapps directory as ROOT.war

### `.github/workflows/deploy.yml`
- GitHub Actions automation
- Verifies WAR integrity on build
- Auto-deploys to Railway on push to `main`

---

## Building and Deployment

### Local Build
```powershell
mvn clean package
```

WAR file output: `target/ctoon-1.0-SNAPSHOT.war`

### Verify WAR Integrity
```bash
unzip -t target/ctoon-1.0-SNAPSHOT.war
```

### Deploy Locally to Tomcat
```bash
./deploy-war.bat
```

### Deploy to Railway
1. Connect GitHub repository to Railway
2. Set environment variables in Railway dashboard (DB_HOST, DB_PORT, etc.)
3. Push to `main` branch - Railway automatically builds and deploys

---

## Troubleshooting

### Database Connection Failed
- Verify all `DB_*` environment variables are set
- Check credentials with: `mysql -h $DB_HOST -u $DB_USER -p`
- Ensure database user has proper permissions

### 404 Error on Application
- Verify WAR deployed as `ROOT.war` in Tomcat webapps
- Check: `unzip -l target/ctoon-1.0-SNAPSHOT.war | grep jsp`
- View Tomcat logs: `docker logs <container-id>`

### Asset Files Not Found
- Ensure `src/main/webapp/assets/` exists with subdirectories
- Verify assets included in WAR: `unzip -l target/ctoon-1.0-SNAPSHOT.war | grep assets`

### Out of Memory Errors
Set JVM heap size:
```bash
export JAVA_OPTS="-Xmx1g -Xms512m"
```

---

## Health Checks

View application status:
```bash
curl http://localhost:8080/ctoon-1.0-SNAPSHOT/health
curl http://localhost:8080/ctoon-1.0-SNAPSHOT/ready
```

---

## Project Structure

```
src/main/java/
  ├── controller/    # HTTP request handlers
  ├── dao/          # Database access objects
  ├── model/        # Data models
  └── util/         # Utilities (DB, servlets)
src/main/webapp/
  ├── assets/       # Comics and covers
  ├── css/          # Stylesheets
  ├── js/           # JavaScript
  ├── *.jsp         # Web pages
  └── WEB-INF/
      └── web.xml   # Deployment descriptor
pom.xml             # Maven configuration
```

---

## Support

For issues:
1. Check `nixpacks.toml` and Railway build logs
2. Verify WAR file integrity
3. Test database connectivity
4. Review application logs
5. Ensure all environment variables are set
