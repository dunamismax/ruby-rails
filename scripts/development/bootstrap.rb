#!/usr/bin/env ruby

require 'fileutils'

class BootstrapScript
  def self.run
    puts "Bootstrapping Ruby Rails monorepo..."
    
    # Install root dependencies
    install_root_dependencies
    
    # Install dependencies for each app
    install_app_dependencies
    
    # Install dependencies for each gem
    install_gem_dependencies
    
    # Setup databases
    setup_databases
    
    # Run initial setup
    initial_setup
    
    puts "Bootstrap complete! 🚀"
  end

  private

  def self.install_root_dependencies
    puts "\n📦 Installing root dependencies..."
    system("bundle install") || puts("Warning: Failed to install root dependencies")
  end

  def self.install_app_dependencies
    puts "\n🔧 Installing app dependencies..."
    
    Dir.glob("apps/*").each do |app_dir|
      next unless File.directory?(app_dir)
      
      puts "  Installing dependencies for #{File.basename(app_dir)}..."
      Dir.chdir(app_dir) do
        if File.exist?("Gemfile")
          system("bundle install") || puts("    Warning: Failed to install dependencies")
        end
        
        if File.exist?("package.json")
          system("npm install") || puts("    Warning: Failed to install npm dependencies")
        end
      end
    end
  end

  def self.install_gem_dependencies
    puts "\n💎 Installing gem dependencies..."
    
    Dir.glob("gems/*").each do |gem_dir|
      next unless File.directory?(gem_dir)
      
      puts "  Installing dependencies for #{File.basename(gem_dir)}..."
      Dir.chdir(gem_dir) do
        if File.exist?("Gemfile")
          system("bundle install") || puts("    Warning: Failed to install dependencies")
        end
      end
    end
  end

  def self.setup_databases
    puts "\n🗄️  Setting up databases..."
    
    rails_apps = Dir.glob("apps/*").select do |app_dir|
      File.exist?(File.join(app_dir, "config", "database.yml"))
    end
    
    rails_apps.each do |app_dir|
      app_name = File.basename(app_dir)
      puts "  Setting up database for #{app_name}..."
      
      Dir.chdir(app_dir) do
        system("bundle exec rails db:create") || puts("    Warning: Failed to create database")
        system("bundle exec rails db:migrate") || puts("    Warning: Failed to run migrations")
        system("bundle exec rails db:seed") || puts("    Warning: Failed to seed database")
      end
    end
  end

  def self.initial_setup
    puts "\n⚙️  Running initial setup..."
    
    # Create necessary directories
    FileUtils.mkdir_p("tmp")
    FileUtils.mkdir_p("log")
    
    # Set up git hooks if needed
    setup_git_hooks
    
    puts "  Initial setup complete!"
  end

  def self.setup_git_hooks
    return unless File.directory?(".git")
    
    puts "  Setting up git hooks..."
    
    pre_commit_hook = <<~HOOK
      #!/bin/sh
      # Pre-commit hook for Ruby Rails monorepo
      
      echo "Running pre-commit checks..."
      
      # Run RuboCop on staged Ruby files
      staged_ruby_files=$(git diff --cached --name-only --diff-filter=ACM | grep '\\.rb$')
      if [ -n "$staged_ruby_files" ]; then
        echo "Running RuboCop on staged files..."
        bundle exec rubocop $staged_ruby_files
        if [ $? -ne 0 ]; then
          echo "RuboCop failed. Please fix the issues before committing."
          exit 1
        fi
      fi
      
      echo "Pre-commit checks passed!"
    HOOK
    
    hook_file = ".git/hooks/pre-commit"
    File.write(hook_file, pre_commit_hook)
    FileUtils.chmod(0755, hook_file)
  end
end

BootstrapScript.run if __FILE__ == $0