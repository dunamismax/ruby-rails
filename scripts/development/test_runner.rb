#!/usr/bin/env ruby

require 'optparse'

class TestRunner
  def initialize
    @options = {
      apps: [],
      gems: [],
      verbose: false,
      parallel: false
    }
  end

  def run
    parse_options
    
    puts "Running tests for Ruby Rails monorepo..."
    
    if @options[:apps].empty? && @options[:gems].empty?
      run_all_tests
    else
      run_specific_tests
    end
    
    puts "Test run complete!"
  end

  private

  def parse_options
    OptionParser.new do |opts|
      opts.banner = "Usage: ruby test_runner.rb [options]"
      
      opts.on("-a", "--apps APP1,APP2", Array, "Run tests for specific apps") do |apps|
        @options[:apps] = apps
      end
      
      opts.on("-g", "--gems GEM1,GEM2", Array, "Run tests for specific gems") do |gems|
        @options[:gems] = gems
      end
      
      opts.on("-v", "--verbose", "Run with verbose output") do
        @options[:verbose] = true
      end
      
      opts.on("-p", "--parallel", "Run tests in parallel") do
        @options[:parallel] = true
      end
      
      opts.on("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end.parse!
  end

  def run_all_tests
    puts "\n🧪 Running all tests..."
    
    # Run tests for all apps
    run_app_tests(get_all_apps)
    
    # Run tests for all gems
    run_gem_tests(get_all_gems)
  end

  def run_specific_tests
    puts "\n🎯 Running specific tests..."
    
    run_app_tests(@options[:apps]) unless @options[:apps].empty?
    run_gem_tests(@options[:gems]) unless @options[:gems].empty?
  end

  def run_app_tests(apps)
    apps.each do |app|
      app_path = "apps/#{app}"
      
      unless File.directory?(app_path)
        puts "  ❌ App not found: #{app}"
        next
      end
      
      puts "  📱 Running tests for #{app}..."
      
      Dir.chdir(app_path) do
        if File.exist?("test")
          run_command("bundle exec rails test")
        elsif File.exist?("spec")
          run_command("bundle exec rspec")
        else
          puts "    ⚠️  No test directory found"
        end
      end
    end
  end

  def run_gem_tests(gems)
    gems.each do |gem|
      gem_path = "gems/#{gem}"
      
      unless File.directory?(gem_path)
        puts "  ❌ Gem not found: #{gem}"
        next
      end
      
      puts "  💎 Running tests for #{gem}..."
      
      Dir.chdir(gem_path) do
        if File.exist?("spec")
          run_command("bundle exec rspec")
        elsif File.exist?("test")
          run_command("bundle exec rake test")
        else
          puts "    ⚠️  No test directory found"
        end
      end
    end
  end

  def run_command(command)
    if @options[:verbose]
      system(command)
    else
      system("#{command} > /dev/null 2>&1")
    end
    
    if $?.success?
      puts "    ✅ Tests passed"
    else
      puts "    ❌ Tests failed"
    end
  end

  def get_all_apps
    Dir.glob("apps/*").map { |path| File.basename(path) }
  end

  def get_all_gems
    Dir.glob("gems/*").map { |path| File.basename(path) }
  end
end

TestRunner.new.run if __FILE__ == $0