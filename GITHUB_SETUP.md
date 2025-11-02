# Publishing to GitHub - Setup Guide

Follow these steps to publish Meme Troller to GitHub and set up the repository.

## Step 1: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `bvmemes` (or your preferred name)
3. Description: "Self-hosted meme-sharing platform with gamification"
4. Choose: **Public** (or Private if you prefer)
5. **DO NOT** initialize with README, .gitignore, or license (we have these)
6. Click "Create repository"

## Step 2: Prepare Local Repository

In your `bvmemes` directory:

```bash
cd bvmemes

# Replace the README with GitHub version
mv README.md README_ORIGINAL.md
mv README_GITHUB.md README.md

# Initialize git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Meme Troller v1.0.0

- User authentication with admin approval
- Meme posting (images, GIFs, videos)
- Comment system with media
- Reaction system
- Gamification with badges and leaderboard
- Admin panel
- Mobile-responsive design
- Docker deployment
- Complete documentation"
```

## Step 3: Connect to GitHub

Replace `yourusername` with your GitHub username:

```bash
# Add remote repository
git remote add origin https://github.com/yourusername/bvmemes.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 4: Configure Repository Settings

### About Section
1. Go to your repository on GitHub
2. Click the ⚙️ (gear icon) next to "About"
3. Add description: "Self-hosted meme-sharing platform with gamification, perfect for communities"
4. Add website: Your demo site URL (if you have one)
5. Add topics: `memes`, `flask`, `docker`, `raspberry-pi`, `gamification`, `python`, `self-hosted`

### Repository Settings

#### Enable Issues
1. Go to Settings → General
2. Under "Features", ensure "Issues" is checked

#### Enable Discussions (Optional)
1. Go to Settings → General
2. Under "Features", check "Discussions"
3. Set up categories:
   - General
   - Ideas
   - Q&A
   - Show and Tell

#### Branch Protection (Recommended)
1. Go to Settings → Branches
2. Add rule for `main` branch:
   - Require pull request reviews before merging
   - Require status checks to pass (after Actions are set up)
   - Require linear history

## Step 5: Create Initial Release

1. Go to Releases → Draft a new release
2. Click "Choose a tag" → Type `v1.0.0` → Create new tag
3. Release title: `v1.0.0 - Initial Release`
4. Description:
```markdown
## 🎉 Meme Troller v1.0.0 - Initial Release

First public release of Meme Troller, a self-hosted meme-sharing platform!

### Features
- ✅ User authentication with admin approval
- ✅ Post images, GIFs, and videos
- ✅ Comment system with media attachments
- ✅ Multiple reaction types
- ✅ Gamification system with 6 badge tiers
- ✅ Live leaderboard
- ✅ Admin panel for moderation
- ✅ Mobile-responsive design
- ✅ Docker deployment
- ✅ Optimized for Raspberry Pi 4

### Installation
```bash
git clone https://github.com/yourusername/bvmemes.git
cd bvmemes
./start.sh
```

See [README.md](README.md) for full documentation.

### What's Next?
Check out our [roadmap](README.md#-future-enhancements) for upcoming features!
```

5. Attach the `bvmemes.tar.gz` file as a binary
6. Check "Set as the latest release"
7. Click "Publish release"

## Step 6: Add Repository Badges (Optional)

Edit README.md and update the badge URLs if you want functional badges:

```markdown
![Build](https://github.com/yourusername/bvmemes/workflows/Docker%20Build%20Test/badge.svg)
![GitHub release](https://img.shields.io/github/v/release/yourusername/bvmemes)
![GitHub stars](https://img.shields.io/github/stars/yourusername/bvmemes)
![GitHub forks](https://img.shields.io/github/forks/yourusername/bvmemes)
```

## Step 7: Create Project Boards (Optional)

1. Go to Projects → New project
2. Choose "Board" template
3. Name: "Meme Troller Development"
4. Add columns:
   - Backlog
   - To Do
   - In Progress
   - In Review
   - Done

## Step 8: Set Up GitHub Pages (Optional)

If you want to host documentation:

1. Create a `docs` branch:
```bash
git checkout -b docs
# Add your documentation site
git push origin docs
```

2. Go to Settings → Pages
3. Source: Deploy from branch `docs`
4. Your docs will be at: `https://yourusername.github.io/bvmemes`

## Step 9: Add Collaborators

1. Go to Settings → Collaborators
2. Invite team members

## Step 10: Post-Publication Tasks

### Update README
- [ ] Add actual screenshots
- [ ] Update demo URL if you deploy one
- [ ] Add badge URLs with your username

### Community
- [ ] Post on Reddit (r/selfhosted, r/raspberry_pi)
- [ ] Share on Hacker News
- [ ] Post in relevant Discord servers
- [ ] Tweet about it

### Development
- [ ] Create a `develop` branch for ongoing work
- [ ] Set up CI/CD if desired
- [ ] Create issues for future enhancements
- [ ] Add to GitHub Explore

## Recommended Workflow

Going forward, use this workflow:

```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes and commit
git add .
git commit -m "Add new feature"

# Push to GitHub
git push origin feature/new-feature

# Create Pull Request on GitHub
# After review and approval, merge to main
```

## GitHub Repository Checklist

- [ ] Repository created on GitHub
- [ ] Code pushed to main branch
- [ ] README.md updated with correct links
- [ ] LICENSE file included
- [ ] .gitignore properly configured
- [ ] About section filled out
- [ ] Topics/tags added
- [ ] Issues enabled
- [ ] Branch protection configured
- [ ] Initial release published
- [ ] Contributing guidelines added
- [ ] Issue templates configured
- [ ] PR template added
- [ ] GitHub Actions working (optional)
- [ ] Collaborators invited
- [ ] Repository shared with community

## Need Help?

- GitHub Docs: https://docs.github.com
- Markdown Guide: https://guides.github.com/features/mastering-markdown/
- GitHub Actions: https://docs.github.com/en/actions

---

**Your project is now open source! 🎉**

Remember to:
- Respond to issues promptly
- Review PRs carefully
- Update documentation
- Be welcoming to contributors
- Have fun! 🚀
