# 🚀 Meme Troller - Complete Setup Guide

## Welcome to Meme Troller!

**Your headquarters for community chaos - Troll smarter, not harder!**

This guide will walk you through everything from installation to customization.

## 🎯 What is Meme Troller?

Meme Troller is a self-hosted meme-sharing platform designed for communities that want to have fun trolling their HOAs, local organizations, or just share memes privately. Think of it as your own private Reddit/9GAG with:

- ✅ Complete privacy (you control everything)
- ✅ Gamification (points, badges, leaderboards)
- ✅ Customizable branding (make it yours!)
- ✅ Admin approval system (keep out the Karens)
- ✅ Runs on Raspberry Pi (affordable & efficient)

## 🆕 What's New in v1.0.0

### Customizable Banner Feature
The killer feature! As admin, you can now:
- Enable/disable a custom banner across the entire site
- Set your own text: "Trolling [Your Community] Since 2025"
- Choose your banner color to match your vibe
- Update it anytime from the Settings page

### Multiple Taglines
The footer now rotates between four epic taglines:
- "Your headquarters for community chaos"
- "Troll smarter, not harder"
- "Professional meme warfare"
- "Where communities come to chaos"

## 📦 What's Included

- **Complete web application** with Flask backend
- **10 responsive templates** for all pages
- **SQLite database** (simple, file-based)
- **Docker containerization** (easy deployment)
- **Comprehensive documentation** (you're reading it!)
- **Admin panel** with full control
- **Gamification system** (6 badge tiers, special badges)
- **Customizable branding** (NEW!)

## 🚀 Installation

### Quick Start (60 seconds)

```bash
# 1. Extract the files
tar -xzf meme-troller.tar.gz
cd meme-troller

# 2. Run the start script
./start.sh

# 3. Open browser to http://localhost:5000

# 4. Register as admin (first user = admin!)

# 5. Go to Settings and customize your banner!
```

### Detailed Installation

#### Prerequisites
- Raspberry Pi 4 (2GB+ RAM) or any Linux system
- Docker installed
- Docker Compose installed
- 16GB+ storage (SD card or USB SSD)

#### Step 1: Install Docker (if needed)

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Install Docker Compose
sudo apt install docker-compose -y

# Log out and back in
```

#### Step 2: Deploy Application

```bash
# Navigate to the directory
cd meme-troller

# Start the application
./start.sh
```

The script will:
- ✅ Check Docker installation
- ✅ Create necessary directories
- ✅ Build the Docker image
- ✅ Start the container
- ✅ Display access URLs

#### Step 3: First-Time Setup

1. **Access the application**: http://your-pi-ip:5000
2. **Register immediately**: First user becomes admin!
3. **Fill out registration**:
   - Choose a memorable username
   - Use a strong password
   - Provide valid email

4. **You're now the admin!** You'll see extra menu items:
   - Admin (user management)
   - Settings (site customization)

## 🎨 Customizing Your Site

### Setting Up Your Banner

This is the BEST part! Make it personal:

1. **Login as admin**
2. **Click "Settings"** in the navbar
3. **Configure your banner**:
   - ✅ Toggle "Enable Banner"
   - ✅ Set your text (e.g., "Trolling Sunnyvale HOA Since 2025")
   - ✅ Pick your color (try #ff6b35 for classic, or go wild!)
   - ✅ See live preview
4. **Save Settings**

**Pro Banner Ideas:**
```
"Trolling [Community Name] Since 2025"
"[Community Name] Meme Headquarters"  
"Where [Community Name] Comes to Chaos"
"[HOA Name]'s Worst Nightmare"
"Making [Community] Great Again... with Memes"
"Official [Community] Troll Central"
"[Community Name]: Where Karens Come to Cry"
```

### Changing Site Name

In Settings, you can also change "Meme Troller" to something else:
- Your community name + "Memes"
- "The [Community] Troll Station"
- Keep it as "Meme Troller"
- Get creative!

## 👥 Managing Users

### Approving New Members

1. **Users register** on the site
2. **You get notified** (check Admin panel)
3. **Review pending users**:
   - Admin Panel → Pending Approvals
   - See username, email, registration date
4. **Approve or Delete**:
   - Approve: User can now post
   - Delete: Removes registration

### User Management

In the Admin Panel, you can:
- ✅ View all users
- ✅ See their points and activity
- ✅ Delete users (and all their content)
- ✅ Monitor for suspicious activity

## 📊 Understanding the Gamification

### How Points Work

| Action | Points Earned |
|--------|--------------|
| Post a meme | 10 points |
| Write a comment | 3 points |
| Someone reacts to your post | 2 points |
| Someone reacts to your comment | 1 point |

### Badge Progression

Users progress through tiers:

1. **Lurker** (0-49 pts) - Just getting started
2. **Meme Dabbler** (50-99 pts) - Contributing
3. **Shitposter** (100-249 pts) - Regular contributor
4. **Meme Wizard** (250-499 pts) - Dedicated member
5. **Dank Master** (500-999 pts) - Elite status
6. **Meme Lord** (1000+ pts) - THE GOAL 👑

### Special Badges

Earned by specific achievements:

- **First Blood** 🩸 - Post the very first meme
- **Early Adopter** 🌟 - Be in the first 10 members
- **Certified Troll** 👾 - Make 50+ comments
- **Comment Goblin** 🧌 - Make 100+ comments
- **Reaction Whore** 💯 - Get 100+ reactions on your posts
- **Night Owl** 🦉 - Post 5+ memes between midnight-5am

### The Leaderboard

- Shows top 20 users by points
- Updates in real-time
- Displays badges and special achievements
- Creates friendly competition

## 🎪 Content Moderation

### Content Policy

Built-in disclaimer states:
- ✅ Memes and jokes allowed
- ✅ Freedom of speech supported
- ❌ No pornographic content
- ❌ No violent/gory imagery

### Moderating Content

As admin, you can:

**Delete Posts:**
- View any post → Click "Delete" button
- Removes post and file from server
- User keeps their points

**Ban Users:**
- Admin Panel → All Users → Delete
- Removes user and ALL their content
- Cannot delete admin users

## 🔧 Configuration & Maintenance

### Changing the Port

Edit `docker-compose.yml`:
```yaml
ports:
  - "8080:5000"  # Change 8080 to your preferred port
```

Then restart:
```bash
docker-compose down
docker-compose up -d
```

### Backup Your Data

**Critical files to backup:**
```bash
# Database
instance/memetroller.db

# Uploaded content
static/uploads/

# Create backup
tar -czf memetroller-backup-$(date +%Y%m%d).tar.gz \
    instance/ static/uploads/
```

**Restore from backup:**
```bash
tar -xzf memetroller-backup-YYYYMMDD.tar.gz
```

### Updating the Application

```bash
cd meme-troller
git pull  # if using git
docker-compose down
docker-compose up -d --build
```

### Viewing Logs

```bash
# View logs
docker-compose logs -f

# Check if running
docker-compose ps

# Restart
docker-compose restart
```

## 🌐 Making It Internet-Accessible

### Option 1: Local Network Only
- No extra setup needed
- Users access via: `http://your-pi-ip:5000`
- Safe and simple

### Option 2: Internet Access (with domain)

**Requirements:**
- Domain name (bvmemes.com, trollcentral.com, etc.)
- Router with port forwarding
- Static IP or dynamic DNS

**Setup:**

1. **Port forward** on your router:
   - External: 80 → Internal: your-pi-ip:5000

2. **Point DNS** to your public IP:
   - A record: yourdomain.com → your-public-ip

3. **Optional: Add SSL** with Nginx + Let's Encrypt
   - See RASPBERRY_PI_SETUP.md for full guide

## 🎯 Best Practices

### Security
- ✅ Change default SSH password
- ✅ Use SSH keys instead of passwords
- ✅ Enable firewall (ufw)
- ✅ Keep system updated
- ✅ Use strong admin password
- ✅ Regular backups

### Performance
- ✅ Use USB SSD instead of SD card
- ✅ Enable swap if needed (2GB)
- ✅ Monitor disk space
- ✅ Clean up old backups

### Community Building
- ✅ Approve users quickly
- ✅ Post regularly to set example
- ✅ Engage with comments
- ✅ Update banner seasonally
- ✅ Celebrate milestones

## 🐛 Troubleshooting

### Application Won't Start
```bash
# Check Docker
docker ps

# View logs
docker-compose logs

# Restart
docker-compose down
docker-compose up -d
```

### Can't Access from Network
```bash
# Check if port is open
sudo netstat -tulpn | grep 5000

# Check firewall
sudo ufw status

# Allow port
sudo ufw allow 5000/tcp
```

### Database Issues
```bash
# Stop app
docker-compose down

# Backup database
cp instance/memetroller.db instance/backup.db

# Check integrity
sqlite3 instance/memetroller.db "PRAGMA integrity_check;"

# Restart
docker-compose up -d
```

### Out of Disk Space
```bash
# Check usage
df -h

# Clean Docker
docker system prune -a

# Check uploads
du -sh static/uploads
```

## 📱 Mobile Access

The site is fully responsive and works great on phones:

- **Portrait mode**: Single column, easy scrolling
- **Touch-friendly**: Large buttons and targets
- **Swipe navigation**: Smooth experience
- **Optimized images**: Fast loading

Perfect for doom scrolling memes on the go!

## 🎉 Success Checklist

Your setup is complete when you can:

- [ ] Access site from browser
- [ ] Register and login as admin
- [ ] See "Admin" and "Settings" in navbar
- [ ] Customize banner in Settings
- [ ] Post a meme successfully
- [ ] Add a comment with image
- [ ] React to content
- [ ] See points awarded correctly
- [ ] View leaderboard
- [ ] Approve a test user
- [ ] Access from mobile device

## 🚀 Next Steps

Now that you're set up:

1. **Customize your banner** - Make it yours!
2. **Invite your community** - Share the registration link
3. **Post the first meme** - Earn "First Blood" badge
4. **Set expectations** - Share content policy
5. **Have fun!** - Let the trolling begin

## 📚 Additional Resources

- **RASPBERRY_PI_SETUP.md** - Advanced Pi configuration
- **PROJECT_OVERVIEW.md** - Technical architecture
- **QUICK_REFERENCE.md** - Common commands
- **DEPLOYMENT_CHECKLIST.md** - Pre-launch checklist

## 💬 Need Help?

- Check logs: `docker-compose logs`
- Review documentation in the repo
- Open an issue on GitHub
- Check existing issues for solutions

## 🎊 You're Ready!

Everything is configured and ready to troll! Remember:

- **Approve users promptly** - Keep engagement high
- **Update your banner** - Keep it fresh and relevant
- **Engage with content** - Set the tone for your community
- **Have fun!** - That's what it's all about

---

**Happy Trolling! 🔥**

*From the Meme Troller team: Troll smarter, not harder.*
