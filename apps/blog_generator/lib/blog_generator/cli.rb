require "thor"
require "shared_utilities"

module BlogGenerator
  class CLI < Thor
    desc "new TITLE", "Generate a new blog post"
    option :author, type: :string, default: "Dunamismax"
    option :tags, type: :array, default: []
    option :category, type: :string, default: "General"
    option :draft, type: :boolean, default: true
    def new(title)
      slug = SharedUtilities::StringHelpers.slugify(title)
      filename = "#{Date.today.strftime('%Y-%m-%d')}-#{slug}.md"
      
      content = generate_post_content(title, options)
      
      File.write(filename, content)
      puts "Created blog post: #{filename}"
    end

    desc "stats FILE", "Show statistics for a blog post"
    def stats(file)
      unless File.exist?(file)
        puts "File not found: #{file}"
        return
      end
      
      content = File.read(file)
      stats = SharedUtilities::ApiHelpers.analyze_text(content)
      
      puts "Blog Post Statistics:"
      puts "  Characters: #{stats[:character_count]}"
      puts "  Words: #{stats[:word_count]}"
      puts "  Sentences: #{stats[:sentence_count]}"
      puts "  Paragraphs: #{stats[:paragraph_count]}"
      puts "  Reading time: #{stats[:reading_time]}"
    end

    private

    def generate_post_content(title, options)
      <<~MARKDOWN
        ---
        title: "#{title}"
        author: #{options[:author]}
        date: #{Date.today.strftime('%Y-%m-%d')}
        category: #{options[:category]}
        tags: #{options[:tags].join(', ')}
        draft: #{options[:draft]}
        ---

        # #{title}

        Write your blog post content here...

        ## Introduction

        ## Main Content

        ## Conclusion
      MARKDOWN
    end
  end
end