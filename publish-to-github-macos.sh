#!/bin/bash

# Meme Troller - GitHub Publishing Script (macOS Optimized)
# This script will help you publish Meme Troller to GitHub

set -e  # Exit on any error

echo "=========================================="
echo "Meme Troller - GitHub Publishing Wizard"
echo "        (macOS Edition)"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: git is not installed${NC}"
    echo ""
    echo "Please install git first:"
    echo "  brew install git"
    echo "  or download from: https://git-scm.com/download/mac"
    exit 1
fi

echo -e "${GREEN}✓ Git is installed (version $(git --version | cut -d' ' -f3))${NC}"
echo ""

# Get user's GitHub username
echo -e "${YELLOW}Step 1: GitHub Account Information${NC}"
echo ""
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
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo -e "${YELLOW}Step 2: Initializing Git Repository${NC}"
echo ""

# Initialize git if not already done
if [ ! -d ".git" ]; then
    git init
    echo -e "${GREEN}✓ Git repository initialized${NC}"
else
    echo -e "${GREEN}✓ Git repository already exists${NC}"
fi

# Configure git if needed
GIT_NAME=$(git config user.name 2>/dev/null || echo "")
GIT_EMAIL=$(git config user.email 2>/dev/null || echo "")

if [ -z "$GIT_NAME" ]; then
    echo ""
    read -p "Enter your name for git commits: " INPUT_NAME
    git config user.name "$INPUT_NAME"
    echo -e "${GREEN}✓ Git user name configured${NC}"
fi

if [ -z "$GIT_EMAIL" ]; then
    echo ""
    read -p "Enter your email for git commits: " INPUT_EMAIL
    git config user.email "$INPUT_EMAIL"
    echo -e "${GREEN}✓ Git user email configured${NC}"
fi

echo ""
echo -e "${YELLOW}Step 3: Staging Files${NC}"
echo ""

# Add all files
git add .
echo -e "${GREEN}✓ All files staged${NC}"

# Show what will be committed
FILE_COUNT=$(git status --short | wc -l | xargs)
echo -e "${BLUE}   Files to commit: ${FILE_COUNT}${NC}"

echo ""
echo -e "${YELLOW}Step 4: Creating Initial Commit${NC}"
echo ""

# Check if there are any commits
if ! git rev-parse HEAD >/dev/null 2>&1; then
    # No commits yet, create initial commit
    git commit -m "Initial commit: Meme Troller v1.0.0

- User authentication with admin approval
- Meme posting (images, GIFs, videos)  
- Comment system with media attachments
- Reaction system with multiple types
- Gamification with badges and leaderboard
- Customizable banner system (NEW!)
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
    echo -e "${YELLOW}ℹ  Commits already exist, skipping initial commit${NC}"
fi

echo ""
echo -e "${YELLOW}Step 5: Setting Up Remote Repository${NC}"
echo ""
echo "Now you need to create the repository on GitHub."
echo ""
echo -e "${BLUE}Please follow these steps:${NC}"
echo ""
echo "1. Open this URL in your browser:"
echo -e "   ${GREEN}https://github.com/new${NC}"
echo ""
echo "2. Fill in the form:"
echo "   - Repository name: ${REPO_NAME}"
echo "   - Description: Self-hosted meme-sharing platform with gamification"
echo "   - Choose: Public (recommended) or Private"
echo "   - ⚠️  IMPORTANT: Leave all checkboxes UNCHECKED"
echo "     (Don't add README, .gitignore, or license)"
echo ""
echo "3. Click 'Create repository'"
echo ""
echo -e "${YELLOW}Opening GitHub in your browser...${NC}"

# Open GitHub new repo page in default browser (macOS specific)
sleep 2
open "https://github.com/new" 2>/dev/null || echo "Please manually open: https://github.com/new"

echo ""
read -p "Press ENTER once you've created the repository on GitHub..."

echo ""
echo -e "${YELLOW}Step 6: Connecting to GitHub${NC}"
echo ""

# Add remote
REMOTE_URL="https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"

# Check if remote exists
if git remote get-url origin >/dev/null 2>&1; then
    echo -e "${YELLOW}ℹ  Remote 'origin' already exists. Updating...${NC}"
    git remote set-url origin "$REMOTE_URL"
else
    git remote add origin "$REMOTE_URL"
fi

echo -e "${GREEN}✓ Remote repository configured${NC}"
echo "   URL: $REMOTE_URL"

echo ""
echo -e "${YELLOW}Step 7: Authentication Setup${NC}"
echo ""
echo "To push to GitHub, you need to authenticate."
echo ""
echo "Choose your authentication method:"
echo ""
echo "1. Personal Access Token (PAT) - Recommended for first time"
echo "2. SSH Keys - If you have them set up"
echo "3. I already have credentials configured"
echo ""
read -p "Choose (1/2/3): " AUTH_CHOICE

if [ "$AUTH_CHOICE" = "1" ]; then
    echo ""
    echo -e "${BLUE}Setting up Personal Access Token:${NC}"
    echo ""
    echo "1. Opening GitHub token creation page..."
    sleep 2
    open "https://github.com/settings/tokens/new?description=Meme%20Troller%20Deploy&scopes=repo" 2>/dev/null
    echo ""
    echo "2. On the GitHub page:"
    echo "   - Description: 'Meme Troller Deploy' (already filled)"
    echo "   - Expiration: Choose your preference (90 days recommended)"
    echo "   - Scopes: Check 'repo' (should be checked already)"
    echo "   - Click 'Generate token' at the bottom"
    echo "   - ⚠️  COPY THE TOKEN IMMEDIATELY (you won't see it again!)"
    echo ""
    echo "3. Return here and continue"
    echo ""
    read -p "Press ENTER once you have copied your token..."
    echo ""
    echo -e "${YELLOW}When prompted for password, paste your token${NC}"
    
elif [ "$AUTH_CHOICE" = "2" ]; then
    echo ""
    echo -e "${BLUE}Using SSH authentication${NC}"
    echo ""
    
    # Check if SSH key exists
    if [ -f "$HOME/.ssh/id_ed25519.pub" ] || [ -f "$HOME/.ssh/id_rsa.pub" ]; then
        echo -e "${GREEN}✓ SSH key found${NC}"
        
        # Switch to SSH URL
        REMOTE_URL="git@github.com:${GITHUB_USERNAME}/${REPO_NAME}.git"
        git remote set-url origin "$REMOTE_URL"
        echo -e "${GREEN}✓ Switched to SSH remote${NC}"
    else
        echo -e "${YELLOW}No SSH key found. Generating one...${NC}"
        echo ""
        read -p "Enter your email for SSH key: " SSH_EMAIL
        ssh-keygen -t ed25519 -C "$SSH_EMAIL" -f "$HOME/.ssh/id_ed25519" -N ""
        echo ""
        echo -e "${GREEN}✓ SSH key generated${NC}"
        echo ""
        echo "Your public key:"
        cat "$HOME/.ssh/id_ed25519.pub"
        echo ""
        echo "Opening GitHub SSH settings..."
        open "https://github.com/settings/ssh/new" 2>/dev/null
        echo ""
        echo "Add this key to GitHub:"
        echo "1. Title: Meme Troller Deploy"
        echo "2. Key: (paste the key shown above)"
        echo "3. Click 'Add SSH key'"
        echo ""
        read -p "Press ENTER once you've added the key to GitHub..."
        
        # Switch to SSH URL
        REMOTE_URL="git@github.com:${GITHUB_USERNAME}/${REPO_NAME}.git"
        git remote set-url origin "$REMOTE_URL"
        echo -e "${GREEN}✓ Switched to SSH remote${NC}"
    fi
else
    echo ""
    echo -e "${GREEN}✓ Using existing credentials${NC}"
fi

echo ""
echo -e "${YELLOW}Step 8: Pushing to GitHub${NC}"
echo ""
echo "Ready to push your code to GitHub!"
echo ""
read -p "Push now? (y/n): " PUSH_CONFIRM

if [[ "$PUSH_CONFIRM" = "y" || "$PUSH_CONFIRM" = "Y" ]]; then
    # Rename branch to main if needed
    CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || git symbolic-ref --short HEAD 2>/dev/null || echo "")
    if [ "$CURRENT_BRANCH" != "main" ] && [ -n "$CURRENT_BRANCH" ]; then
        git branch -M main
        echo -e "${GREEN}✓ Branch renamed to 'main'${NC}"
    fi
    
    # Push to GitHub
    echo ""
    echo "Pushing to GitHub..."
    echo ""
    
    if git push -u origin main 2>&1; then
        echo ""
        echo ""
        echo "=========================================="
        echo -e "${GREEN}        ✓✓✓ SUCCESS! ✓✓✓${NC}"
        echo "=========================================="
        echo ""
        echo -e "🎉 ${GREEN}Meme Troller is now on GitHub!${NC}"
        echo ""
        echo "Repository: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
        echo ""
        echo -e "${BLUE}Next steps:${NC}"
        echo ""
        echo "1. Visit your repository (opening in browser...)"
        sleep 1
        open "https://github.com/${GITHUB_USERNAME}/${REPO_NAME}" 2>/dev/null
        echo ""
        echo "2. Add topics/tags:"
        echo "   - Click ⚙️ next to 'About'"
        echo "   - Add: memes, flask, docker, raspberry-pi, python, self-hosted"
        echo ""
        echo "3. Enable Issues & Discussions:"
        echo "   - Settings → Features → Check boxes"
        echo ""
        echo "4. Create first release (v1.0.0):"
        echo "   - Releases → Draft new release"
        echo ""
        echo "See GITHUB_SETUP.md for more details!"
        echo ""
        echo "=========================================="
        echo ""
        
    else
        EXIT_CODE=$?
        echo ""
        echo ""
        echo -e "${RED}✗ Push failed (exit code: $EXIT_CODE)${NC}"
        echo ""
        echo -e "${YELLOW}Common solutions:${NC}"
        echo ""
        echo "1. Authentication failed:"
        echo "   - If using PAT: Make sure you pasted the token correctly"
        echo "   - Try running: git push -u origin main"
        echo "   - When prompted, enter your token as password"
        echo ""
        echo "2. Repository doesn't exist:"
        echo "   - Make sure you created it on GitHub"
        echo "   - Check: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
        echo ""
        echo "3. Repository already has content:"
        echo "   - Run: git pull origin main --allow-unrelated-histories"
        echo "   - Then: git push -u origin main"
        echo ""
        echo "4. Need to use SSH instead:"
        echo "   - Run this script again and choose option 2"
        echo ""
        echo "For more help, see: PUBLISHING_GUIDE.md"
        echo ""
        exit 1
    fi
else
    echo ""
    echo "Push cancelled."
    echo ""
    echo "You can push later with:"
    echo "  git push -u origin main"
    echo ""
fi

echo ""
echo "=========================================="
echo "Publishing script complete!"
echo "=========================================="
