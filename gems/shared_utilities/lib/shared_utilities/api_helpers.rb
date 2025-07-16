module SharedUtilities
  module ApiHelpers
    def self.generate_api_key(length = 32)
      SecureRandom.hex(length)
    end

    def self.generate_password(length = 12)
      charset = %w[0 1 2 3 4 5 6 7 8 9 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z ! @ # $ % ^ & *]
      Array.new(length) { charset.sample }.join
    end

    def self.analyze_text(text)
      return {} if text.nil? || text.strip.empty?
      
      words = text.split
      sentences = text.split(/[.!?]+/).reject(&:empty?)
      paragraphs = text.split(/\n\s*\n/).reject(&:empty?)
      
      {
        character_count: text.length,
        character_count_no_spaces: text.gsub(/\s/, '').length,
        word_count: words.length,
        sentence_count: sentences.length,
        paragraph_count: paragraphs.length,
        avg_words_per_sentence: sentences.empty? ? 0 : (words.length.to_f / sentences.length).round(2),
        reading_time: StringHelpers.reading_time(text)
      }
    end

    def self.generate_random_number(min = 1, max = 100)
      rand(min..max)
    end
  end
end