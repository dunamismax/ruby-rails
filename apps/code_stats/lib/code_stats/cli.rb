require "thor"
require "find"

module CodeStats
  class CLI < Thor
    desc "analyze PATH", "Analyze code statistics for a project"
    option :format, type: :string, default: "table", enum: %w[table json]
    def analyze(path = ".")
      unless Dir.exist?(path)
        puts "Directory not found: #{path}"
        return
      end

      stats = analyze_directory(path)
      
      if options[:format] == "json"
        require "json"
        puts JSON.pretty_generate(stats)
      else
        display_table(stats)
      end
    end

    desc "languages PATH", "Show supported languages in a project"
    def languages(path = ".")
      unless Dir.exist?(path)
        puts "Directory not found: #{path}"
        return
      end

      files = []
      Find.find(path) do |file_path|
        next unless File.file?(file_path)
        next if file_path.include?("/.git/")
        next if file_path.include?("/node_modules/")
        next if file_path.include?("/vendor/")
        next if file_path.include?("/tmp/")
        
        files << file_path
      end

      languages = files.group_by { |file| detect_language(file) }
      languages.delete("unknown")
      
      puts "Languages found:"
      languages.each do |lang, file_list|
        puts "  #{lang}: #{file_list.length} files"
      end
    end

    private

    def analyze_directory(path)
      files = []
      Find.find(path) do |file_path|
        next unless File.file?(file_path)
        next if file_path.include?("/.git/")
        next if file_path.include?("/node_modules/")
        next if file_path.include?("/vendor/")
        next if file_path.include?("/tmp/")
        
        files << file_path
      end

      stats = {}
      total_lines = 0
      total_files = 0

      files.group_by { |file| detect_language(file) }.each do |language, file_list|
        next if language == "unknown"
        
        language_stats = analyze_language_files(file_list)
        stats[language] = language_stats
        total_lines += language_stats[:lines]
        total_files += language_stats[:files]
      end

      stats["total"] = { lines: total_lines, files: total_files }
      stats
    end

    def analyze_language_files(files)
      total_lines = 0
      blank_lines = 0
      comment_lines = 0
      
      files.each do |file|
        File.readlines(file).each do |line|
          total_lines += 1
          if line.strip.empty?
            blank_lines += 1
          elsif line.strip.start_with?("#", "//", "/*", "*", "<!--")
            comment_lines += 1
          end
        end
      rescue StandardError
        # Skip files that can't be read
      end

      {
        files: files.length,
        lines: total_lines,
        blank_lines: blank_lines,
        comment_lines: comment_lines,
        code_lines: total_lines - blank_lines - comment_lines
      }
    end

    def detect_language(file)
      case File.extname(file).downcase
      when ".rb"
        "Ruby"
      when ".js", ".jsx"
        "JavaScript"
      when ".ts", ".tsx"
        "TypeScript"
      when ".py"
        "Python"
      when ".java"
        "Java"
      when ".cpp", ".cc", ".cxx", ".c++"
        "C++"
      when ".c"
        "C"
      when ".cs"
        "C#"
      when ".go"
        "Go"
      when ".rs"
        "Rust"
      when ".php"
        "PHP"
      when ".swift"
        "Swift"
      when ".kt"
        "Kotlin"
      when ".html", ".htm"
        "HTML"
      when ".css"
        "CSS"
      when ".scss", ".sass"
        "Sass"
      when ".yml", ".yaml"
        "YAML"
      when ".json"
        "JSON"
      when ".xml"
        "XML"
      when ".md"
        "Markdown"
      else
        "unknown"
      end
    end

    def display_table(stats)
      puts "Code Statistics:"
      puts "=" * 60
      puts "%-15s %8s %8s %8s %8s" % ["Language", "Files", "Lines", "Blank", "Comments"]
      puts "-" * 60
      
      stats.each do |language, data|
        next if language == "total"
        
        puts "%-15s %8d %8d %8d %8d" % [
          language,
          data[:files],
          data[:lines],
          data[:blank_lines],
          data[:comment_lines]
        ]
      end
      
      if stats["total"]
        puts "-" * 60
        puts "%-15s %8d %8d" % ["Total", stats["total"][:files], stats["total"][:lines]]
      end
    end
  end
end