#!/bin/bash

# Meme Troller - GitHub Publishing Script
# This script will help you publish Meme Troller to GitHub

set -e  # Exit on any error

echo "=========================================="
echo "Meme Troller - GitHub Publishing Wizard"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get user's GitHub username
echo -e "${YELLOW}Step 1: GitHub Account Information${NC}"
read -p "Enter your GitHub username: " GITHUB_USERNAME

if [ -z "$GITHUB_USERNAME" ]; then
    echo -e "${RED}Error: GitHub username is required${NC}"
    exit 1
fi

# Repository name
REPO_NAME="meme-troller"
echo ""
echo "Repository will be created as: ${GITHUB_USERNAME}/${REPO_NAME}"
echo ""

# Confirm
read -p "Is this correct? (y/n): " CONFIRM
if [ "$CONFIRM" != "y" ]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo -e "${YELLOW}Step 2: Initializing Git Repository${NC}"

# Initialize git if not already done
if [ ! -d ".git" ]; then
    git init
    echo -e "${GREEN}✓ Git repository initialized${NC}"
else
    echo -e "${GREEN}✓ Git repository already exists${NC}"
fi

# Configure git if needed
if [ -z "$(git config user.name)" ]; then
    read -p "Enter your name for git commits: " GIT_NAME
    git config user.name "$GIT_NAME"
fi

if [ -z "$(git config user.email)" ]; then
    read -p "Enter your email for git commits: " GIT_EMAIL
    git config user.email "$GIT_EMAIL"
fi

echo ""
echo -e "${YELLOW}Step 3: Staging Files${NC}"

# Add all files
git add .
echo -e "${GREEN}✓ All files staged${NC}"

echo ""
echo -e "${YELLOW}Step 4: Creating Initial Commit${NC}"

# Check if there are any commits
if ! git rev-parse HEAD >/dev/null 2>&1; then
    # No commits yet, create initial commit
    git commit -m "Initial commit: Meme Troller v1.0.0

- User authentication with admin approval
- Meme posting (images, GIFs, videos)
- Comment system with media attachments
- Reaction system with multiple types
- Gamification with badges and leaderboard
- Customizable banner system
- Admin panel for site management
- Mobile-responsive design
- Docker deployment
- Complete documentation suite

Features:
✨ Customizable banner for community branding
🏆 6-tier badge system with special achievements
👥 Admin approval workflow
📱 Mobile-first responsive design
🎨 Full admin settings interface
🐳 Docker containerization
📚 Comprehensive documentation

Tech Stack: Python 3.11, Flask 3.0, SQLite, Docker, Bootstrap 5"

    echo -e "${GREEN}✓ Initial commit created${NC}"
else
    echo -e "${YELLOW}ℹ Commits already exist, skipping initial commit${NC}"
fi

echo ""
echo -e "${YELLOW}Step 5: Setting Up Remote Repository${NC}"
echo ""
echo "Now we need to create the repository on GitHub."
echo ""
echo "Please follow these steps:"
echo "1. Go to: https://github.com/new"
echo "2. Repository name: ${REPO_NAME}"
echo "3. Description: Self-hosted meme-sharing platform with gamification - Your headquarters for community chaos"
echo "4. Choose: Public (or Private if you prefer)"
echo "5. DO NOT initialize with README, .gitignore, or license"
echo "6. Click 'Create repository'"
echo ""
read -p "Press ENTER once you've created the repository on GitHub..."

echo ""
echo -e "${YELLOW}Step 6: Connecting to GitHub${NC}"

# Add remote
REMOTE_URL="https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"

# Check if remote exists
if git remote get-url origin >/dev/null 2>&1; then
    echo -e "${YELLOW}Remote 'origin' already exists. Updating...${NC}"
    git remote set-url origin "$REMOTE_URL"
else
    git remote add origin "$REMOTE_URL"
fi

echo -e "${GREEN}✓ Remote repository configured${NC}"
echo "   URL: $REMOTE_URL"

echo ""
echo -e "${YELLOW}Step 7: Pushing to GitHub${NC}"
echo ""
echo "This will push your code to GitHub."
echo "You may be prompted to authenticate."
echo ""
read -p "Ready to push? (y/n): " PUSH_CONFIRM

if [ "$PUSH_CONFIRM" = "y" ]; then
    # Rename branch to main if needed
    CURRENT_BRANCH=$(git branch --show-current)
    if [ "$CURRENT_BRANCH" != "main" ] && [ "$CURRENT_BRANCH" != "" ]; then
        git branch -M main
        echo -e "${GREEN}✓ Branch renamed to 'main'${NC}"
    fi
    
    # Push to GitHub
    echo ""
    echo "Pushing to GitHub..."
    if git push -u origin main; then
        echo ""
        echo -e "${GREEN}✓✓✓ SUCCESS! ✓✓✓${NC}"
        echo ""
        echo "=========================================="
        echo "🎉 Meme Troller is now on GitHub!"
        echo "=========================================="
        echo ""
        echo "Repository: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
        echo ""
        echo "Next steps:"
        echo "1. Visit your repository on GitHub"
        echo "2. Add topics/tags: memes, flask, docker, raspberry-pi, python, self-hosted"
        echo "3. Update About section with description"
        echo "4. Create your first release (v1.0.0)"
        echo "5. Add screenshots to README"
        echo ""
        echo "See GITHUB_SETUP.md for more post-publication tasks!"
        echo ""
    else
        echo ""
        echo -e "${RED}✗ Push failed${NC}"
        echo ""
        echo "Possible issues:"
        echo "1. Authentication failed - You may need to:"
        echo "   - Set up a Personal Access Token (PAT)"
        echo "   - Configure GitHub CLI (gh)"
        echo "   - Set up SSH keys"
        echo ""
        echo "2. Repository doesn't exist - Make sure you created it on GitHub"
        echo ""
        echo "3. Repository already has content - Try: git pull origin main --rebase"
        echo ""
        echo "Need help? Check: https://docs.github.com/en/authentication"
    fi
else
    echo "Push cancelled. You can push later with:"
    echo "  git push -u origin main"
fi

echo ""
echo "=========================================="
echo "Publishing script complete!"
echo "=========================================="
