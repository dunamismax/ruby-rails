# Contributing to Ruby Rails Monorepo

Thank you for your interest in contributing to the Ruby Rails Monorepo! This guide will help you get started with contributing to this project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Issue Reporting](#issue-reporting)
- [Security](#security)

## Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

### Our Standards

- Use welcoming and inclusive language
- Be respectful of differing viewpoints and experiences
- Gracefully accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

## Getting Started

### Prerequisites

- Ruby 3.3.0 or higher
- Bundler 2.0+
- Node.js (for Rails applications)
- SQLite3 (for development)
- Git

### Development Setup

1. **Fork the repository**
   ```bash
   git clone https://github.com/your-username/ruby-rails.git
   cd ruby-rails
   ```

2. **Set up the development environment**
   ```bash
   ruby scripts/development/bootstrap.rb
   ```

3. **Install dependencies**
   ```bash
   bundle install
   ```

4. **Run the test suite**
   ```bash
   ruby scripts/development/test_runner.rb
   ```

## How to Contribute

### Types of Contributions

We welcome several types of contributions:

1. **Bug Reports** - Help us identify and fix issues
2. **Feature Requests** - Suggest new features or improvements
3. **Code Contributions** - Fix bugs, add features, or improve existing code
4. **Documentation** - Improve or add documentation
5. **Testing** - Add or improve test coverage
6. **Performance** - Optimize code performance

### Contribution Workflow

1. **Check existing issues** to see if your contribution idea already exists
2. **Create an issue** to discuss your contribution idea
3. **Fork the repository** and create a feature branch
4. **Make your changes** following our coding standards
5. **Write tests** for your changes
6. **Submit a pull request** with a clear description

## Development Setup

### Monorepo Structure

```
ruby-rails/
├── apps/                    # Individual applications
│   ├── dunamismax/         # Personal blog/portfolio
│   ├── apiplayground/      # API testing environment
│   ├── blog_generator/     # CLI tool
│   ├── file_organizer/     # CLI tool
│   └── code_stats/         # CLI tool
├── gems/                   # Shared libraries
│   └── shared_utilities/   # Common utilities
├── scripts/                # Development scripts
└── .github/                # CI/CD configuration
```

### Working with Applications

Each application in the `apps/` directory is independent:

```bash
# Work with a specific app
cd apps/dunamismax
bundle install
bundle exec rails server

# Run tests for a specific app
cd apps/apiplayground
bundle exec rails test
```

### Working with Shared Libraries

The `gems/` directory contains shared libraries:

```bash
# Work with shared utilities
cd gems/shared_utilities
bundle install
bundle exec rspec
```

## Coding Standards

### Ruby Style Guide

We follow the [Ruby Style Guide](https://rubystyle.guide/) with some modifications:

- **Line Length**: Maximum 120 characters
- **String Literals**: Use double quotes
- **Method Length**: Maximum 20 lines
- **Class Length**: Maximum 150 lines

### Rails Conventions

- Follow Rails conventions and best practices
- Use Rails generators when appropriate
- Keep controllers thin, models fat
- Use concerns for shared functionality

### Security Best Practices

- Validate and sanitize all user inputs
- Use parameterized queries to prevent SQL injection
- Implement proper authentication and authorization
- Handle errors gracefully without exposing sensitive information

## Testing

### Test Requirements

All contributions must include appropriate tests:

- **Unit tests** for individual methods and classes
- **Integration tests** for API endpoints
- **Security tests** for input validation
- **Performance tests** for optimization changes

### Running Tests

```bash
# Run all tests
ruby scripts/development/test_runner.rb

# Run tests for specific components
ruby scripts/development/test_runner.rb --apps dunamismax
ruby scripts/development/test_runner.rb --gems shared_utilities

# Run with verbose output
ruby scripts/development/test_runner.rb --verbose
```

### Test Coverage

We aim for comprehensive test coverage:

- Minimum 80% code coverage for new features
- 100% coverage for security-related code
- Test both success and failure scenarios
- Include edge cases and error conditions

## Pull Request Process

### Before Submitting

1. **Update your branch** with the latest changes from main
2. **Run the full test suite** and ensure all tests pass
3. **Run code quality checks**:
   ```bash
   bundle exec rubocop
   bundle exec brakeman
   ```
4. **Update documentation** if needed
5. **Update the changelog** if your changes are user-facing

### Pull Request Guidelines

1. **Title**: Use a clear, descriptive title
2. **Description**: Include:
   - What changes were made
   - Why the changes were needed
   - How to test the changes
   - Any breaking changes
3. **Size**: Keep PRs focused and reasonably sized
4. **Tests**: Include comprehensive test coverage
5. **Documentation**: Update relevant documentation

### Review Process

1. **Automated checks** must pass (CI/CD pipeline)
2. **Code review** by at least one maintainer
3. **Security review** for security-related changes
4. **Testing** on different environments if needed
5. **Merge** after approval

## Issue Reporting

### Bug Reports

When reporting bugs, please include:

- **Description**: Clear description of the issue
- **Steps to reproduce**: Detailed steps to recreate the bug
- **Expected behavior**: What should happen
- **Actual behavior**: What actually happens
- **Environment**: Ruby version, OS, etc.
- **Screenshots**: If applicable

### Feature Requests

When suggesting features, please include:

- **Use case**: Why is this feature needed?
- **Proposed solution**: How should it work?
- **Alternatives**: Any alternative approaches considered?
- **Additional context**: Any other relevant information

## Security

### Security Issues

- **Do not** open public issues for security vulnerabilities
- **Email** security concerns to security@dunamismax.dev
- **Include** detailed information about the vulnerability
- **Follow** responsible disclosure practices

### Security Testing

When contributing security-related changes:

- Include comprehensive security tests
- Test for common vulnerabilities (XSS, SQL injection, etc.)
- Validate input sanitization
- Check authentication and authorization

## Code Quality

### Automated Checks

All contributions go through automated checks:

- **RuboCop** for code style
- **Brakeman** for security vulnerabilities
- **Bundler Audit** for dependency vulnerabilities
- **Test Coverage** reporting

### Manual Review

Code is also manually reviewed for:

- Code quality and maintainability
- Security best practices
- Performance implications
- Documentation completeness

## Development Scripts

Use the provided development scripts:

```bash
# Bootstrap the entire monorepo
ruby scripts/development/bootstrap.rb

# Run all tests
ruby scripts/development/test_runner.rb

# Clean up temporary files
ruby scripts/maintenance/cleanup.rb

# Deploy (dry run)
ruby scripts/deployment/deploy.rb --dry-run
```

## Getting Help

If you need help:

1. **Check the documentation** in README.md
2. **Search existing issues** on GitHub
3. **Ask questions** in issue comments
4. **Join discussions** in pull requests

## Recognition

Contributors are recognized in several ways:

- **GitHub contributors** page
- **CHANGELOG.md** mentions
- **README.md** acknowledgments
- **Release notes** credits

## License

By contributing to this project, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to the Ruby Rails Monorepo! Your contributions help make this project better for everyone.