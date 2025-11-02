# Raspberry Pi 4 Deployment Guide

This guide will help you deploy Meme Troller on your Raspberry Pi 4.

## Prerequisites

### 1. Raspberry Pi Setup
- Raspberry Pi 4 (2GB RAM minimum, 4GB+ recommended)
- Raspberry Pi OS (64-bit recommended)
- Static IP address configured
- SSH access enabled
- Internet connection

### 2. Install Docker

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add your user to docker group
sudo usermod -aG docker $USER

# Install Docker Compose
sudo apt install docker-compose -y

# Verify installation
docker --version
docker-compose --version

# Log out and back in for group changes to take effect
```

## Deployment Steps

### 1. Transfer Files to Raspberry Pi

**Option A: Using SCP (from your computer)**
```bash
# Assuming files are in a folder called 'bvmemes'
scp -r bvmemes pi@your-pi-ip:/home/pi/
```

**Option B: Using Git (if you have a repo)**
```bash
ssh pi@your-pi-ip
cd /home/pi
git clone your-repo-url bvmemes
cd bvmemes
```

**Option C: Manual copy via SFTP/FileZilla**
- Connect to your Pi using FileZilla or similar
- Copy the entire bvmemes folder to `/home/pi/`

### 2. Deploy the Application

```bash
# SSH into your Pi
ssh pi@your-pi-ip

# Navigate to the application directory
cd /home/pi/bvmemes

# Run the startup script
./start.sh
```

The script will:
- Check for Docker installation
- Create necessary directories
- Build the Docker image
- Start the application
- Display access URLs

### 3. Access the Application

The application will be available at:
- Local: http://localhost:5000
- Network: http://[your-pi-ip]:5000
- Domain: http://bvmemes.com (after DNS setup)

**IMPORTANT**: Register your admin account immediately after deployment!

## Network Configuration

### Option 1: Local Network Access Only

No additional configuration needed. Users on your local network can access via:
`http://[pi-ip]:5000`

### Option 2: Internet Access (Port Forwarding)

1. **Configure Router Port Forwarding:**
   - Log into your router admin panel
   - Forward port 80 (or 443 for HTTPS) to your Pi's port 5000
   - Example: External Port 80 → Internal IP [pi-ip] Port 5000

2. **Setup Dynamic DNS (if you don't have static IP):**
   - Use services like No-IP, DuckDNS, or Cloudflare
   - Update your domain's A record to point to your public IP

### Option 3: Reverse Proxy with SSL (Recommended for Internet)

Install and configure Nginx with Let's Encrypt:

```bash
# Install Nginx
sudo apt install nginx -y

# Install Certbot for SSL
sudo apt install certbot python3-certbot-nginx -y

# Create Nginx configuration
sudo nano /etc/nginx/sites-available/bvmemes

# Add this configuration:
```

```nginx
server {
    listen 80;
    server_name bvmemes.com www.bvmemes.com;
    
    client_max_body_size 50M;
    
    location / {
        proxy_pass http://localhost:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

```bash
# Enable the site
sudo ln -s /etc/nginx/sites-available/bvmemes /etc/nginx/sites-enabled/

# Test Nginx configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx

# Get SSL certificate (after DNS is pointed to your IP)
sudo certbot --nginx -d bvmemes.com -d www.bvmemes.com
```

## Performance Optimization

### 1. Use Fast Storage
```bash
# Check if using SD card
lsblk

# Consider moving Docker storage to USB SSD
# Edit Docker daemon config
sudo nano /etc/docker/daemon.json
```

Add:
```json
{
  "data-root": "/mnt/usb-ssd/docker"
}
```

### 2. Enable Swap (if needed)
```bash
# Check current swap
free -h

# Create 2GB swap file
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Make permanent
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

### 3. Set Resource Limits

Edit `docker-compose.yml`:
```yaml
services:
  web:
    # ... existing config ...
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 1G
        reservations:
          memory: 512M
```

## Auto-Start on Boot

### Option 1: Docker Auto-restart (Already configured)
The `restart: unless-stopped` in docker-compose.yml handles this.

### Option 2: Systemd Service (More control)

Create service file:
```bash
sudo nano /etc/systemd/system/bvmemes.service
```

Add:
```ini
[Unit]
Description=Meme Troller Docker Compose
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/home/pi/bvmemes
ExecStart=/usr/bin/docker-compose up -d
ExecStop=/usr/bin/docker-compose down
User=pi

[Install]
WantedBy=multi-user.target
```

Enable:
```bash
sudo systemctl enable bvmemes.service
sudo systemctl start bvmemes.service
```

## Monitoring and Maintenance

### View Application Logs
```bash
cd /home/pi/bvmemes
docker-compose logs -f
```

### Check Resource Usage
```bash
# Overall system
htop

# Docker stats
docker stats bvmemes
```

### Backup Script

Create `/home/pi/backup-bvmemes.sh`:
```bash
#!/bin/bash
BACKUP_DIR="/home/pi/backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR
cd /home/pi/bvmemes

# Stop the application
docker-compose down

# Create backup
tar -czf $BACKUP_DIR/bvmemes-backup-$DATE.tar.gz \
    static/uploads \
    instance/bvmemes.db

# Start the application
docker-compose up -d

# Keep only last 7 backups
cd $BACKUP_DIR
ls -t bvmemes-backup-*.tar.gz | tail -n +8 | xargs -r rm

echo "Backup completed: bvmemes-backup-$DATE.tar.gz"
```

Make executable and add to cron:
```bash
chmod +x /home/pi/backup-bvmemes.sh

# Add to crontab (daily at 3 AM)
crontab -e
# Add line:
0 3 * * * /home/pi/backup-bvmemes.sh >> /home/pi/backup.log 2>&1
```

## Troubleshooting

### Application won't start
```bash
# Check Docker service
sudo systemctl status docker

# Check logs
docker-compose logs

# Restart everything
docker-compose down
docker-compose up -d
```

### Out of disk space
```bash
# Check disk usage
df -h

# Clean Docker
docker system prune -a

# Check uploads folder size
du -sh /home/pi/bvmemes/static/uploads
```

### High CPU/Memory usage
```bash
# Check what's using resources
htop

# Reduce Docker memory limit in docker-compose.yml
# Add under 'web' service:
deploy:
  resources:
    limits:
      memory: 512M
```

### Can't access from network
```bash
# Check if port is open
sudo netstat -tulpn | grep 5000

# Check firewall (if enabled)
sudo ufw status
sudo ufw allow 5000/tcp

# Test from another device
curl http://[pi-ip]:5000
```

### Database corruption
```bash
cd /home/pi/bvmemes

# Stop application
docker-compose down

# Backup current DB
cp instance/bvmemes.db instance/bvmemes.db.backup

# Try to repair (if using SQLite)
sqlite3 instance/bvmemes.db "PRAGMA integrity_check;"

# If corrupt, restore from backup or start fresh
# rm instance/bvmemes.db

# Restart
docker-compose up -d
```

## Security Recommendations

1. **Change default SSH port**
2. **Use SSH keys instead of password**
3. **Enable firewall (ufw)**
4. **Keep system updated**: `sudo apt update && sudo apt upgrade`
5. **Use strong passwords for admin account**
6. **Enable HTTPS with Let's Encrypt**
7. **Regular backups**
8. **Monitor logs for suspicious activity**

## Updates

To update the application:
```bash
cd /home/pi/bvmemes
docker-compose down
# Update files (git pull or copy new files)
docker-compose up -d --build
```

## Additional Tips

- **Temperature Monitoring**: Raspberry Pi 4 can get hot under load
  ```bash
  vcgencmd measure_temp
  ```
  
- **Consider a case with fan or heatsinks**

- **Use quality power supply** (official Raspberry Pi power supply recommended)

- **Ethernet preferred over WiFi** for stability

## Getting Help

If you encounter issues:
1. Check logs: `docker-compose logs`
2. Check system resources: `htop`
3. Check network: `ping 8.8.8.8`
4. Verify Docker: `docker ps`

---

**Your meme platform is ready to troll! 🎉**
