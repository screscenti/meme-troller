# Meme Troller - Deployment Checklist

Use this checklist to ensure a smooth deployment of your meme platform!

## Pre-Deployment

### Hardware
- [ ] Raspberry Pi 4 (2GB+ RAM)
- [ ] Power supply (official recommended)
- [ ] MicroSD card (16GB+) or USB SSD (preferred)
- [ ] Ethernet cable (or WiFi configured)
- [ ] Case with cooling (fan/heatsinks recommended)

### Software Prerequisites
- [ ] Raspberry Pi OS installed (64-bit recommended)
- [ ] SSH enabled
- [ ] Static IP configured on Pi
- [ ] Internet connection working
- [ ] Docker installed
- [ ] Docker Compose installed

### Network Setup
- [ ] Pi has static local IP
- [ ] Port 5000 is not in use
- [ ] Router admin access (if exposing to internet)
- [ ] Domain registered (bvmemes.com)
- [ ] DNS configured (if using domain)

## Deployment Steps

### Step 1: Transfer Files
- [ ] Extract bvmemes.tar.gz on Raspberry Pi
- [ ] Navigate to `/home/pi/bvmemes` directory
- [ ] Verify all files present (`ls -la`)
- [ ] Make start.sh executable (`chmod +x start.sh`)

### Step 2: Initial Setup
- [ ] Review docker-compose.yml settings
- [ ] Check port mapping (default: 5000)
- [ ] Create backup strategy
- [ ] Note down Pi IP address

### Step 3: Deploy Application
- [ ] Run `./start.sh`
- [ ] Wait for Docker build to complete
- [ ] Verify container is running (`docker ps`)
- [ ] Check logs for errors (`docker-compose logs`)

### Step 4: First Access
- [ ] Open browser to `http://[pi-ip]:5000`
- [ ] Verify homepage loads
- [ ] Check for any error messages
- [ ] Test registration page loads

### Step 5: Create Admin Account
- [ ] **IMMEDIATELY** register first user
- [ ] Use strong password
- [ ] Verify admin status (check /admin access)
- [ ] Test posting a meme
- [ ] Verify upload works

## Post-Deployment

### Testing
- [ ] Register a test user (from different browser/incognito)
- [ ] Approve test user from admin panel
- [ ] Test user can post memes
- [ ] Test reactions work
- [ ] Test comments work
- [ ] Test leaderboard updates
- [ ] Test on mobile device
- [ ] Test video upload
- [ ] Test GIF upload

### Security
- [ ] Change SSH password
- [ ] Disable SSH password auth (use keys)
- [ ] Configure firewall if needed
- [ ] Review registered users
- [ ] Set up HTTPS (if exposing to internet)
- [ ] Review content policy

### Monitoring Setup
- [ ] Set up backup cron job
- [ ] Configure log rotation
- [ ] Set up disk space monitoring
- [ ] Test auto-restart (reboot Pi)
- [ ] Bookmark admin panel URL

### Documentation
- [ ] Save Pi IP address
- [ ] Document admin credentials (securely!)
- [ ] Note backup location
- [ ] Create user guide for community
- [ ] Share registration link with community

## Internet Exposure (Optional)

If making accessible from internet:

### DNS & Domain
- [ ] A record points to public IP
- [ ] Test domain resolves correctly
- [ ] Configure dynamic DNS (if needed)

### Router Configuration
- [ ] Port forwarding configured (80→5000 or 443→5000)
- [ ] Test external access
- [ ] Verify firewall rules

### Reverse Proxy (Recommended)
- [ ] Nginx or Caddy installed
- [ ] Configuration file created
- [ ] SSL certificate obtained (Let's Encrypt)
- [ ] HTTPS working
- [ ] HTTP→HTTPS redirect enabled
- [ ] Test from external network

## Maintenance Schedule

### Daily
- [ ] Check application is running
- [ ] Review new registrations
- [ ] Check for inappropriate content

### Weekly
- [ ] Review logs for errors
- [ ] Check disk space usage
- [ ] Verify backups are running
- [ ] Review leaderboard for anomalies

### Monthly
- [ ] Full backup verification
- [ ] Update Docker images
- [ ] Review user activity
- [ ] Clean up old logs
- [ ] Performance review

### Quarterly
- [ ] System updates (`apt upgrade`)
- [ ] Docker system cleanup
- [ ] Review security settings
- [ ] Community feedback review
- [ ] Consider feature additions

## Emergency Procedures

### Application Down
1. [ ] Check container status: `docker ps`
2. [ ] View logs: `docker-compose logs`
3. [ ] Restart: `docker-compose restart`
4. [ ] If persists: `docker-compose down && docker-compose up -d`

### Database Issues
1. [ ] Stop application
2. [ ] Backup database: `cp instance/bvmemes.db instance/backup.db`
3. [ ] Check integrity: `sqlite3 instance/bvmemes.db "PRAGMA integrity_check;"`
4. [ ] Restore from backup if needed
5. [ ] Restart application

### Disk Full
1. [ ] Check usage: `df -h`
2. [ ] Clean Docker: `docker system prune -a`
3. [ ] Review uploads: `du -sh static/uploads`
4. [ ] Archive old content
5. [ ] Consider larger storage

### Pi Won't Boot
1. [ ] Check power supply
2. [ ] Check SD card/USB drive
3. [ ] Boot from backup if available
4. [ ] Restore from backup
5. [ ] Investigate cause

## Success Criteria

Your deployment is successful when you can check all these:

- [ ] Application accessible via network
- [ ] Users can register
- [ ] Admin can approve users
- [ ] Approved users can post
- [ ] Reactions work
- [ ] Comments work
- [ ] Points are awarded
- [ ] Badges display correctly
- [ ] Leaderboard updates
- [ ] Uploads are saved
- [ ] Mobile interface works
- [ ] Admin panel accessible
- [ ] Application survives reboot
- [ ] Backups are working

## Rollback Plan

If something goes wrong:

1. [ ] Stop application: `docker-compose down`
2. [ ] Restore database: `cp instance/backup.db instance/bvmemes.db`
3. [ ] Restore uploads: `tar -xzf backup.tar.gz`
4. [ ] Start application: `docker-compose up -d`
5. [ ] Verify functionality
6. [ ] Document what went wrong

## Community Launch

When ready to go live:

- [ ] Announce to community
- [ ] Share registration link
- [ ] Explain content policy
- [ ] Highlight gamification features
- [ ] Post first meme yourself
- [ ] Monitor first few hours closely
- [ ] Be ready to approve users quickly
- [ ] Celebrate! 🎉

## Notes Section

Use this space for deployment-specific notes:

```
Deployment Date: _______________
Pi IP Address: _______________
Domain: _______________
Admin Username: _______________
Backup Location: _______________
First User Registered: _______________
Issues Encountered: _______________
___________________________________
___________________________________
```

---

**Take your time with each step. Better to deploy slowly and correctly than rush and have issues!**

Good luck, and happy memeing! 🚀
