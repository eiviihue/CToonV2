#!/usr/bin/env bash
# Deployment verification script

echo "=== CToon V2 Deployment Verification ==="
echo ""

ERRORS=0

# Check 1: Maven configuration
echo "[CHECK 1] Maven configuration..."
if [ -f "pom.xml" ]; then
    echo "  ✓ pom.xml exists"
else
    echo "  ✗ pom.xml missing"
    ERRORS=$((ERRORS + 1))
fi

# Check 2: WAR file
echo "[CHECK 2] WAR file..."
if [ -f "target/ctoon-1.0-SNAPSHOT.war" ]; then
    SIZE=$(stat -c%s "target/ctoon-1.0-SNAPSHOT.war" 2>/dev/null || stat -f%z "target/ctoon-1.0-SNAPSHOT.war")
    echo "  ✓ WAR file exists ($((SIZE / 1024 / 1024)) MB)"
else
    echo "  ✗ WAR file not found (run: mvn clean package)"
    ERRORS=$((ERRORS + 1))
fi

# Check 3: Docker configuration
echo "[CHECK 3] Docker configuration..."
if [ -f "Dockerfile" ]; then
    echo "  ✓ Dockerfile exists (multi-stage build)"
else
    echo "  ✗ Dockerfile missing"
    ERRORS=$((ERRORS + 1))
fi

# Check 4: Railway configuration
echo "[CHECK 4] Railway configuration..."
if [ -f "railway.toml" ]; then
    echo "  ✓ railway.toml configured"
else
    echo "  ✗ railway.toml missing"
    ERRORS=$((ERRORS + 1))
fi

# Check 5: GitHub Actions
echo "[CHECK 5] GitHub Actions..."
if [ -f ".github/workflows/deploy.yml" ]; then
    echo "  ✓ CI/CD pipeline configured"
else
    echo "  ✗ CI/CD pipeline not found"
    ERRORS=$((ERRORS + 1))
fi

# Check 6: Git status
echo "[CHECK 6] Git status..."
if [ -d ".git" ]; then
    UNPUSHED=$(git log --oneline origin/main..main 2>/dev/null | wc -l)
    if [ "$UNPUSHED" -eq 0 ]; then
        echo "  ✓ All changes pushed to GitHub"
    else
        echo "  ⚠ $UNPUSHED commits not pushed (run: git push origin main)"
    fi
else
    echo "  ✗ Not a Git repository"
    ERRORS=$((ERRORS + 1))
fi

# Check 7: Deployment scripts
echo "[CHECK 7] Deployment scripts..."
SCRIPT_COUNT=0
for script in deploy.sh deploy.bat deploy-to-railway.bat railway-deploy.sh; do
    if [ -f "$script" ]; then
        SCRIPT_COUNT=$((SCRIPT_COUNT + 1))
    fi
done
echo "  ✓ $SCRIPT_COUNT deployment automation scripts ready"

# Check 8: Documentation
echo "[CHECK 8] Documentation..."
DOCS=0
for doc in DEPLOYMENT.md DEPLOYMENT_COMPLETE.md DEPLOYMENT_GUIDE.md; do
    if [ -f "$doc" ]; then
        DOCS=$((DOCS + 1))
    fi
done
echo "  ✓ $DOCS documentation files present"

# Summary
echo ""
echo "=== Summary ==="
if [ $ERRORS -eq 0 ]; then
    echo "✓ All checks passed!"
    echo ""
    echo "Your deployment is ready. Next step:"
    echo ""
    echo "  Option 1 (Recommended - Railway auto-deploy):"
    echo "    git push origin main"
    echo "    # Railway will auto-build and deploy"
    echo ""
    echo "  Option 2 (Local Docker build):"
    echo "    ./deploy.sh  (macOS/Linux)"
    echo "    deploy.bat   (Windows)"
    echo ""
    echo "  Option 3 (Manual Railway):"
    echo "    railway login"
    echo "    railway up"
else
    echo "✗ $ERRORS issue(s) found - see above"
    exit 1
fi
