# Meme Troller - Quick Reference

## Quick Start Commands

```bash
# Start application
docker-compose up -d

# Stop application
docker-compose down

# View logs
docker-compose logs -f

# Restart application
docker-compose restart

# Rebuild and start
docker-compose up -d --build

# Check status
docker-compose ps
```

## Important URLs

- **Main Site**: http://localhost:5000
- **Admin Panel**: http://localhost:5000/admin
- **Leaderboard**: http://localhost:5000/leaderboard

## File Locations

- **Database**: `instance/memetroller.db`
- **Uploads**: `static/uploads/`
- **Config**: `docker-compose.yml`
- **Logs**: `docker-compose logs`

## Backup & Restore

```bash
# Quick backup
tar -czf backup.tar.gz static/uploads instance/

# Restore
tar -xzf backup.tar.gz
```

## Common Issues

| Issue | Solution |
|-------|----------|
| Port already in use | Change port in docker-compose.yml |
| Can't upload files | Check uploads folder permissions |
| Database locked | Restart container: `docker-compose restart` |
| Out of memory | Reduce memory limit in docker-compose.yml |

## User Management

- **First user** = Automatic admin
- **Approve users**: Admin Panel → Pending Approvals
- **Delete user**: Admin Panel → All Users → Delete

## Content Moderation

- **Delete post**: View post → Delete button (admin only)
- **Ban user**: Admin Panel → Delete User

## Points System

| Action | Points |
|--------|--------|
| Post meme | 10 |
| Comment | 3 |
| Receive post reaction | 2 |
| Receive comment reaction | 1 |

## Badge Tiers

| Badge | Points Required |
|-------|----------------|
| Lurker | 0-49 |
| Meme Dabbler | 50-99 |
| Shitposter | 100-249 |
| Meme Wizard | 250-499 |
| Dank Master | 500-999 |
| **Meme Lord** | 1000+ |

## Special Badges

- **First Blood** - Post the first meme
- **Certified Troll** - 50+ comments
- **Comment Goblin** - 100+ comments
- **Reaction Whore** - Get 100+ reactions
- **Night Owl** - Post 5+ memes at 12am-5am
- **Early Adopter** - First 10 members

## Maintenance Schedule

- **Daily**: Check logs
- **Weekly**: Check disk space
- **Monthly**: Full backup
- **Quarterly**: Update Docker images

## Emergency Contacts

- Docker: https://docs.docker.com
- Flask: https://flask.palletsprojects.com
- Bootstrap: https://getbootstrap.com

## Support Commands

```bash
# System info
docker version
docker-compose version
df -h

# Performance check
docker stats memetroller
htop

# Network check
netstat -tulpn | grep 5000
curl localhost:5000

# Cleanup
docker system prune -a
```

---

**For detailed instructions, see README.md or RASPBERRY_PI_SETUP.md**
