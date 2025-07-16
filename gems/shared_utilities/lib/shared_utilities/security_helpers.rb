require 'securerandom'
require 'digest'

module SharedUtilities
  module SecurityHelpers
    CSRF_TOKEN_LENGTH = 32
    SESSION_TOKEN_LENGTH = 64
    
    def self.generate_csrf_token
      SecureRandom.hex(CSRF_TOKEN_LENGTH)
    end
    
    def self.generate_session_token
      SecureRandom.hex(SESSION_TOKEN_LENGTH)
    end
    
    def self.secure_compare(a, b)
      return false if a.nil? || b.nil?
      return false if a.length != b.length
      
      result = 0
      a.bytes.zip(b.bytes) { |x, y| result |= x ^ y }
      result == 0
    end
    
    def self.sanitize_filename(filename)
      return '' if filename.nil? || filename.strip.empty?
      
      # Remove path traversal attempts
      filename = File.basename(filename.to_s)
      
      # Remove dangerous characters
      filename = filename.gsub(/[^a-zA-Z0-9\.\-_]/, '_')
      
      # Prevent hidden files
      filename = filename.gsub(/^\./, '_')
      
      # Limit length
      filename = filename[0, 255] if filename.length > 255
      
      filename.empty? ? 'unnamed_file' : filename
    end
    
    def self.validate_url(url)
      return false if url.nil? || url.strip.empty?
      
      begin
        uri = URI.parse(url)
        %w[http https].include?(uri.scheme) && !uri.host.nil?
      rescue URI::InvalidURIError
        false
      end
    end
    
    def self.mask_sensitive_data(data, mask_char = '*')
      return '' if data.nil? || data.strip.empty?
      
      data_str = data.to_s
      return data_str if data_str.length <= 4
      
      visible_length = [data_str.length / 4, 2].max
      masked_length = data_str.length - (visible_length * 2)
      
      data_str[0, visible_length] + 
      (mask_char * masked_length) + 
      data_str[-visible_length, visible_length]
    end
    
    def self.validate_input_length(input, max_length = 1000)
      return false if input.nil?
      input.to_s.length <= max_length
    end
    
    def self.contains_malicious_patterns?(input)
      return false if input.nil? || input.strip.empty?
      
      malicious_patterns = [
        /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/mi,
        /javascript:/i,
        /vbscript:/i,
        /on\w+\s*=/i,
        /data:text\/html/i,
        /\bexec\b/i,
        /\beval\b/i,
        /\bsystem\b/i,
        /\.\.\//,
        /\|\s*\w+/
      ]
      
      malicious_patterns.any? { |pattern| input.match?(pattern) }
    end
    
    def self.generate_api_signature(payload, secret_key)
      return nil if payload.nil? || secret_key.nil?
      
      Digest::HMAC.hexdigest(payload.to_s, secret_key.to_s, Digest::SHA256)
    end
    
    def self.verify_api_signature(payload, signature, secret_key)
      return false if payload.nil? || signature.nil? || secret_key.nil?
      
      expected_signature = generate_api_signature(payload, secret_key)
      secure_compare(signature, expected_signature)
    end
    
    def self.rate_limit_exceeded?(identifier, limit = 100, window = 3600)
      # This is a simple in-memory rate limiter
      # In production, you'd use Redis or similar
      @rate_limits ||= {}
      current_time = Time.now.to_i
      
      # Clean old entries
      @rate_limits.select! { |_, data| current_time - data[:window_start] < window }
      
      # Initialize or update counter
      if @rate_limits[identifier]
        @rate_limits[identifier][:count] += 1
      else
        @rate_limits[identifier] = { count: 1, window_start: current_time }
      end
      
      @rate_limits[identifier][:count] > limit
    end
  end
end