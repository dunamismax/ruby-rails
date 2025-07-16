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
- **Dark Mode UI**: Modern, responsive interfaces with elegant dark themes
- **API Playground**: Interactive testing environment for utility APIs
- **Comprehensive Documentation**: Extensive guides and code examples
- **Professional Workflow**: Git hooks, linting, and automated testing
- **Cross-Platform**: Support for macOS, Linux, and other Unix-like systems

## 🗂️ Repository Structure

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

## 🚀 Quick Start

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

## 📱 Applications

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

## 🛠️ CLI Tools

### Blog Generator

Generate blog post templates with metadata.

```bash
# Generate a new post
./apps/blog_generator/bin/blog_generator new "My New Post" --tags ruby,rails --category tech

# Show statistics for a post
./apps/blog_generator/bin/blog_generator stats my-post.md
```

### File Organizer

Organize files by type, date, or custom rules.

```bash
# Organize files by extension
./apps/file_organizer/bin/file_organizer by_type /path/to/directory

# Organize files by date
./apps/file_organizer/bin/file_organizer by_date /path/to/directory

# Show directory statistics
./apps/file_organizer/bin/file_organizer stats /path/to/directory
```

### Code Stats

Analyze code statistics across projects.

```bash
# Analyze current directory
./apps/code_stats/bin/code_stats analyze

# Show languages in project
./apps/code_stats/bin/code_stats languages

# Output as JSON
./apps/code_stats/bin/code_stats analyze --format json
```

## 💎 Shared Libraries

### SharedUtilities

Common utilities used across all applications.

**Location:** `gems/shared_utilities/`

**Modules:**

- `StringHelpers` - String manipulation utilities
- `DateHelpers` - Date formatting and calculations
- `ApiHelpers` - API-related utilities

**Usage:**

```ruby
# In any app's Gemfile
gem 'shared_utilities', path: '../../gems/shared_utilities'

# In your code
require 'shared_utilities'

# String helpers
SharedUtilities::StringHelpers.slugify("Hello World")
SharedUtilities::StringHelpers.reading_time(text)

# Date helpers
SharedUtilities::DateHelpers.time_ago_in_words(date)
SharedUtilities::DateHelpers.format_date(date, :long)

# API helpers
SharedUtilities::ApiHelpers.generate_password(12)
SharedUtilities::ApiHelpers.analyze_text(text)
```

## 🔧 Development Scripts

### Bootstrap Script

Initialize the entire monorepo:

```bash
ruby scripts/development/bootstrap.rb
```

### Test Runner

Run tests across all applications:

```bash
# Run all tests
ruby scripts/development/test_runner.rb

# Run specific apps
ruby scripts/development/test_runner.rb --apps dunamismax,apiplayground

# Run specific gems
ruby scripts/development/test_runner.rb --gems shared_utilities
```

### Maintenance Scripts

Clean up temporary files and logs:

```bash
ruby scripts/maintenance/cleanup.rb
```

### Deployment Scripts

Deploy applications:

```bash
# Deploy all apps
ruby scripts/deployment/deploy.rb

# Deploy specific app
ruby scripts/deployment/deploy.rb --app dunamismax

# Dry run
ruby scripts/deployment/deploy.rb --dry-run
```

## 🏗️ Development Workflow

### Adding a New Application

1. Create the application directory:

   ```bash
   mkdir apps/my_new_app
   cd apps/my_new_app
   ```

2. Initialize the application (Rails or Ruby):

   ```bash
   # For Rails app
   rails new . --database=sqlite3

   # For Ruby app/gem
   bundle gem my_new_app
   ```

3. Add shared utilities dependency:

   ```ruby
   # In Gemfile
   gem 'shared_utilities', path: '../../gems/shared_utilities'
   ```

4. Update the root README.md with documentation

### Adding a New Shared Library

1. Create the gem directory:

   ```bash
   mkdir gems/my_shared_lib
   cd gems/my_shared_lib
   ```

2. Create the gemspec and basic structure:

   ```bash
   bundle gem my_shared_lib
   ```

3. Add the gem to applications that need it:

   ```ruby
   # In app's Gemfile
   gem 'my_shared_lib', path: '../../gems/my_shared_lib'
   ```

### Running Tests

```bash
# Run all tests
ruby scripts/development/test_runner.rb

# Run with verbose output
ruby scripts/development/test_runner.rb --verbose

# Run in parallel
ruby scripts/development/test_runner.rb --parallel
```

## 🔐 Security

- All gems and applications follow security best practices
- Regular security audits with Brakeman
- Dependency scanning with Bundler Audit
- No secrets or keys committed to the repository

## 🚢 Deployment

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

## 📋 API Documentation

### API Playground Endpoints

#### Text Analysis

- `POST /api/text/analyze` - Analyze text statistics
- `POST /api/text/reading_time` - Calculate reading time

#### Random Generation

- `GET /api/random/number` - Generate random number
- `GET /api/random/numbers` - Generate multiple random numbers

#### Password Generation

- `GET /api/password/generate` - Generate secure password
- `GET /api/password/batch` - Generate multiple passwords

#### API Keys

- `GET /api/keys/generate` - Generate API key
- `GET /api/keys/batch` - Generate multiple API keys

#### String Utilities

- `POST /api/string/slugify` - Convert text to slug
- `POST /api/string/truncate` - Truncate text by words
- `POST /api/string/highlight` - Highlight code syntax

#### Date Utilities

- `POST /api/date/format` - Format date strings
- `POST /api/date/time_ago` - Calculate relative time
- `GET /api/date/current` - Get current date/time

## 🤝 Contributing

Contributions welcome! This project aims to be a comprehensive Ruby on Rails monorepo reference.

### Development Guidelines

```bash
# Setup development environment
git clone https://github.com/dunamismax/ruby-rails.git
cd ruby-rails
ruby scripts/development/bootstrap.rb

# Before submitting PR
ruby scripts/development/test_runner.rb
ruby scripts/maintenance/cleanup.rb
```

### Adding New Applications

1. Choose appropriate application type (Rails app, CLI tool, or gem)
2. Create well-structured, documented code
3. Add comprehensive tests and documentation
4. Follow Ruby and Rails best practices
5. Update monorepo documentation

### Code Quality Requirements

- **Production Quality**: Security-hardened, maintainable code
- **Documentation**: Comprehensive README and inline comments
- **Testing**: Unit tests and integration tests
- **Standards**: Follow Ruby Style Guide and Rails conventions

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
