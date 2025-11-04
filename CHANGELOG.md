# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.1] - 2025-11-04

### Added
- **Automated Backup System** - Comprehensive backup management
  - Admin-configurable backup settings
  - Support for multiple storage providers (Local, Google Drive, pCloud)
  - Flexible scheduling (Daily or specific days of week)
  - Configurable backup time
  - Retention policy (keep last 1-10 backups with auto-cleanup)
  - Manual "Backup Now" button
  - Backup history tracking with file sizes and status
  - Test connection feature for cloud providers
  - Backs up both database and uploaded media
  - Scheduled backups using APScheduler
- New dependencies: APScheduler, Google Drive API, requests

### Changed
- Enhanced admin navigation with Backups link
- Improved security with automated backup capabilities

### Fixed
- N/A

## [1.0.0] - 2025-11-02

### Added
- Initial release
- User authentication system with admin approval
- Meme posting (images, GIFs, videos)
- Comment system with media attachments
- Reaction system with multiple reaction types
- Gamification system with points and badges
- Leaderboard functionality
- Admin panel for user and content management
- Mobile-responsive design
- Docker containerization
- Comprehensive documentation
- Customizable banner system for community branding
- Site settings management

---

## Version History

### Version Numbering
- **MAJOR** version for incompatible API changes
- **MINOR** version for new functionality in a backwards compatible manner
- **PATCH** version for backwards compatible bug fixes

### Release Process
1. Update CHANGELOG.md with new version
2. Update version in app.py
3. Create git tag
4. Build and test Docker image
5. Create GitHub release
6. Announce to community
