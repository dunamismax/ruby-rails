<p align="center">
  <img src="rails.png" alt="Ruby Rails Monorepo Logo" width="400" />
</p>

<p align="center">
  <a href="https://github.com/dunamismax/ruby-rails">
    <img src="https://readme-typing-svg.demolab.com/?font=Fira+Code&size=24&pause=1000&color=CC342D&center=true&vCenter=true&width=800&lines=Ruby+Rails+Monorepo;Scalable+Development+Platform;Multi-App+Architecture;Shared+Libraries+%26+Utilities;Production-Ready+Ruby+Code." alt="Typing SVG" />
  </a>
</p>

<p align="center">
  <a href="https://www.ruby-lang.org/en/"><img src="https://img.shields.io/badge/Ruby-3.3.0+-red.svg?logo=ruby" alt="Ruby Version"></a>
  <a href="https://rubyonrails.org/"><img src="https://img.shields.io/badge/Rails-8.0.2+-red.svg?logo=rubyonrails" alt="Rails Version"></a>
  <a href="https://bundler.io/"><img src="https://img.shields.io/badge/Bundler-2.0+-blue.svg?logo=rubygems" alt="Bundler Version"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="MIT License"></a>
  <a href="https://github.com/dunamismax/ruby-rails/pulls"><img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" alt="PRs Welcome"></a>
  <a href="https://github.com/dunamismax/ruby-rails/stargazers"><img src="https://img.shields.io/github/stars/dunamismax/ruby-rails" alt="GitHub Stars"></a>
</p>

---

## About This Project

A **comprehensive Ruby on Rails monorepo** featuring production-quality applications, shared libraries, and utility scripts designed for scalable development. This repository demonstrates modern Ruby and Rails practices with a focus on code reuse, maintainability, and developer productivity.

**Key Features:**

- **Monorepo Architecture**: Multiple applications sharing common libraries and utilities
- **Production Quality**: Security-hardened, well-tested code following Ruby best practices
- **Shared Libraries**: Reusable gems for common functionality across applications
- **CLI Tools**: Interactive command-line utilities for productivity
- **Development Scripts**: Automated setup, testing, and deployment workflows
- **API Playground**: Interactive testing environment for utility APIs
- **Comprehensive Testing**: Full test coverage with RSpec and Rails test suite
- **Security Features**: Input validation, rate limiting, and security monitoring
- **Performance Monitoring**: Caching, performance metrics, and health checks
- **CI/CD Pipeline**: Automated testing, security audits, and deployment

## Repository Structure

```
ruby-rails/
├── apps/                    # Deployable applications
│   ├── dunamismax/         # Personal blog/portfolio (Rails app)
│   ├── apiplayground/      # API testing playground (Rails app)
│   ├── blog_generator/     # CLI tool for blog post generation
│   ├── file_organizer/     # CLI tool for file organization
│   └── code_stats/         # CLI tool for code statistics
├── gems/                   # Shared libraries
│   └── shared_utilities/   # Common utilities for all apps
├── scripts/                # Utility scripts
│   ├── maintenance/        # Maintenance scripts
│   ├── development/        # Development workflow scripts
│   └── deployment/         # Deployment scripts
├── Gemfile                 # Root-level shared dependencies
├── .gitignore             # Git ignore rules
└── README.md              # This file
```

## Quick Start

### Prerequisites

- Ruby 3.3.0 or higher
- Bundler 2.0+
- Node.js (for Rails apps with JavaScript)
- SQLite3 (for development databases)

### Setup

1. **Bootstrap the monorepo:**

   ```bash
   ruby scripts/development/bootstrap.rb
   ```

2. **Install dependencies:**

   ```bash
   bundle install
   ```

3. **Set up individual applications:**

   ```bash
   # For Rails apps
   cd apps/dunamismax && bundle install && bundle exec rails db:create db:migrate
   cd apps/apiplayground && bundle install && bundle exec rails db:create db:migrate

   # For CLI apps
   cd apps/blog_generator && bundle install
   cd apps/file_organizer && bundle install
   cd apps/code_stats && bundle install
   ```

## Applications

### Dunamismax (Personal Blog/Portfolio)

A dark-themed personal blog and portfolio website built with Rails.

- **Location:** `apps/dunamismax/`
- **Features:**
  - Dark mode theme
  - Responsive design
  - Blog post management
  - Portfolio showcase
  - Contact form
- **Usage:**

  ```bash
  cd apps/dunamismax
  bundle exec rails server
  # Visit http://localhost:3000
  ```

### API Playground

An interactive API testing environment with various utility endpoints.

- **Location:** `apps/apiplayground/`
- **Features:**
  - Text analysis API
  - Random number generation
  - Password generation
  - API key generation
  - String utilities
  - Date formatting
  - Interactive web interface
- **Usage:**

  ```bash
  cd apps/apiplayground
  bundle exec rails server -p 3001
  # Visit http://localhost:3001
  ```

## CLI Tools

**Blog Generator**: Create blog posts with metadata and statistics  
**File Organizer**: Organize files by type, date, or custom rules  
**Code Stats**: Analyze code statistics and language distribution

```bash
# Blog Generator
./apps/blog_generator/bin/blog_generator new "My Post" --tags ruby,rails

# File Organizer
./apps/file_organizer/bin/file_organizer by_type /path/to/directory

# Code Stats
./apps/code_stats/bin/code_stats analyze --format json
```

## Shared Libraries

### SharedUtilities

Common utilities used across all applications.

**Location:** `gems/shared_utilities/`

**Modules:**

- `StringHelpers` - String manipulation, slugification, email extraction, word frequency
- `DateHelpers` - Date formatting, time calculations, business day calculations
- `ApiHelpers` - Password generation, text analysis, API key generation
- `SecurityHelpers` - Input validation, sanitization, security utilities
- `CacheHelpers` - Caching system with LRU eviction and performance optimization

**Usage:**

```ruby
# In any app's Gemfile
gem 'shared_utilities', path: '../../gems/shared_utilities'

# In your code
require 'shared_utilities'

# String helpers
SharedUtilities::StringHelpers.slugify("Hello World")
SharedUtilities::StringHelpers.extract_emails(text)
SharedUtilities::StringHelpers.word_frequency(text)

# Date helpers
SharedUtilities::DateHelpers.time_ago_in_words(date)
SharedUtilities::DateHelpers.format_date(date, :long)
SharedUtilities::DateHelpers.business_days_between(start_date, end_date)

# API helpers
SharedUtilities::ApiHelpers.generate_password(12)
SharedUtilities::ApiHelpers.analyze_text(text)
SharedUtilities::ApiHelpers.hash_password(password)

# Security helpers
SharedUtilities::SecurityHelpers.sanitize_filename(filename)
SharedUtilities::SecurityHelpers.validate_url(url)

# Cache helpers
SharedUtilities::CacheHelpers.fetch(key) { expensive_operation }
```

## Development Scripts

```bash
# Bootstrap monorepo
ruby scripts/development/bootstrap.rb

# Run tests
ruby scripts/development/test_runner.rb
ruby scripts/development/test_runner.rb --apps dunamismax,apiplayground

# Maintenance
ruby scripts/maintenance/cleanup.rb

# Deployment
ruby scripts/deployment/deploy.rb --app dunamismax --dry-run
```

## Development Workflow

### Adding New Applications

```bash
# Create Rails app
mkdir apps/my_new_app && cd apps/my_new_app
rails new . --database=sqlite3

# Add shared utilities to Gemfile
echo "gem 'shared_utilities', path: '../../gems/shared_utilities'" >> Gemfile
```

### Adding New Shared Libraries

```bash
# Create new gem
mkdir gems/my_shared_lib && cd gems/my_shared_lib
bundle gem my_shared_lib
```

## Security

- **Input Validation**: All user inputs are validated and sanitized
- **Rate Limiting**: API endpoints have rate limiting to prevent abuse
- **Security Monitoring**: Comprehensive logging and monitoring of security events
- **Dependency Scanning**: Automated vulnerability scanning with Bundler Audit
- **Code Analysis**: Static security analysis with Brakeman
- **Secure Defaults**: CSRF protection, secure headers, and proper error handling

## Deployment

### Local Development

Each application can be run independently:

```bash
# Dunamismax
cd apps/dunamismax && bundle exec rails server

# API Playground
cd apps/apiplayground && bundle exec rails server -p 3001
```

### Production Deployment

Use the deployment script:

```bash
# Deploy all apps to production
ruby scripts/deployment/deploy.rb --environment production

# Deploy specific app
ruby scripts/deployment/deploy.rb --app dunamismax --environment production
```

## API Documentation

### Health and Monitoring

- `GET /api/health` - Health check with system status
- `GET /api/metrics` - Performance metrics and usage statistics

### String Utilities

- `POST /api/string/slugify` - Convert text to URL-friendly slug
- `POST /api/string/truncate` - Truncate text by word count
- `POST /api/string/highlight` - Syntax highlighting for code
- `POST /api/string/extract_emails` - Extract email addresses from text
- `POST /api/string/word_frequency` - Analyze word frequency in text
- `POST /api/string/sanitize_html` - Sanitize HTML content

### Password Management

- `GET /api/password/generate` - Generate secure passwords with options
- `GET /api/password/batch` - Generate multiple passwords
- `POST /api/password/validate` - Validate password strength
- `POST /api/password/hash` - Hash passwords securely
- `POST /api/password/verify` - Verify password against hash

### Text Analysis

- `POST /api/text/analyze` - Comprehensive text analysis
- `POST /api/text/reading_time` - Calculate reading time

### Random Generation

- `GET /api/random/number` - Generate random numbers
- `GET /api/random/numbers` - Generate multiple random numbers

### API Keys

- `GET /api/keys/generate` - Generate API keys
- `GET /api/keys/batch` - Generate multiple API keys

### Date Utilities

- `POST /api/date/format` - Format dates in various formats
- `POST /api/date/time_ago` - Calculate relative time
- `GET /api/date/current` - Get current date/time

### Development Setup

```bash
git clone https://github.com/dunamismax/ruby-rails.git
cd ruby-rails
ruby scripts/development/bootstrap.rb
```

### Testing & Quality

```bash
# Run all tests
ruby scripts/development/test_runner.rb

# Run security audit
bundle exec brakeman

# Run code quality checks
bundle exec rubocop

# Run specific test suites
cd gems/shared_utilities && bundle exec rspec
cd apps/apiplayground && bundle exec rails test
```

**Requirements**: Security validation, comprehensive test coverage, clear documentation, performance consideration, Ruby/Rails standards compliance.

---

## Troubleshooting

### Common Issues

**Setup Problems:**

```bash
# Clean rebuild
ruby scripts/maintenance/cleanup.rb
ruby scripts/development/bootstrap.rb

# Check Ruby version
ruby --version

# Verify dependencies
bundle check
```

**Application Issues:**

```bash
# Start fresh
cd apps/dunamismax && bundle exec rails db:drop db:create db:migrate
cd apps/apiplayground && bundle exec rails db:drop db:create db:migrate

# Check individual apps
cd apps/dunamismax && bundle exec rails server
cd apps/apiplayground && bundle exec rails server -p 3001
```

**Test Failures:**

```bash
# Run specific test suite
ruby scripts/development/test_runner.rb --apps dunamismax

# Check individual gems
cd gems/shared_utilities && bundle exec rspec

# Verbose testing
ruby scripts/development/test_runner.rb --verbose
```

---

## Support This Project

If you find this Ruby Rails Monorepo valuable for your development projects, consider supporting its continued development:

<p align="center">
  <a href="https://www.buymeacoffee.com/dunamismax" target="_blank">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" />
  </a>
</p>

---

## Connect

<p align="center">
  <a href="https://twitter.com/dunamismax" target="_blank"><img src="https://img.shields.io/badge/Twitter-%231DA1F2.svg?&style=for-the-badge&logo=twitter&logoColor=white" alt="Twitter"></a>
  <a href="https://bsky.app/profile/dunamismax.bsky.social" target="_blank"><img src="https://img.shields.io/badge/Bluesky-blue?style=for-the-badge&logo=bluesky&logoColor=white" alt="Bluesky"></a>
  <a href="https://reddit.com/user/dunamismax" target="_blank"><img src="https://img.shields.io/badge/Reddit-%23FF4500.svg?&style=for-the-badge&logo=reddit&logoColor=white" alt="Reddit"></a>
  <a href="https://discord.com/users/dunamismax" target="_blank"><img src="https://img.shields.io/badge/Discord-dunamismax-7289DA.svg?style=for-the-badge&logo=discord&logoColor=white" alt="Discord"></a>
  <a href="https://signal.me/#p/+dunamismax.66" target="_blank"><img src="https://img.shields.io/badge/Signal-dunamismax.66-3A76F0.svg?style=for-the-badge&logo=signal&logoColor=white" alt="Signal"></a>
</p>

---

## License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  <strong>Built with Ruby on Rails for Production</strong><br>
  <sub>Comprehensive monorepo platform for scalable Ruby development</sub>
</p>
