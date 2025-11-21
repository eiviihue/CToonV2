# CToon Deployment Guide

## Overview
The Maven build process has been optimized to build locally first, then ship the pre-built WAR file to Docker for deployment.

## Build & Deployment Workflow

### Step 1: Build Locally
Before deploying, build the project locally using Maven:

**Windows:**
```bash
build.bat
```

**Linux/Mac:**
```bash
./build.sh
```

This will:
- Check for Maven and Java installations
- Clean the project
- Compile and package the WAR file
- Output: `target/ctoon-1.0-SNAPSHOT.war`

### Step 2: Build Docker Image
Once the WAR file is built successfully:

```bash
docker build -t ctoon:latest .
```

The Dockerfile now expects the pre-built WAR file at `target/ctoon-1.0-SNAPSHOT.war` and simply copies it into Tomcat.

### Step 3: Run Docker Container
```bash
docker run -p 8080:8080 ctoon:latest
```

Access the application at: `http://localhost:8080`

## Key Changes

### Dockerfile
- **Before:** Multi-stage build with Maven inside Docker (slow, unnecessary Docker dependencies)
- **After:** Single-stage deployment using pre-built WAR file (fast, lightweight, efficient)

### Build Scripts
- `build.bat` - Windows build script with error checking
- `build.sh` - Linux/Mac build script with error checking

Both scripts:
- Verify Maven and Java are installed
- Run `mvn clean package -DskipTests`
- Provide clear success/failure messages
- Show next deployment steps

## UI/UX Improvements

### CSS Enhancements (`web/css/style.css`)
- **Modern design** with CSS variables for consistent theming
- **Smooth animations** and transitions for better interactivity
- **Improved spacing** with better padding and margins
- **Dark mode** support with enhanced contrast
- **Responsive design** optimized for mobile and desktop
- **Visual feedback** with hover effects and smooth transitions
- **Better form styling** with focus states and accessibility
- **Enhanced cards** with gradient headers and smooth animations
- **Badges and filters** for better content categorization

### JSP Pages Improvements

#### Homepage (`index.jsp`, `webapp/index.jsp`)
- Gradient colored headers for comic cards
- Rating and review information display
- Trending rankings with numbered badges
- Better visual hierarchy with improved spacing
- Enhanced call-to-action buttons with arrows

#### Browse Page (`browse.jsp`, `webapp/browse.jsp`)
- Improved filter and sort UI with icons
- Comic counter display
- Colored gradient headers for each comic card
- View and bookmark statistics
- Better category badges with color coding

#### Login Page (`login.jsp`, `webapp/login.jsp`)
- Modern form layout with better spacing
- Emoji icons for form labels
- Remember me and forgot password options
- Improved UX with clear visual hierarchy
- Guest access information

#### Navbar (`navbar.jsp`, `webapp/navbar.jsp`)
- Enhanced search bar with glass morphism effect
- Better spacing and alignment
- Improved hover states with smooth transitions

## File Structure
```
CToonV2/
├── build.bat              # Windows build script (NEW)
├── build.sh               # Linux/Mac build script (NEW)
├── Dockerfile             # Updated: single-stage build
├── web/                   # Web files (development)
│   ├── css/style.css      # Enhanced CSS
│   ├── js/
│   └── *.jsp              # Updated JSP files
└── webapp/                # Webapp files (deployed)
    ├── css/style.css      # Enhanced CSS
    ├── js/
    └── *.jsp              # Updated JSP files
```

## Performance Benefits
1. **Faster deployments** - No Maven compilation in Docker
2. **Smaller Docker images** - No Maven/compiler in final image
3. **Better caching** - WAR file can be built once and cached
4. **Simpler debugging** - Local build errors are obvious
5. **CI/CD friendly** - Clear separation of build and deployment steps

## Next Steps
1. Run `build.bat` or `build.sh` to build the WAR file
2. Verify no errors in the build output
3. Run `docker build -t ctoon:latest .`
4. Deploy with `docker run -p 8080:8080 ctoon:latest`

## Troubleshooting
- **Maven not found:** Install Maven or add it to your PATH
- **Java not found:** Install Java 11+ or add it to your PATH
- **Build fails:** Check the error message and fix the code, then rebuild
- **Docker won't run:** Ensure Docker is installed and WAR file exists

