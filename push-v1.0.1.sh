#!/bin/bash

# Meme Troller v1.0.1 - Push to GitHub

set -e

echo "=========================================="
echo "Pushing Meme Troller v1.0.1 to GitHub"
echo "=========================================="
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Navigate to project
if [ ! -f "app.py" ]; then
    echo -e "${RED}Error: Not in meme-troller directory${NC}"
    echo "Please run from: cd ~/'Code Repos'/meme-troller"
    exit 1
fi

echo -e "${YELLOW}Step 1: Checking Git Status${NC}"
echo ""

# Check if there are changes
git status

echo ""
echo -e "${YELLOW}Step 2: Staging Changes${NC}"
echo ""

# Stage all changes
git add .

echo -e "${GREEN}✓ All changes staged${NC}"

echo ""
echo -e "${YELLOW}Step 3: Creating Commit${NC}"
echo ""

# Create commit for v1.0.1
git commit -m "Release v1.0.1: Automated Backup System

Major Features:
- Automated backup system with multiple storage providers
- Support for Local, Google Drive, and pCloud storage
- Flexible scheduling (daily or weekly with day selection)
- Configurable backup time and retention policy
- Keep last 1-10 backups with auto-cleanup
- Manual 'Backup Now' button
- Backup history tracking with file sizes and status
- Test connection feature for cloud providers
- Complete backups of database and uploaded media

Technical Changes:
- Added APScheduler for background job scheduling
- New BackupSettings and BackupHistory database models
- New backup service with cloud integration
- Added backup_settings.html template
- Enhanced admin navigation with Backups menu
- New dependencies: APScheduler, Google API client, requests

Documentation:
- Updated CHANGELOG.md
- Updated requirements.txt
- Comprehensive backup configuration UI

This release adds enterprise-grade backup capabilities to ensure
memes and data are never lost!" || {
    echo -e "${YELLOW}ℹ  No changes to commit or already committed${NC}"
}

echo ""
echo -e "${YELLOW}Step 4: Creating Git Tag${NC}"
echo ""

# Create tag for v1.0.1
git tag -a v1.0.1 -m "Version 1.0.1 - Automated Backup System

Major new feature: Complete backup management system with:
- Multiple cloud storage providers (Local, Google Drive, pCloud)
- Flexible scheduling options (daily/weekly)
- Configurable retention policies
- Backup history tracking
- Manual and automated backups

See CHANGELOG.md for full details." || {
    echo -e "${YELLOW}ℹ  Tag v1.0.1 already exists${NC}"
}

echo -e "${GREEN}✓ Tag v1.0.1 created${NC}"

echo ""
echo -e "${YELLOW}Step 5: Pushing to GitHub${NC}"
echo ""

# Push to main branch
echo "Pushing to main branch..."
git push origin main

echo ""
echo "Pushing tags..."
git push origin v1.0.1

echo ""
echo "=========================================="
echo -e "${GREEN}✓✓✓ SUCCESS! ✓✓✓${NC}"
echo "=========================================="
echo ""
echo "🎉 Meme Troller v1.0.1 is now on GitHub!"
echo ""
echo "Next steps:"
echo ""
echo "1. Create GitHub Release:"
echo "   - Go to: https://github.com/YOUR_USERNAME/meme-troller/releases/new"
echo "   - Tag: v1.0.1 (select from dropdown)"
echo "   - Title: v1.0.1 - Automated Backup System"
echo "   - Description: See RELEASE_NOTES_v1.0.1.md for content"
echo "   - Upload meme-troller-v1.0.1.tar.gz as binary"
echo "   - Click 'Publish release'"
echo ""
echo "2. Announce the update:"
echo "   - Update README if needed"
echo "   - Share on social media"
echo "   - Notify users to upgrade"
echo ""
echo "Repository: https://github.com/YOUR_USERNAME/meme-troller"
echo ""
echo "=========================================="
