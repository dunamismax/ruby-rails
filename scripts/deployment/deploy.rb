#!/usr/bin/env ruby

require 'optparse'
require 'yaml'

class DeployScript
  def initialize
    @options = {
      environment: 'production',
      app: nil,
      dry_run: false,
      verbose: false
    }
  end

  def run
    parse_options
    
    puts "Deploying Ruby Rails monorepo..."
    puts "Environment: #{@options[:environment]}"
    puts "App: #{@options[:app] || 'all apps'}"
    puts "Dry run: #{@options[:dry_run]}"
    puts
    
    if @options[:app]
      deploy_app(@options[:app])
    else
      deploy_all_apps
    end
    
    puts "Deployment complete!"
  end

  private

  def parse_options
    OptionParser.new do |opts|
      opts.banner = "Usage: ruby deploy.rb [options]"
      
      opts.on("-e", "--environment ENV", "Deployment environment (default: production)") do |env|
        @options[:environment] = env
      end
      
      opts.on("-a", "--app APP", "Deploy specific app") do |app|
        @options[:app] = app
      end
      
      opts.on("-d", "--dry-run", "Show what would be deployed without actually deploying") do
        @options[:dry_run] = true
      end
      
      opts.on("-v", "--verbose", "Run with verbose output") do
        @options[:verbose] = true
      end
      
      opts.on("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end.parse!
  end

  def deploy_all_apps
    deployable_apps = get_deployable_apps
    
    if deployable_apps.empty?
      puts "No deployable apps found."
      return
    end
    
    deployable_apps.each do |app|
      deploy_app(app)
    end
  end

  def deploy_app(app)
    app_path = "apps/#{app}"
    
    unless File.directory?(app_path)
      puts "❌ App not found: #{app}"
      return
    end
    
    puts "🚀 Deploying #{app}..."
    
    Dir.chdir(app_path) do
      # Check if it's a Rails app
      if File.exist?("config/application.rb")
        deploy_rails_app(app)
      else
        deploy_generic_app(app)
      end
    end
  end

  def deploy_rails_app(app)
    puts "  📱 Deploying Rails app: #{app}"
    
    steps = [
      "bundle install --deployment --without development test",
      "bundle exec rails assets:precompile",
      "bundle exec rails db:migrate",
      "bundle exec rails db:seed"
    ]
    
    steps.each do |step|
      puts "    Running: #{step}" if @options[:verbose]
      
      if @options[:dry_run]
        puts "    [DRY RUN] Would run: #{step}"
      else
        unless system(step)
          puts "    ❌ Failed to run: #{step}"
          return
        end
      end
    end
    
    # Restart application server
    restart_app(app)
    
    puts "  ✅ Successfully deployed #{app}"
  end

  def deploy_generic_app(app)
    puts "  🔧 Deploying generic app: #{app}"
    
    if File.exist?("Gemfile")
      run_command("bundle install --deployment --without development test")
    end
    
    if File.exist?("package.json")
      run_command("npm ci --production")
    end
    
    # Build if needed
    if File.exist?("Rakefile")
      run_command("bundle exec rake build")
    end
    
    puts "  ✅ Successfully deployed #{app}"
  end

  def restart_app(app)
    puts "    Restarting #{app}..."
    
    if @options[:dry_run]
      puts "    [DRY RUN] Would restart application"
    else
      # This would typically involve restarting your web server
      # For now, we'll just create a restart file
      FileUtils.touch("tmp/restart.txt")
    end
  end

  def run_command(command)
    puts "    Running: #{command}" if @options[:verbose]
    
    if @options[:dry_run]
      puts "    [DRY RUN] Would run: #{command}"
    else
      unless system(command)
        puts "    ❌ Failed to run: #{command}"
        return false
      end
    end
    
    true
  end

  def get_deployable_apps
    Dir.glob("apps/*").select do |app_path|
      File.directory?(app_path) && (
        File.exist?(File.join(app_path, "config", "application.rb")) ||
        File.exist?(File.join(app_path, "Gemfile"))
      )
    end.map { |path| File.basename(path) }
  end
end

DeployScript.new.run if __FILE__ == $0