module SharedUtilities
  module CacheHelpers
    DEFAULT_EXPIRATION = 3600 # 1 hour
    MAX_CACHE_SIZE = 1000
    
    class SimpleCache
      def initialize(max_size = MAX_CACHE_SIZE)
        @cache = {}
        @access_order = []
        @max_size = max_size
      end
      
      def get(key)
        return nil unless @cache.key?(key)
        
        entry = @cache[key]
        return nil if entry[:expires_at] && entry[:expires_at] < Time.now
        
        # Update access order for LRU
        @access_order.delete(key)
        @access_order << key
        
        entry[:value]
      end
      
      def set(key, value, expires_in = DEFAULT_EXPIRATION)
        # Remove expired entries
        cleanup_expired
        
        # Remove oldest entries if cache is full
        if @cache.size >= @max_size && !@cache.key?(key)
          oldest_key = @access_order.shift
          @cache.delete(oldest_key)
        end
        
        expires_at = expires_in ? Time.now + expires_in : nil
        
        @cache[key] = {
          value: value,
          expires_at: expires_at,
          created_at: Time.now
        }
        
        @access_order.delete(key)
        @access_order << key
        
        value
      end
      
      def delete(key)
        @access_order.delete(key)
        @cache.delete(key)
      end
      
      def clear
        @cache.clear
        @access_order.clear
      end
      
      def size
        @cache.size
      end
      
      def stats
        expired_count = @cache.count { |_, entry| entry[:expires_at] && entry[:expires_at] < Time.now }
        
        {
          total_entries: @cache.size,
          expired_entries: expired_count,
          active_entries: @cache.size - expired_count,
          max_size: @max_size,
          oldest_entry: @cache.empty? ? nil : @cache.values.min_by { |entry| entry[:created_at] }[:created_at]
        }
      end
      
      private
      
      def cleanup_expired
        current_time = Time.now
        expired_keys = @cache.select { |_, entry| entry[:expires_at] && entry[:expires_at] < current_time }.keys
        
        expired_keys.each do |key|
          @cache.delete(key)
          @access_order.delete(key)
        end
      end
    end
    
    @cache = SimpleCache.new
    
    def self.cache
      @cache
    end
    
    def self.fetch(key, expires_in: DEFAULT_EXPIRATION, &block)
      cached_value = @cache.get(key)
      return cached_value if cached_value
      
      return nil unless block_given?
      
      value = yield
      @cache.set(key, value, expires_in)
      value
    end
    
    def self.memoize(key, expires_in: DEFAULT_EXPIRATION, &block)
      fetch(key, expires_in: expires_in, &block)
    end
    
    def self.clear_cache
      @cache.clear
    end
    
    def self.cache_stats
      @cache.stats
    end
    
    def self.generate_cache_key(*args)
      "#{args.join(':')}_#{Digest::MD5.hexdigest(args.inspect)}"
    end
    
    def self.with_cache_fallback(key, fallback_value = nil, expires_in: DEFAULT_EXPIRATION, &block)
      begin
        fetch(key, expires_in: expires_in, &block)
      rescue => e
        Rails.logger.error "Cache operation failed: #{e.message}" if defined?(Rails)
        fallback_value
      end
    end
  end
end