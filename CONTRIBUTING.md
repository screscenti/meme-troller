# Contributing to Meme Troller

First off, thanks for taking the time to contribute! 🎉

The following is a set of guidelines for contributing to Meme Troller. These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

## Code of Conduct

This project and everyone participating in it is governed by our commitment to creating a welcoming and inclusive environment. By participating, you are expected to uphold this standard.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples** (screenshots, error messages, logs)
- **Describe the behavior you observed** and what you expected
- **Include details about your environment** (OS, Docker version, Python version)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- **Use a clear and descriptive title**
- **Provide a detailed description** of the suggested enhancement
- **Explain why this enhancement would be useful**
- **List any similar features** in other applications (if applicable)

### Pull Requests

- Fill in the required template
- Follow the Python style guide (PEP 8)
- Include comments in your code where necessary
- Update documentation for any changed functionality
- Add tests if applicable
- Ensure all tests pass before submitting

## Development Setup

1. **Fork and clone the repository**
   ```bash
   git clone https://github.com/yourusername/bvmemes.git
   cd bvmemes
   ```

2. **Create a development environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   ```

3. **Run the application locally**
   ```bash
   python app.py
   ```

4. **Make your changes and test**
   - Test on multiple screen sizes
   - Verify mobile responsiveness
   - Check for console errors
   - Test database operations

## Style Guidelines

### Python Code Style
- Follow PEP 8
- Use meaningful variable and function names
- Add docstrings to functions
- Keep functions focused and small
- Use type hints where appropriate

### HTML/CSS Style
- Use semantic HTML
- Keep CSS organized and commented
- Follow Bootstrap conventions
- Ensure mobile-first responsive design
- Test on multiple browsers

### Git Commit Messages
- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests after the first line

Example:
```
Add user profile badge display

- Display badge tier on user profiles
- Add tooltip with badge description
- Update profile page styling
- Fixes #123
```

## Project Structure

```
bvmemes/
├── app.py              # Main Flask application
├── templates/          # HTML templates
├── static/            # Static files (CSS, JS, uploads)
├── requirements.txt   # Python dependencies
├── Dockerfile         # Docker configuration
└── docs/             # Documentation
```

## Testing

Before submitting a PR:
- [ ] Test all modified features
- [ ] Verify no console errors
- [ ] Check responsive design on mobile
- [ ] Ensure Docker build succeeds
- [ ] Update documentation if needed
- [ ] Run the application and click through all pages

## Documentation

- Update README.md for user-facing changes
- Update technical documentation for architecture changes
- Add code comments for complex logic
- Update CHANGELOG.md with your changes

## Questions?

Feel free to open an issue with the "question" label if you need help or clarification.

## Recognition

Contributors will be recognized in:
- The project README
- Release notes
- The hall of fame (if we create one!)

Thank you for contributing! 🚀
