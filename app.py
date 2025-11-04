from flask import Flask, render_template, request, redirect, url_for, flash, session, jsonify, send_file
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
from werkzeug.utils import secure_filename
from datetime import datetime, timedelta
from functools import wraps
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger
import os
import secrets
import tarfile
import tempfile
import shutil
import requests
import json

app = Flask(__name__)
app.config['SECRET_KEY'] = secrets.token_hex(32)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///memetroller.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['UPLOAD_FOLDER'] = 'static/uploads'
app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024  # 50MB max file size

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'mp4', 'webm', 'mov'}

db = SQLAlchemy(app)

# Site taglines that rotate
TAGLINES = [
    "Your headquarters for community chaos",
    "Troll smarter, not harder",
    "Professional meme warfare",
    "Where communities come to chaos"
]

# Context processor to make current_user available in all templates
@app.context_processor
def inject_user():
    import random
    if 'user_id' in session:
        current_user = User.query.get(session['user_id'])
        site_settings = SiteSettings.get_settings()
        return dict(
            current_user=current_user, 
            site_settings=site_settings,
            random_tagline=random.choice(TAGLINES)
        )
    site_settings = SiteSettings.get_settings()
    return dict(
        current_user=None, 
        site_settings=site_settings,
        random_tagline=random.choice(TAGLINES)
    )

# Database Models
class SiteSettings(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    banner_enabled = db.Column(db.Boolean, default=True)
    banner_text = db.Column(db.String(200), default="Trolling HOAs Since 2025")
    banner_color = db.Column(db.String(20), default="#ff6b35")
    site_name = db.Column(db.String(100), default="Meme Troller")
    
    @staticmethod
    def get_settings():
        settings = SiteSettings.query.first()
        if not settings:
            settings = SiteSettings()
            db.session.add(settings)
            db.session.commit()
        return settings

class BackupSettings(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    enabled = db.Column(db.Boolean, default=False)
    provider = db.Column(db.String(50), default='local')  # local, gdrive, pcloud
    schedule_type = db.Column(db.String(20), default='daily')  # daily, weekly, custom
    backup_time = db.Column(db.String(10), default='02:00')  # HH:MM format
    days_of_week = db.Column(db.String(50), default='monday')  # comma-separated
    keep_backups = db.Column(db.Integer, default=5)
    local_path = db.Column(db.String(255), default='/backups')
    gdrive_folder_id = db.Column(db.String(255))
    gdrive_credentials = db.Column(db.Text)  # JSON credentials
    pcloud_username = db.Column(db.String(255))
    pcloud_password = db.Column(db.String(255))
    pcloud_folder = db.Column(db.String(255), default='/memetroller-backups')
    last_backup = db.Column(db.DateTime)
    
    @staticmethod
    def get_settings():
        settings = BackupSettings.query.first()
        if not settings:
            settings = BackupSettings()
            db.session.add(settings)
            db.session.commit()
        return settings

class BackupHistory(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    filename = db.Column(db.String(255), nullable=False)
    file_size = db.Column(db.Integer)  # bytes
    backup_type = db.Column(db.String(50))  # manual, scheduled
    provider = db.Column(db.String(50))  # local, gdrive, pcloud
    status = db.Column(db.String(20), default='success')  # success, failed
    error_message = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    def get_size_mb(self):
        if self.file_size:
            return round(self.file_size / (1024 * 1024), 2)
        return 0
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    is_approved = db.Column(db.Boolean, default=False)
    is_admin = db.Column(db.Boolean, default=False)
    points = db.Column(db.Integer, default=0)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    posts = db.relationship('Post', backref='author', lazy=True, cascade='all, delete-orphan')
    comments = db.relationship('Comment', backref='author', lazy=True, cascade='all, delete-orphan')
    reactions = db.relationship('Reaction', backref='user', lazy=True, cascade='all, delete-orphan')

    def get_badge(self):
        if self.points >= 1000:
            return 'Meme Lord'
        elif self.points >= 500:
            return 'Dank Master'
        elif self.points >= 250:
            return 'Meme Wizard'
        elif self.points >= 100:
            return 'Shitposter'
        elif self.points >= 50:
            return 'Meme Dabbler'
        else:
            return 'Lurker'

    def get_special_badges(self):
        badges = []
        
        # First Blood
        first_post = Post.query.order_by(Post.created_at).first()
        if first_post and first_post.user_id == self.id:
            badges.append('First Blood')
        
        # Certified Troll
        comment_count = Comment.query.filter_by(user_id=self.id).count()
        if comment_count >= 50:
            badges.append('Certified Troll')
        if comment_count >= 100:
            badges.append('Comment Goblin')
        
        # Reaction Whore
        reaction_count = sum(len(post.reactions) for post in self.posts)
        if reaction_count >= 100:
            badges.append('Reaction Whore')
        
        # Night Owl
        night_posts = Post.query.filter_by(user_id=self.id).filter(
            db.func.strftime('%H', Post.created_at).between('00', '05')
        ).count()
        if night_posts >= 5:
            badges.append('Night Owl')
        
        # Early Adopter
        early_users = User.query.order_by(User.created_at).limit(10).all()
        if self in early_users:
            badges.append('Early Adopter')
        
        return badges

class Post(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    filename = db.Column(db.String(255), nullable=False)
    file_type = db.Column(db.String(10), nullable=False)  # image, gif, video
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    comments = db.relationship('Comment', backref='post', lazy=True, cascade='all, delete-orphan')
    reactions = db.relationship('Reaction', backref='post', lazy=True, cascade='all, delete-orphan')

class Comment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    content = db.Column(db.Text, nullable=True)
    filename = db.Column(db.String(255), nullable=True)  # For image/gif replies
    file_type = db.Column(db.String(10), nullable=True)
    post_id = db.Column(db.Integer, db.ForeignKey('post.id'), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    reactions = db.relationship('CommentReaction', backref='comment', lazy=True, cascade='all, delete-orphan')

class Reaction(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    reaction_type = db.Column(db.String(20), nullable=False)  # like, laugh, fire, skull, etc.
    post_id = db.Column(db.Integer, db.ForeignKey('post.id'), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

class CommentReaction(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    reaction_type = db.Column(db.String(20), nullable=False)
    comment_id = db.Column(db.Integer, db.ForeignKey('comment.id'), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

# Helper functions
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def get_file_type(filename):
    ext = filename.rsplit('.', 1)[1].lower()
    if ext in {'mp4', 'webm', 'mov'}:
        return 'video'
    elif ext == 'gif':
        return 'gif'
    else:
        return 'image'

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            flash('Please log in to access this page.', 'warning')
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

def approved_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            flash('Please log in to access this page.', 'warning')
            return redirect(url_for('login'))
        user = User.query.get(session['user_id'])
        if not user.is_approved and not user.is_admin:
            flash('Your account is pending approval.', 'warning')
            return redirect(url_for('pending_approval'))
        return f(*args, **kwargs)
    return decorated_function

def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            flash('Please log in to access this page.', 'warning')
            return redirect(url_for('login'))
        user = User.query.get(session['user_id'])
        if not user.is_admin:
            flash('Admin access required.', 'danger')
            return redirect(url_for('index'))
        return f(*args, **kwargs)
    return decorated_function

def award_points(user, action):
    points_map = {
        'post': 10,
        'comment': 3,
        'receive_reaction_post': 2,
        'receive_reaction_comment': 1
    }
    user.points += points_map.get(action, 0)
    db.session.commit()

# Backup Service
class BackupService:
    @staticmethod
    def create_backup(backup_type='manual'):
        """Create a backup of database and uploads"""
        try:
            settings = BackupSettings.get_settings()
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
            filename = f'memetroller_backup_{timestamp}.tar.gz'
            
            # Create temporary directory for backup
            temp_dir = tempfile.mkdtemp()
            backup_path = os.path.join(temp_dir, filename)
            
            # Create tar.gz archive
            with tarfile.open(backup_path, 'w:gz') as tar:
                # Add database
                db_path = os.path.join('instance', 'memetroller.db')
                if os.path.exists(db_path):
                    tar.add(db_path, arcname='memetroller.db')
                
                # Add uploads
                uploads_path = 'static/uploads'
                if os.path.exists(uploads_path):
                    tar.add(uploads_path, arcname='uploads')
            
            # Get file size
            file_size = os.path.getsize(backup_path)
            
            # Upload to selected provider
            success = False
            error_msg = None
            
            if settings.provider == 'local':
                success, error_msg = BackupService._save_local(backup_path, filename, settings)
            elif settings.provider == 'gdrive':
                success, error_msg = BackupService._save_gdrive(backup_path, filename, settings)
            elif settings.provider == 'pcloud':
                success, error_msg = BackupService._save_pcloud(backup_path, filename, settings)
            
            # Record in history
            history = BackupHistory(
                filename=filename,
                file_size=file_size,
                backup_type=backup_type,
                provider=settings.provider,
                status='success' if success else 'failed',
                error_message=error_msg
            )
            db.session.add(history)
            
            # Update last backup time
            if success:
                settings.last_backup = datetime.utcnow()
            
            db.session.commit()
            
            # Cleanup temp directory
            shutil.rmtree(temp_dir)
            
            # Cleanup old backups
            if success:
                BackupService._cleanup_old_backups(settings)
            
            return success, error_msg
            
        except Exception as e:
            return False, str(e)
    
    @staticmethod
    def _save_local(backup_path, filename, settings):
        """Save backup to local directory"""
        try:
            os.makedirs(settings.local_path, exist_ok=True)
            dest_path = os.path.join(settings.local_path, filename)
            shutil.copy2(backup_path, dest_path)
            return True, None
        except Exception as e:
            return False, str(e)
    
    @staticmethod
    def _save_gdrive(backup_path, filename, settings):
        """Save backup to Google Drive"""
        try:
            if not settings.gdrive_credentials:
                return False, "Google Drive credentials not configured"
            
            from google.oauth2.credentials import Credentials
            from googleapiclient.discovery import build
            from googleapiclient.http import MediaFileUpload
            
            # Parse credentials
            creds_data = json.loads(settings.gdrive_credentials)
            creds = Credentials.from_authorized_user_info(creds_data)
            
            service = build('drive', 'v3', credentials=creds)
            
            file_metadata = {
                'name': filename,
                'parents': [settings.gdrive_folder_id] if settings.gdrive_folder_id else []
            }
            
            media = MediaFileUpload(backup_path, resumable=True)
            file = service.files().create(
                body=file_metadata,
                media_body=media,
                fields='id'
            ).execute()
            
            return True, None
        except Exception as e:
            return False, str(e)
    
    @staticmethod
    def _save_pcloud(backup_path, filename, settings):
        """Save backup to pCloud"""
        try:
            if not settings.pcloud_username or not settings.pcloud_password:
                return False, "pCloud credentials not configured"
            
            # pCloud API login
            login_url = 'https://api.pcloud.com/userinfo'
            login_params = {
                'username': settings.pcloud_username,
                'password': settings.pcloud_password,
                'getauth': 1
            }
            
            response = requests.get(login_url, params=login_params)
            data = response.json()
            
            if data.get('result') != 0:
                return False, f"pCloud login failed: {data.get('error', 'Unknown error')}"
            
            auth_token = data.get('auth')
            
            # Create folder if it doesn't exist
            folder_path = settings.pcloud_folder
            create_folder_url = 'https://api.pcloud.com/createfolderifnotexists'
            folder_params = {
                'auth': auth_token,
                'path': folder_path
            }
            requests.get(create_folder_url, params=folder_params)
            
            # Upload file
            upload_url = 'https://api.pcloud.com/uploadfile'
            upload_params = {
                'auth': auth_token,
                'path': folder_path,
                'filename': filename
            }
            
            with open(backup_path, 'rb') as f:
                files = {'file': f}
                response = requests.post(upload_url, params=upload_params, files=files)
                data = response.json()
                
                if data.get('result') != 0:
                    return False, f"pCloud upload failed: {data.get('error', 'Unknown error')}"
            
            return True, None
        except Exception as e:
            return False, str(e)
    
    @staticmethod
    def _cleanup_old_backups(settings):
        """Remove old backups beyond keep_backups limit"""
        try:
            # Get all backup history, ordered by date
            backups = BackupHistory.query.filter_by(
                provider=settings.provider,
                status='success'
            ).order_by(BackupHistory.created_at.desc()).all()
            
            # Keep only the specified number
            backups_to_delete = backups[settings.keep_backups:]
            
            for backup in backups_to_delete:
                # Delete from storage
                if settings.provider == 'local':
                    file_path = os.path.join(settings.local_path, backup.filename)
                    if os.path.exists(file_path):
                        os.remove(file_path)
                # TODO: Implement deletion for gdrive and pcloud
                
                # Delete from history
                db.session.delete(backup)
            
            db.session.commit()
        except Exception as e:
            print(f"Cleanup error: {e}")

# Initialize scheduler
scheduler = BackgroundScheduler()
scheduler.start()

def schedule_backups():
    """Setup scheduled backups based on settings"""
    try:
        settings = BackupSettings.get_settings()
        
        # Remove existing backup jobs
        for job in scheduler.get_jobs():
            if job.id == 'backup_job':
                scheduler.remove_job('backup_job')
        
        if not settings.enabled:
            return
        
        # Parse time
        hour, minute = map(int, settings.backup_time.split(':'))
        
        # Setup cron trigger based on schedule type
        if settings.schedule_type == 'daily':
            trigger = CronTrigger(hour=hour, minute=minute)
        elif settings.schedule_type == 'weekly':
            days = settings.days_of_week.split(',')
            day_map = {
                'monday': 0, 'tuesday': 1, 'wednesday': 2,
                'thursday': 3, 'friday': 4, 'saturday': 5, 'sunday': 6
            }
            day_numbers = [day_map[d.strip().lower()] for d in days if d.strip().lower() in day_map]
            trigger = CronTrigger(day_of_week=','.join(map(str, day_numbers)), hour=hour, minute=minute)
        else:
            return
        
        scheduler.add_job(
            func=lambda: BackupService.create_backup('scheduled'),
            trigger=trigger,
            id='backup_job',
            replace_existing=True
        )
    except Exception as e:
        print(f"Error scheduling backups: {e}")

# Routes
@app.route('/')
def index():
    posts = Post.query.order_by(Post.created_at.desc()).all()
    return render_template('index.html', posts=posts)

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form.get('username')
        email = request.form.get('email')
        password = request.form.get('password')
        
        if User.query.filter_by(username=username).first():
            flash('Username already exists.', 'danger')
            return redirect(url_for('register'))
        
        if User.query.filter_by(email=email).first():
            flash('Email already registered.', 'danger')
            return redirect(url_for('register'))
        
        user = User(
            username=username,
            email=email,
            password_hash=generate_password_hash(password)
        )
        
        # First user becomes admin
        if User.query.count() == 0:
            user.is_admin = True
            user.is_approved = True
        
        db.session.add(user)
        db.session.commit()
        
        flash('Registration successful! Please wait for admin approval.', 'success')
        return redirect(url_for('login'))
    
    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        
        user = User.query.filter_by(username=username).first()
        
        if user and check_password_hash(user.password_hash, password):
            session['user_id'] = user.id
            flash('Login successful!', 'success')
            return redirect(url_for('index'))
        else:
            flash('Invalid username or password.', 'danger')
    
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.pop('user_id', None)
    flash('Logged out successfully.', 'success')
    return redirect(url_for('index'))

@app.route('/pending')
@login_required
def pending_approval():
    user = User.query.get(session['user_id'])
    if user.is_approved or user.is_admin:
        return redirect(url_for('index'))
    return render_template('pending.html')

@app.route('/post/new', methods=['GET', 'POST'])
@approved_required
def new_post():
    if request.method == 'POST':
        title = request.form.get('title')
        file = request.files.get('file')
        
        if not file or not allowed_file(file.filename):
            flash('Invalid file type. Please upload an image, GIF, or video.', 'danger')
            return redirect(url_for('new_post'))
        
        filename = secure_filename(file.filename)
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        filename = f"{timestamp}_{filename}"
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)
        
        post = Post(
            title=title,
            filename=filename,
            file_type=get_file_type(filename),
            user_id=session['user_id']
        )
        db.session.add(post)
        db.session.commit()
        
        user = User.query.get(session['user_id'])
        award_points(user, 'post')
        
        flash('Meme posted successfully!', 'success')
        return redirect(url_for('index'))
    
    return render_template('new_post.html')

@app.route('/post/<int:post_id>')
def view_post(post_id):
    post = Post.query.get_or_404(post_id)
    return render_template('view_post.html', post=post)

@app.route('/post/<int:post_id>/comment', methods=['POST'])
@approved_required
def add_comment(post_id):
    post = Post.query.get_or_404(post_id)
    content = request.form.get('content')
    file = request.files.get('file')
    
    filename = None
    file_type = None
    
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        filename = f"{timestamp}_{filename}"
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)
        file_type = get_file_type(filename)
    
    comment = Comment(
        content=content,
        filename=filename,
        file_type=file_type,
        post_id=post_id,
        user_id=session['user_id']
    )
    db.session.add(comment)
    db.session.commit()
    
    user = User.query.get(session['user_id'])
    award_points(user, 'comment')
    
    return redirect(url_for('view_post', post_id=post_id))

@app.route('/post/<int:post_id>/react', methods=['POST'])
@approved_required
def react_to_post(post_id):
    post = Post.query.get_or_404(post_id)
    reaction_type = request.form.get('reaction_type')
    
    existing = Reaction.query.filter_by(
        post_id=post_id,
        user_id=session['user_id'],
        reaction_type=reaction_type
    ).first()
    
    if existing:
        db.session.delete(existing)
        db.session.commit()
    else:
        reaction = Reaction(
            reaction_type=reaction_type,
            post_id=post_id,
            user_id=session['user_id']
        )
        db.session.add(reaction)
        db.session.commit()
        
        award_points(post.author, 'receive_reaction_post')
    
    return redirect(url_for('view_post', post_id=post_id))

@app.route('/comment/<int:comment_id>/react', methods=['POST'])
@approved_required
def react_to_comment(comment_id):
    comment = Comment.query.get_or_404(comment_id)
    reaction_type = request.form.get('reaction_type')
    
    existing = CommentReaction.query.filter_by(
        comment_id=comment_id,
        user_id=session['user_id'],
        reaction_type=reaction_type
    ).first()
    
    if existing:
        db.session.delete(existing)
        db.session.commit()
    else:
        reaction = CommentReaction(
            reaction_type=reaction_type,
            comment_id=comment_id,
            user_id=session['user_id']
        )
        db.session.add(reaction)
        db.session.commit()
        
        award_points(comment.author, 'receive_reaction_comment')
    
    return redirect(url_for('view_post', post_id=comment.post_id))

@app.route('/leaderboard')
def leaderboard():
    users = User.query.filter_by(is_approved=True).order_by(User.points.desc()).limit(20).all()
    return render_template('leaderboard.html', users=users)

@app.route('/profile/<username>')
def profile(username):
    user = User.query.filter_by(username=username).first_or_404()
    posts = Post.query.filter_by(user_id=user.id).order_by(Post.created_at.desc()).all()
    return render_template('profile.html', user=user, posts=posts)

@app.route('/admin')
@admin_required
def admin_panel():
    pending_users = User.query.filter_by(is_approved=False, is_admin=False).all()
    all_users = User.query.filter_by(is_admin=False).all()
    all_posts = Post.query.order_by(Post.created_at.desc()).all()
    return render_template('admin.html', pending_users=pending_users, all_users=all_users, all_posts=all_posts)

@app.route('/admin/approve/<int:user_id>')
@admin_required
def approve_user(user_id):
    user = User.query.get_or_404(user_id)
    user.is_approved = True
    db.session.commit()
    flash(f'User {user.username} approved!', 'success')
    return redirect(url_for('admin_panel'))

@app.route('/admin/delete_user/<int:user_id>')
@admin_required
def delete_user(user_id):
    user = User.query.get_or_404(user_id)
    if user.is_admin:
        flash('Cannot delete admin users.', 'danger')
        return redirect(url_for('admin_panel'))
    db.session.delete(user)
    db.session.commit()
    flash(f'User {user.username} deleted!', 'success')
    return redirect(url_for('admin_panel'))

@app.route('/admin/delete_post/<int:post_id>')
@admin_required
def delete_post(post_id):
    post = Post.query.get_or_404(post_id)
    
    # Delete file
    filepath = os.path.join(app.config['UPLOAD_FOLDER'], post.filename)
    if os.path.exists(filepath):
        os.remove(filepath)
    
    db.session.delete(post)
    db.session.commit()
    flash('Post deleted!', 'success')
    return redirect(url_for('admin_panel'))

@app.route('/admin/settings', methods=['GET', 'POST'])
@admin_required
def site_settings():
    settings = SiteSettings.get_settings()
    
    if request.method == 'POST':
        settings.banner_enabled = 'banner_enabled' in request.form
        settings.banner_text = request.form.get('banner_text', settings.banner_text)
        settings.banner_color = request.form.get('banner_color', settings.banner_color)
        settings.site_name = request.form.get('site_name', settings.site_name)
        db.session.commit()
        flash('Site settings updated!', 'success')
        return redirect(url_for('site_settings'))
    
    return render_template('site_settings.html', settings=settings)

@app.route('/admin/backup-settings', methods=['GET', 'POST'])
@admin_required
def backup_settings():
    settings = BackupSettings.get_settings()
    
    if request.method == 'POST':
        settings.enabled = 'enabled' in request.form
        settings.provider = request.form.get('provider', 'local')
        settings.schedule_type = request.form.get('schedule_type', 'daily')
        settings.backup_time = request.form.get('backup_time', '02:00')
        settings.days_of_week = request.form.get('days_of_week', 'monday')
        settings.keep_backups = int(request.form.get('keep_backups', 5))
        settings.local_path = request.form.get('local_path', '/backups')
        settings.gdrive_folder_id = request.form.get('gdrive_folder_id', '')
        settings.pcloud_username = request.form.get('pcloud_username', '')
        settings.pcloud_password = request.form.get('pcloud_password', '')
        settings.pcloud_folder = request.form.get('pcloud_folder', '/memetroller-backups')
        
        db.session.commit()
        
        # Reschedule backups
        schedule_backups()
        
        flash('Backup settings updated!', 'success')
        return redirect(url_for('backup_settings'))
    
    # Get backup history
    history = BackupHistory.query.order_by(BackupHistory.created_at.desc()).limit(10).all()
    
    return render_template('backup_settings.html', settings=settings, history=history)

@app.route('/admin/backup-now', methods=['POST'])
@admin_required
def backup_now():
    success, error = BackupService.create_backup('manual')
    
    if success:
        flash('Backup created successfully!', 'success')
    else:
        flash(f'Backup failed: {error}', 'danger')
    
    return redirect(url_for('backup_settings'))

@app.route('/admin/test-backup-connection', methods=['POST'])
@admin_required
def test_backup_connection():
    settings = BackupSettings.get_settings()
    provider = request.form.get('provider', settings.provider)
    
    try:
        if provider == 'local':
            path = request.form.get('local_path', settings.local_path)
            os.makedirs(path, exist_ok=True)
            test_file = os.path.join(path, 'test.txt')
            with open(test_file, 'w') as f:
                f.write('test')
            os.remove(test_file)
            return jsonify({'success': True, 'message': 'Local path is accessible'})
        
        elif provider == 'pcloud':
            username = request.form.get('pcloud_username')
            password = request.form.get('pcloud_password')
            
            if not username or not password:
                return jsonify({'success': False, 'message': 'Username and password required'})
            
            login_url = 'https://api.pcloud.com/userinfo'
            response = requests.get(login_url, params={
                'username': username,
                'password': password,
                'getauth': 1
            })
            data = response.json()
            
            if data.get('result') == 0:
                return jsonify({'success': True, 'message': 'pCloud connection successful!'})
            else:
                return jsonify({'success': False, 'message': f"pCloud error: {data.get('error', 'Unknown')}"})
        
        elif provider == 'gdrive':
            return jsonify({'success': False, 'message': 'Google Drive requires OAuth setup - save settings first'})
        
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)})
    
    return jsonify({'success': False, 'message': 'Unknown provider'})

if __name__ == '__main__':
    os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)
    with app.app_context():
        db.create_all()
        schedule_backups()  # Initialize backup scheduler
    app.run(host='0.0.0.0', port=5000, debug=True)
