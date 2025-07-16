#!/usr/bin/env ruby

require 'fileutils'

class CleanupScript
  def self.run
    puts "Starting cleanup process..."
    
    # Clean up temporary files
    cleanup_temp_files
    
    # Clean up log files
    cleanup_log_files
    
    # Clean up cache files
    cleanup_cache_files
    
    # Clean up old backup files
    cleanup_backup_files
    
    puts "Cleanup complete!"
  end

  private

  def self.cleanup_temp_files
    puts "Cleaning up temporary files..."
    
    temp_patterns = [
      "tmp/**/*",
      "**/*.tmp",
      "**/*.temp",
      "**/node_modules/.cache/**/*",
      "**/.sass-cache/**/*"
    ]
    
    temp_patterns.each do |pattern|
      Dir.glob(pattern).each do |file|
        next if File.directory?(file)
        
        FileUtils.rm_f(file)
        puts "  Removed: #{file}"
      end
    end
  end

  def self.cleanup_log_files
    puts "Cleaning up old log files..."
    
    log_patterns = [
      "apps/*/log/*.log",
      "log/*.log"
    ]
    
    log_patterns.each do |pattern|
      Dir.glob(pattern).each do |file|
        if File.size(file) > 10 * 1024 * 1024 # 10MB
          File.truncate(file, 0)
          puts "  Truncated large log file: #{file}"
        end
      end
    end
  end

  def self.cleanup_cache_files
    puts "Cleaning up cache files..."
    
    cache_patterns = [
      "apps/*/tmp/cache/**/*",
      "**/.bundle/cache/**/*",
      "**/coverage/**/*"
    ]
    
    cache_patterns.each do |pattern|
      Dir.glob(pattern).each do |file|
        next if File.directory?(file)
        
        FileUtils.rm_f(file)
        puts "  Removed cache file: #{file}"
      end
    end
  end

  def self.cleanup_backup_files
    puts "Cleaning up old backup files..."
    
    backup_patterns = [
      "**/*.bak",
      "**/*.backup",
      "**/*~"
    ]
    
    backup_patterns.each do |pattern|
      Dir.glob(pattern).each do |file|
        FileUtils.rm_f(file)
        puts "  Removed backup file: #{file}"
      end
    end
  end
end

CleanupScript.run if __FILE__ == $0