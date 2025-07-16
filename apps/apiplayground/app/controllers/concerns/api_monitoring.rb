module ApiMonitoring
  extend ActiveSupport::Concern

  included do
    around_action :track_api_performance
    after_action :log_api_usage
  end

  private

  def track_api_performance
    start_time = Time.current
    start_memory = get_memory_usage
    
    yield
    
    end_time = Time.current
    end_memory = get_memory_usage
    
    duration = ((end_time - start_time) * 1000).round(2) # Convert to milliseconds
    memory_used = end_memory - start_memory
    
    # Store performance metrics
    store_performance_metrics(duration, memory_used)
    
    # Log performance if it exceeds thresholds
    log_slow_request(duration) if duration > 1000 # Log if > 1 second
    log_memory_usage(memory_used) if memory_used > 10 # Log if > 10 MB
    
    # Add performance headers
    response.headers['X-Response-Time'] = "#{duration}ms"
    response.headers['X-Memory-Usage'] = "#{memory_used}MB"
    
  rescue => e
    Rails.logger.error "Performance tracking failed: #{e.message}"
  end

  def log_api_usage
    log_data = {
      timestamp: Time.current.iso8601,
      method: request.method,
      path: request.path,
      controller: controller_name,
      action: action_name,
      params: filtered_params,
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      response_status: response.status,
      response_size: response.body.bytesize
    }
    
    Rails.logger.info "API_USAGE: #{log_data.to_json}"
  end

  def store_performance_metrics(duration, memory_used)
    # In a real application, you might store these in Redis, a database, or send to a monitoring service
    metrics = {
      endpoint: "#{controller_name}##{action_name}",
      duration: duration,
      memory_used: memory_used,
      timestamp: Time.current.to_i,
      status: response.status
    }
    
    # Store in cache for basic metrics aggregation
    cache_key = "api_metrics:#{Date.current}:#{controller_name}:#{action_name}"
    cached_metrics = Rails.cache.fetch(cache_key, expires_in: 1.day) { [] }
    cached_metrics << metrics
    Rails.cache.write(cache_key, cached_metrics, expires_in: 1.day)
  end

  def log_slow_request(duration)
    Rails.logger.warn "SLOW_REQUEST: #{controller_name}##{action_name} took #{duration}ms"
  end

  def log_memory_usage(memory_used)
    Rails.logger.warn "HIGH_MEMORY_USAGE: #{controller_name}##{action_name} used #{memory_used}MB"
  end

  def get_memory_usage
    # Simple memory tracking - in production you might use a more sophisticated approach
    if defined?(GC)
      stat = GC.stat
      (stat[:total_allocated_objects] || 0) / 1024.0 / 1024.0 # Convert to MB approximation
    else
      0
    end
  end

  def filtered_params
    # Filter out sensitive parameters
    filtered = params.except(:password, :password_confirmation, :hashed_password, :secret_key)
    filtered.to_unsafe_h if filtered.respond_to?(:to_unsafe_h)
  end
end