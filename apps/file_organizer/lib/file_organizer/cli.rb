require "thor"
require "fileutils"

module FileOrganizer
  class CLI < Thor
    desc "by_type PATH", "Organize files by their extension"
    option :dry_run, type: :boolean, default: false
    def by_type(path = ".")
      unless Dir.exist?(path)
        puts "Directory not found: #{path}"
        return
      end

      files = Dir.glob(File.join(path, "*")).select { |f| File.file?(f) }
      
      files.group_by { |file| File.extname(file).downcase }.each do |ext, file_list|
        next if ext.empty?
        
        folder_name = ext[1..-1] # Remove the dot
        target_dir = File.join(path, folder_name)
        
        if options[:dry_run]
          puts "Would create directory: #{target_dir}"
          file_list.each { |file| puts "  Would move: #{File.basename(file)}" }
        else
          FileUtils.mkdir_p(target_dir)
          file_list.each do |file|
            target_file = File.join(target_dir, File.basename(file))
            FileUtils.mv(file, target_file)
            puts "Moved: #{File.basename(file)} -> #{folder_name}/"
          end
        end
      end
    end

    desc "by_date PATH", "Organize files by their creation date"
    option :dry_run, type: :boolean, default: false
    def by_date(path = ".")
      unless Dir.exist?(path)
        puts "Directory not found: #{path}"
        return
      end

      files = Dir.glob(File.join(path, "*")).select { |f| File.file?(f) }
      
      files.group_by { |file| File.ctime(file).strftime("%Y-%m") }.each do |date, file_list|
        target_dir = File.join(path, date)
        
        if options[:dry_run]
          puts "Would create directory: #{target_dir}"
          file_list.each { |file| puts "  Would move: #{File.basename(file)}" }
        else
          FileUtils.mkdir_p(target_dir)
          file_list.each do |file|
            target_file = File.join(target_dir, File.basename(file))
            FileUtils.mv(file, target_file)
            puts "Moved: #{File.basename(file)} -> #{date}/"
          end
        end
      end
    end

    desc "stats PATH", "Show statistics about files in directory"
    def stats(path = ".")
      unless Dir.exist?(path)
        puts "Directory not found: #{path}"
        return
      end

      files = Dir.glob(File.join(path, "*")).select { |f| File.file?(f) }
      
      puts "Directory Statistics for: #{path}"
      puts "  Total files: #{files.length}"
      puts "  Total size: #{format_size(files.sum { |f| File.size(f) })}"
      
      by_extension = files.group_by { |file| File.extname(file).downcase }
      puts "\nFiles by extension:"
      by_extension.each do |ext, file_list|
        ext_name = ext.empty? ? "no extension" : ext[1..-1]
        puts "  #{ext_name}: #{file_list.length} files"
      end
    end

    private

    def format_size(bytes)
      units = %w[B KB MB GB TB]
      size = bytes.to_f
      unit_index = 0
      
      while size >= 1024 && unit_index < units.length - 1
        size /= 1024
        unit_index += 1
      end
      
      "#{size.round(2)} #{units[unit_index]}"
    end
  end
end