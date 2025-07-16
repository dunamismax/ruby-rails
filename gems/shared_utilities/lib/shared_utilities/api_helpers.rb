require 'securerandom'
require 'digest'

module SharedUtilities
  module ApiHelpers
    MIN_PASSWORD_LENGTH = 8
    MAX_PASSWORD_LENGTH = 128
    MIN_API_KEY_LENGTH = 16
    MAX_API_KEY_LENGTH = 64
    MAX_TEXT_ANALYSIS_LENGTH = 500_000
    
    def self.generate_api_key(length = 32)
      length = [length, MIN_API_KEY_LENGTH].max
      length = [length, MAX_API_KEY_LENGTH].min
      
      SecureRandom.hex(length)
    end

    def self.generate_password(length = 12, options = {})
      length = [length, MIN_PASSWORD_LENGTH].max
      length = [length, MAX_PASSWORD_LENGTH].min
      
      # Default options
      opts = {
        include_lowercase: true,
        include_uppercase: true,
        include_numbers: true,
        include_symbols: true,
        exclude_ambiguous: false
      }.merge(options)
      
      charset = []
      charset.concat(('a'..'z').to_a) if opts[:include_lowercase]
      charset.concat(('A'..'Z').to_a) if opts[:include_uppercase]
      charset.concat(('0'..'9').to_a) if opts[:include_numbers]
      charset.concat(%w[! @ # $ % ^ & * ( ) - _ + = [ ] { } | \ : ; " ' < > , . ? /]) if opts[:include_symbols]
      
      # Remove ambiguous characters if requested
      if opts[:exclude_ambiguous]
        charset.reject! { |char| %w[0 O o 1 l I].include?(char) }
      end
      
      return '' if charset.empty?
      
      Array.new(length) { charset.sample }.join
    end
    
    def self.generate_secure_token(length = 32)
      SecureRandom.urlsafe_base64(length)[0, length]
    end
    
    def self.hash_password(password, salt = nil)
      return nil if password.nil? || password.empty?
      
      salt ||= SecureRandom.hex(16)
      hashed = Digest::SHA256.hexdigest("#{password}#{salt}")
      
      "#{salt}$#{hashed}"
    end
    
    def self.verify_password(password, hashed_password)
      return false if password.nil? || hashed_password.nil?
      
      parts = hashed_password.split('$')
      return false if parts.length != 2
      
      salt, stored_hash = parts
      computed_hash = Digest::SHA256.hexdigest("#{password}#{salt}")
      
      stored_hash == computed_hash
    end

    def self.analyze_text(text)
      return {} if text.nil? || text.strip.empty?
      
      text_str = text.to_s
      return { error: 'Text too long for analysis' } if text_str.length > MAX_TEXT_ANALYSIS_LENGTH
      
      words = text_str.split
      sentences = text_str.split(/[.!?]+/).reject(&:empty?)
      paragraphs = text_str.split(/\n\s*\n/).reject(&:empty?)
      
      {
        character_count: text_str.length,
        character_count_no_spaces: text_str.gsub(/\s/, '').length,
        word_count: words.length,
        sentence_count: sentences.length,
        paragraph_count: paragraphs.length,
        avg_words_per_sentence: sentences.empty? ? 0 : (words.length.to_f / sentences.length).round(2),
        avg_sentence_length: sentences.empty? ? 0 : (text_str.gsub(/\s/, '').length.to_f / sentences.length).round(2),
        reading_time: StringHelpers.reading_time(text_str),
        complexity_score: calculate_complexity_score(words, sentences)
      }
    end

    def self.generate_random_number(min = 1, max = 100)
      min, max = max, min if min > max
      SecureRandom.random_number(max - min + 1) + min
    end
    
    def self.validate_email(email)
      return false if email.nil? || email.strip.empty?
      
      email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
      !!(email =~ email_regex)
    end
    
    def self.sanitize_input(input)
      return '' if input.nil?
      
      input.to_s.strip.gsub(/[<>"'&]/, {
        '<' => '&lt;',
        '>' => '&gt;',
        '"' => '&quot;',
        "'" => '&#39;',
        '&' => '&amp;'
      })
    end
    
    def self.rate_limit_key(identifier, action = 'default')
      "rate_limit:#{identifier}:#{action}"
    end
    
    private
    
    def self.calculate_complexity_score(words, sentences)
      return 0 if words.empty? || sentences.empty?
      
      avg_word_length = words.sum(&:length).to_f / words.length
      avg_sentence_length = words.length.to_f / sentences.length
      
      # Simple complexity score based on word and sentence length
      complexity = (avg_word_length * 0.4) + (avg_sentence_length * 0.6)
      complexity.round(2)
    end
  end
end