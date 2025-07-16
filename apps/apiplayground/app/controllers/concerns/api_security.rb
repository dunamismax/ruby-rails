module ApiSecurity
  extend ActiveSupport::Concern

  included do
    before_action :validate_request_size
    before_action :check_rate_limit
    before_action :validate_content_type
    rescue_from StandardError, with: :handle_api_error
    rescue_from SharedUtilities::ValidationError, with: :handle_validation_error
    rescue_from SharedUtilities::SecurityError, with: :handle_security_error
    rescue_from SharedUtilities::RateLimitError, with: :handle_rate_limit_error
    include ApiMonitoring
  end

  private

  def validate_request_size
    max_size = 1.megabyte
    if request.content_length && request.content_length > max_size
      render json: { 
        error: 'Request entity too large',
        message: 'Request size exceeds maximum allowed size'
      }, status: :payload_too_large
      return false
    end
  end

  def check_rate_limit
    identifier = request.remote_ip
    action = "#{controller_name}##{action_name}"
    
    if SharedUtilities::SecurityHelpers.rate_limit_exceeded?(identifier, 100, 3600)
      raise SharedUtilities::RateLimitError, 'Rate limit exceeded'
    end
  end

  def validate_content_type
    return unless request.post? || request.put? || request.patch?
    
    unless request.content_type&.include?('application/json') || 
           request.content_type&.include?('application/x-www-form-urlencoded') ||
           request.content_type&.include?('multipart/form-data')
      render json: { 
        error: 'Unsupported content type',
        message: 'Content-Type must be application/json or form data'
      }, status: :unsupported_media_type
      return false
    end
  end

  def validate_required_params(params_list)
    missing_params = params_list.select { |param| params[param].blank? }
    
    unless missing_params.empty?
      raise SharedUtilities::ValidationError, 
            "Missing required parameters: #{missing_params.join(', ')}"
    end
  end

  def sanitize_input(input)
    return nil if input.nil?
    
    sanitized = SharedUtilities::ApiHelpers.sanitize_input(input)
    
    if SharedUtilities::SecurityHelpers.contains_malicious_patterns?(sanitized)
      raise SharedUtilities::SecurityError, 'Potentially malicious input detected'
    end
    
    sanitized
  end

  def validate_input_length(input, max_length = 1000)
    unless SharedUtilities::SecurityHelpers.validate_input_length(input, max_length)
      raise SharedUtilities::ValidationError, 
            "Input exceeds maximum length of #{max_length} characters"
    end
  end

  def render_success(data = {}, message = 'Success')
    render json: {
      success: true,
      message: message,
      data: data,
      timestamp: Time.current.iso8601
    }
  end

  def render_error(message, status = :bad_request, details = nil)
    response = {
      success: false,
      error: message,
      timestamp: Time.current.iso8601
    }
    
    response[:details] = details if details
    render json: response, status: status
  end

  def handle_api_error(exception)
    Rails.logger.error "API Error: #{exception.message}"
    Rails.logger.error exception.backtrace.join("\n")
    
    render_error(
      'An internal server error occurred',
      :internal_server_error,
      Rails.env.development? ? exception.message : nil
    )
  end

  def handle_validation_error(exception)
    render_error(exception.message, :bad_request)
  end

  def handle_security_error(exception)
    Rails.logger.warn "Security Error: #{exception.message} from #{request.remote_ip}"
    render_error('Security validation failed', :forbidden)
  end

  def handle_rate_limit_error(exception)
    render_error('Rate limit exceeded. Please try again later.', :too_many_requests)
  end
end