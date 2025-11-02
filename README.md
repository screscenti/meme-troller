# 🔥 Meme Troller

<div align="center">

![Python](https://img.shields.io/badge/python-3.11-blue.svg)
![Flask](https://img.shields.io/badge/flask-3.0-green.svg)
![Docker](https://img.shields.io/badge/docker-ready-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-Raspberry%20Pi%204-red.svg)

**Your headquarters for community chaos - Troll smarter, not harder!**

[Features](#features) • [Quick Start](#quick-start) • [Documentation](#documentation) • [Contributing](#contributing)

</div>

---

## 🎯 Overview

Meme Troller is a self-hosted meme-sharing platform perfect for communities that want to have fun trolling their HOAs, local organizations, or just share memes privately. Built with gamification at its core, featuring user authentication with admin approval, a comprehensive badge and points system, support for images/GIFs/videos, and fully customizable branding with an admin-configurable banner. Optimized to run efficiently on a Raspberry Pi 4!

### Why Meme Troller?

- 🏠 **Perfect for HOA trolling** - Customizable banner to target your specific community
- 🎮 **Gamified experience** - Points, badges, and leaderboards keep users engaged
- 🔒 **Privacy-focused** - Self-hosted, you control your data
- 📱 **Mobile-first** - Doom scroll on any device
- ⚡ **Lightweight** - Runs smoothly on Raspberry Pi
- 🎨 **Fully customizable** - Make it your own with the admin panel

## ✨ Features

### 🔐 User Management
- User registration with admin approval workflow
- Secure authentication system
- User profiles with detailed statistics
- First registered user automatically becomes admin

### 📱 Content Sharing
- Upload images, GIFs, and videos (up to 50MB)
- Title and organize your memes
- Comment system with optional media attachments
- Multiple reaction types: 🔥 😂 💀 🤔 😤

### 🏆 Gamification
- **Points System**: Earn points for posting, commenting, and receiving reactions
- **Badge Tiers**: Progress from Lurker → Meme Dabbler → Shitposter → Meme Wizard → Dank Master → **Meme Lord**
- **Special Badges**: First Blood, Certified Troll, Comment Goblin, Reaction Whore, Night Owl, Early Adopter
- **Live Leaderboard**: Real-time rankings of top contributors

### 🎨 Customizable Branding (NEW!)
- **Admin-configurable banner** - Set your community name and trolling target
- **Custom colors** - Match your community's vibe
- **Site name customization** - Make it yours
- **Rotating taglines** - Keep it fresh

### 🛡️ Admin Panel
- Approve or reject new user registrations
- Content moderation tools
- Delete posts or ban users
- **Configure site settings and banner**
- View comprehensive statistics

## 🚀 Quick Start

### Prerequisites
- Raspberry Pi 4 (2GB+ RAM) or any Linux system
- Docker and Docker Compose installed

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/meme-troller.git
cd meme-troller

# Deploy with one command
./start.sh
```

Access your site at `http://localhost:5000`

**⚠️ Important**: Register your admin account immediately! The first user becomes admin.

### First Steps

1. **Register as admin** (first user)
2. **Go to Settings** → Customize your banner
3. **Approve users** as they register
4. **Post the first meme** and earn "First Blood" badge!

## 🎨 Banner Customization

Make it personal! As admin, set your custom banner:

1. Navigate to **Settings** (navbar)
2. Enable the banner
3. Set your text: "Trolling [Your Community] Since 2025"
4. Pick your color
5. Save and watch it appear site-wide!

**Banner Ideas:**
- "Trolling Sunnyvale HOA Since 2025"
- "Maple Grove Meme Headquarters"
- "Where Pinewood Community Comes to Chaos"
- "Riverside HOA's Worst Nightmare"

## 🎮 Gamification System

### Points
| Action | Points |
|--------|--------|
| Post a meme | 10 pts |
| Comment | 3 pts |
| Receive post reaction | 2 pts |
| Receive comment reaction | 1 pt |

### Badge Tiers
| Badge | Points Required |
|-------|----------------|
| 🆕 Lurker | 0-49 |
| 🎨 Meme Dabbler | 50-99 |
| 💩 Shitposter | 100-249 |
| 🧙 Meme Wizard | 250-499 |
| 😈 Dank Master | 500-999 |
| 👑 Meme Lord | 1000+ |

### Special Badges
- 🩸 First Blood | 👾 Certified Troll | 🧌 Comment Goblin
- 💯 Reaction Whore | 🦉 Night Owl | 🌟 Early Adopter

## 📖 Documentation

- **[RASPBERRY_PI_SETUP.md](RASPBERRY_PI_SETUP.md)** - Detailed Pi deployment
- **[PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md)** - Architecture details
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Command cheat sheet
- **[DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)** - Step-by-step guide

## 🛠️ Tech Stack

- **Backend**: Python 3.11, Flask 3.0
- **Database**: SQLite
- **Frontend**: Bootstrap 5, Font Awesome 6
- **Deployment**: Docker & Docker Compose

## 🌐 Production Deployment

For internet-facing deployments:
1. Use a reverse proxy (Nginx/Caddy)
2. Enable HTTPS with Let's Encrypt
3. Configure firewall rules
4. Set up regular backups

See [RASPBERRY_PI_SETUP.md](RASPBERRY_PI_SETUP.md) for details.

## 🤝 Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push and open a Pull Request

## 📝 Roadmap

- [ ] Email notifications
- [ ] Image compression
- [ ] Search functionality
- [ ] Meme categories
- [ ] Private messaging
- [ ] REST API
- [ ] Discord webhooks

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

Built with Flask, Bootstrap, and Font Awesome. Designed for the HOA trolling community 😈

## 💬 Support

- **Issues**: Bug reports and feature requests
- **Discussions**: Questions and community chat
- **Wiki**: Additional guides and tips

---

<div align="center">

**Professional meme warfare - Troll smarter, not harder**

Made with ❤️ and a healthy dose of chaos

</div>
