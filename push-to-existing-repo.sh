#!/bin/bash

# Meme Troller - Push to Existing GitHub Repo (macOS)
# Use this when you've already created the repo on GitHub

set -e  # Exit on any error

echo "=========================================="
echo "Push Meme Troller to Existing GitHub Repo"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get user's GitHub username
echo -e "${YELLOW}Step 1: GitHub Information${NC}"
echo ""
read -p "Enter your GitHub username: " GITHUB_USERNAME
read -p "Enter repository name [meme-troller]: " REPO_NAME
REPO_NAME=${REPO_NAME:-meme-troller}

echo ""
echo "Will push to: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
echo ""
read -p "Is this correct? (y/n): " CONFIRM

if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo -e "${YELLOW}Step 2: Initializing Git${NC}"
echo ""

# Initialize git if needed
if [ ! -d ".git" ]; then
    git init
    echo -e "${GREEN}✓ Git repository initialized${NC}"
else
    echo -e "${GREEN}✓ Git repository exists${NC}"
fi

# Configure git if needed
GIT_NAME=$(git config user.name 2>/dev/null || echo "")
GIT_EMAIL=$(git config user.email 2>/dev/null || echo "")

if [ -z "$GIT_NAME" ]; then
    read -p "Enter your name for git: " INPUT_NAME
    git config user.name "$INPUT_NAME"
fi

if [ -z "$GIT_EMAIL" ]; then
    read -p "Enter your email for git: " INPUT_EMAIL
    git config user.email "$INPUT_EMAIL"
fi

echo ""
echo -e "${YELLOW}Step 3: Staging and Committing${NC}"
echo ""

# Stage all files
git add .
echo -e "${GREEN}✓ Files staged${NC}"

# Check if there are commits
if ! git rev-parse HEAD >/dev/null 2>&1; then
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
- Complete documentation

Tech Stack: Python 3.11, Flask 3.0, SQLite, Docker, Bootstrap 5"
    
    echo -e "${GREEN}✓ Initial commit created${NC}"
else
    # Check if there are changes
    if ! git diff-index --quiet HEAD --; then
        git commit -m "Update: Meme Troller repository"
        echo -e "${GREEN}✓ Changes committed${NC}"
    else
        echo -e "${YELLOW}ℹ  No changes to commit${NC}"
    fi
fi

echo ""
echo -e "${YELLOW}Step 4: Setting Up Remote${NC}"
echo ""

REMOTE_URL="https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"

# Remove existing remote if it exists
if git remote get-url origin >/dev/null 2>&1; then
    git remote remove origin
    echo -e "${YELLOW}ℹ  Removed existing remote${NC}"
fi

# Add remote
git remote add origin "$REMOTE_URL"
echo -e "${GREEN}✓ Remote configured: ${REMOTE_URL}${NC}"

echo ""
echo -e "${YELLOW}Step 5: Authentication${NC}"
echo ""
echo "Choose authentication method:"
echo "1. Personal Access Token (recommended)"
echo "2. SSH Keys"
echo ""
read -p "Choose (1/2): " AUTH_CHOICE

if [ "$AUTH_CHOICE" = "2" ]; then
    # Switch to SSH
    REMOTE_URL="git@github.com:${GITHUB_USERNAME}/${REPO_NAME}.git"
    git remote set-url origin "$REMOTE_URL"
    echo -e "${GREEN}✓ Using SSH: ${REMOTE_URL}${NC}"
else
    echo ""
    echo "Using HTTPS with Personal Access Token"
    echo ""
    echo "If you don't have a token:"
    echo "1. Go to: https://github.com/settings/tokens/new"
    echo "2. Name: Meme Troller"
    echo "3. Expiration: 90 days"
    echo "4. Scope: Check 'repo'"
    echo "5. Generate and copy the token"
    echo ""
    echo "When prompted for password, paste your token!"
    echo ""
    read -p "Press ENTER when ready to push..."
fi

echo ""
echo -e "${YELLOW}Step 6: Pushing to GitHub${NC}"
echo ""

# Rename branch to main
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "master")
if [ "$CURRENT_BRANCH" != "main" ]; then
    git branch -M main
    echo -e "${GREEN}✓ Branch renamed to main${NC}"
fi

# Pull first in case there's anything on GitHub
echo "Checking for existing content on GitHub..."
if git ls-remote origin main >/dev/null 2>&1; then
    echo -e "${YELLOW}ℹ  Remote has content, pulling first...${NC}"
    git pull origin main --allow-unrelated-histories --no-edit || {
        echo -e "${YELLOW}⚠  Pull had conflicts, but continuing...${NC}"
    }
fi

# Push
echo ""
echo "Pushing to GitHub..."
if git push -u origin main; then
    echo ""
    echo "=========================================="
    echo -e "${GREEN}        ✓✓✓ SUCCESS! ✓✓✓${NC}"
    echo "=========================================="
    echo ""
    echo "🎉 Meme Troller is now on GitHub!"
    echo ""
    echo "Repository: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
    echo ""
    echo "Opening in browser..."
    sleep 1
    open "https://github.com/${GITHUB_USERNAME}/${REPO_NAME}" 2>/dev/null
    echo ""
    echo "Next steps:"
    echo "1. Add topics: memes, flask, docker, raspberry-pi, python"
    echo "2. Create release (v1.0.0)"
    echo "3. Add screenshots"
    echo ""
else
    echo ""
    echo -e "${RED}✗ Push failed${NC}"
    echo ""
    echo "Try:"
    echo "  git push -u origin main --force"
    echo ""
    echo "Or if using PAT, make sure you pasted the token as password"
    exit 1
fi

echo "=========================================="
