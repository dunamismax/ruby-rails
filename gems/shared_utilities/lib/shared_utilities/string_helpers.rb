module SharedUtilities
  module StringHelpers
    def self.slugify(text)
      text.to_s.downcase.gsub(/[^a-z0-9]+/, '-').gsub(/-+/, '-').gsub(/^-|-$/, '')
    end

    def self.truncate_words(text, word_count = 50)
      words = text.to_s.split
      return text if words.length <= word_count
      
      words[0...word_count].join(' ') + '...'
    end

    def self.reading_time(text)
      words_per_minute = 200
      word_count = text.to_s.split.length
      minutes = (word_count / words_per_minute.to_f).ceil
      "#{minutes} min read"
    end

    def self.highlight_code(text, language = 'ruby')
      "<pre class=\"highlight #{language}\"><code>#{text}</code></pre>"
    end
  end
end