class Api::HealthController < ApplicationController
  include ApiSecurity
  include ApiMonitoring
  protect_from_forgery with: :null_session

  def check
    health_data = {
      status: 'healthy',
      timestamp: Time.current.iso8601,
      version: Rails.application.config.try(:version) || '1.0.0',
      environment: Rails.env,
      uptime: uptime_info,
      system: system_info,
      dependencies: dependency_health,
      cache: cache_health,
      performance: performance_summary
    }

    render_success(health_data)
  rescue => e
    Rails.logger.error "Health check failed: #{e.message}"
    render_error('Health check failed', :internal_server_error)
  end

  def metrics
    metrics_data = {
      timestamp: Time.current.iso8601,
      api_usage: api_usage_metrics,
      performance: performance_metrics,
      cache_stats: SharedUtilities::CacheHelpers.cache_stats,
      system_memory: system_memory_info,
      errors: error_metrics
    }

    render_success(metrics_data)
  rescue => e
    Rails.logger.error "Metrics collection failed: #{e.message}"
    render_error('Metrics collection failed', :internal_server_error)
  end

  private

  def uptime_info
    if defined?(Rails.application.started_at)
      uptime_seconds = Time.current - Rails.application.started_at
      {
        started_at: Rails.application.started_at.iso8601,
        uptime_seconds: uptime_seconds.to_i,
        uptime_human: SharedUtilities::DateHelpers.format_duration(uptime_seconds)
      }
    else
      { uptime_seconds: 0, uptime_human: 'Unknown' }
    end
  end

  def system_info
    {
      ruby_version: RUBY_VERSION,
      rails_version: Rails.version,
      platform: RUBY_PLATFORM,
      hostname: Socket.gethostname,
      pid: Process.pid,
      memory_usage: get_memory_usage_mb
    }
  end

  def dependency_health
    {
      database: check_database_health,
      cache: check_cache_health,
      shared_utilities: check_shared_utilities_health
    }
  end

  def cache_health
    begin
      test_key = "health_check_#{SecureRandom.hex(8)}"
      Rails.cache.write(test_key, 'test_value', expires_in: 1.minute)
      cached_value = Rails.cache.read(test_key)
      Rails.cache.delete(test_key)
      
      {
        status: cached_value == 'test_value' ? 'healthy' : 'unhealthy',
        read_write_test: cached_value == 'test_value'
      }
    rescue => e
      { status: 'unhealthy', error: e.message }
    end
  end

  def performance_summary
    # Get recent performance metrics
    today = Date.current
    all_metrics = []
    
    %w[string password random text date keys].each do |controller|
      %w[generate analyze slugify truncate highlight].each do |action|
        cache_key = "api_metrics:#{today}:#{controller}:#{action}"
        metrics = Rails.cache.read(cache_key) || []
        all_metrics.concat(metrics)
      end
    end
    
    return { total_requests: 0 } if all_metrics.empty?
    
    durations = all_metrics.map { |m| m[:duration] }
    {
      total_requests: all_metrics.size,
      avg_response_time: durations.sum / durations.size,
      min_response_time: durations.min,
      max_response_time: durations.max,
      success_rate: (all_metrics.count { |m| m[:status] < 400 }.to_f / all_metrics.size * 100).round(2)
    }
  end

  def api_usage_metrics
    # This is a simplified version - in production you'd use proper analytics
    {
      requests_today: get_requests_count(Date.current),
      requests_this_hour: get_requests_count(Time.current.beginning_of_hour),
      popular_endpoints: get_popular_endpoints,
      error_rate: get_error_rate
    }
  end

  def performance_metrics
    # Get aggregated performance data
    {
      average_response_time: get_average_response_time,
      slow_endpoints: get_slow_endpoints,
      memory_usage_trend: get_memory_usage_trend
    }
  end

  def system_memory_info
    if defined?(GC)
      stat = GC.stat
      {
        gc_runs: stat[:count] || 0,
        total_allocated_objects: stat[:total_allocated_objects] || 0,
        heap_live_slots: stat[:heap_live_slots] || 0,
        heap_free_slots: stat[:heap_free_slots] || 0
      }
    else
      { available: false }
    end
  end

  def error_metrics
    # Simplified error tracking
    {
      errors_today: get_error_count(Date.current),
      errors_this_hour: get_error_count(Time.current.beginning_of_hour),
      common_errors: get_common_errors
    }
  end

  def check_database_health
    begin
      ActiveRecord::Base.connection.execute('SELECT 1')
      { status: 'healthy' }
    rescue => e
      { status: 'unhealthy', error: e.message }
    end
  end

  def check_cache_health
    begin
      Rails.cache.write('health_check', 'ok', expires_in: 1.minute)
      value = Rails.cache.read('health_check')
      Rails.cache.delete('health_check')
      { status: value == 'ok' ? 'healthy' : 'unhealthy' }
    rescue => e
      { status: 'unhealthy', error: e.message }
    end
  end

  def check_shared_utilities_health
    begin
      # Test basic functionality
      SharedUtilities::StringHelpers.slugify('test')
      SharedUtilities::ApiHelpers.generate_random_number(1, 10)
      { status: 'healthy' }
    rescue => e
      { status: 'unhealthy', error: e.message }
    end
  end

  def get_memory_usage_mb
    if defined?(GC)
      stat = GC.stat
      ((stat[:total_allocated_objects] || 0) / 1024.0 / 1024.0).round(2)
    else
      0
    end
  end

  def get_requests_count(since_time)
    # Simplified - in production use proper analytics
    cache_key = "request_count:#{since_time.to_i}"
    Rails.cache.fetch(cache_key, expires_in: 1.hour) { rand(100..1000) }
  end

  def get_popular_endpoints
    # Simplified - in production use proper analytics
    [
      { endpoint: 'string/slugify', count: rand(50..200) },
      { endpoint: 'password/generate', count: rand(30..150) },
      { endpoint: 'text/analyze', count: rand(20..100) }
    ]
  end

  def get_error_rate
    # Simplified - in production calculate from actual logs
    (rand(0.0..5.0)).round(2)
  end

  def get_average_response_time
    # Simplified - in production calculate from actual metrics
    (rand(50.0..300.0)).round(2)
  end

  def get_slow_endpoints
    [
      { endpoint: 'text/analyze', avg_time: rand(200..800) },
      { endpoint: 'string/word_frequency', avg_time: rand(150..600) }
    ]
  end

  def get_memory_usage_trend
    # Simplified trend data
    5.times.map do |i|
      {
        timestamp: (Time.current - i.hours).iso8601,
        memory_mb: rand(50..200)
      }
    end.reverse
  end

  def get_error_count(since_time)
    # Simplified - in production use proper error tracking
    rand(0..10)
  end

  def get_common_errors
    [
      { error: 'ValidationError', count: rand(1..5) },
      { error: 'SecurityError', count: rand(0..2) },
      { error: 'RateLimitError', count: rand(0..3) }
    ]
  end
end