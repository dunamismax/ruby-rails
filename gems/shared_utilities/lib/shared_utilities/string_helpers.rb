require 'cgi'

module SharedUtilities
  module StringHelpers
    MAX_SLUG_LENGTH = 100
    MAX_WORD_COUNT = 10000
    MAX_TEXT_LENGTH = 1_000_000
    VALID_LANGUAGES = %w[ruby javascript python java go rust php html css sql bash yaml json].freeze

    def self.slugify(text)
      return '' if text.nil? || text.strip.empty?
      
      text_str = text.to_s.strip
      return '' if text_str.length > MAX_TEXT_LENGTH
      
      slug = text_str.downcase
                    .gsub(/[^a-z0-9\s-]/, '')
                    .gsub(/\s+/, '-')
                    .gsub(/-+/, '-')
                    .gsub(/^-|-$/, '')
      
      slug.length > MAX_SLUG_LENGTH ? slug[0, MAX_SLUG_LENGTH].gsub(/-\w*$/, '') : slug
    end

    def self.truncate_words(text, word_count = 50)
      return '' if text.nil? || text.strip.empty?
      return text.to_s if word_count <= 0
      
      word_count = [word_count, MAX_WORD_COUNT].min
      words = text.to_s.split
      
      return text.to_s if words.length <= word_count
      
      words[0...word_count].join(' ') + '...'
    end

    def self.reading_time(text)
      return '1 min read' if text.nil? || text.strip.empty?
      
      words_per_minute = 200
      word_count = text.to_s.split.length
      minutes = [(word_count / words_per_minute.to_f).ceil, 1].max
      "#{minutes} min read"
    end

    def self.highlight_code(text, language = 'ruby')
      return '<pre class="highlight ruby"><code></code></pre>' if text.nil?
      
      safe_language = VALID_LANGUAGES.include?(language.to_s) ? language : 'ruby'
      escaped_text = CGI.escape_html(text.to_s)
      
      "<pre class=\"highlight #{safe_language}\"><code>#{escaped_text}</code></pre>"
    end
    
    def self.sanitize_html(text)
      return '' if text.nil?
      CGI.escape_html(text.to_s)
    end
    
    def self.extract_emails(text)
      return [] if text.nil? || text.strip.empty?
      
      email_regex = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b/
      text.scan(email_regex).uniq
    end
    
    def self.word_frequency(text)
      return {} if text.nil? || text.strip.empty?
      
      words = text.to_s.downcase.gsub(/[^a-z\s]/, '').split
      words.each_with_object(Hash.new(0)) { |word, freq| freq[word] += 1 }
    end
  end
end