class Api::PasswordController < ApplicationController
  include ApiSecurity
  protect_from_forgery with: :null_session
  
  def generate
    length = params[:length]&.to_i || 12
    
    if length < 8 || length > 128
      raise SharedUtilities::ValidationError, "Length must be between 8 and 128"
    end
    
    options = {
      include_lowercase: params[:include_lowercase] != 'false',
      include_uppercase: params[:include_uppercase] != 'false',
      include_numbers: params[:include_numbers] != 'false',
      include_symbols: params[:include_symbols] != 'false',
      exclude_ambiguous: params[:exclude_ambiguous] == 'true'
    }
    
    password = SharedUtilities::ApiHelpers.generate_password(length, options)
    strength_info = calculate_strength(password)
    
    render_success({
      password: password,
      length: length,
      strength: strength_info[:level],
      strength_score: strength_info[:score],
      strength_details: strength_info[:details],
      options: options
    })
  end
  
  def batch
    count = params[:count]&.to_i || 5
    length = params[:length]&.to_i || 12
    
    if count > 20
      raise SharedUtilities::ValidationError, "Count cannot exceed 20"
    end
    
    if length < 8 || length > 128
      raise SharedUtilities::ValidationError, "Length must be between 8 and 128"
    end
    
    options = {
      include_lowercase: params[:include_lowercase] != 'false',
      include_uppercase: params[:include_uppercase] != 'false',
      include_numbers: params[:include_numbers] != 'false',
      include_symbols: params[:include_symbols] != 'false',
      exclude_ambiguous: params[:exclude_ambiguous] == 'true'
    }
    
    passwords = count.times.map do
      password = SharedUtilities::ApiHelpers.generate_password(length, options)
      strength_info = calculate_strength(password)
      {
        password: password,
        strength: strength_info[:level],
        strength_score: strength_info[:score]
      }
    end
    
    render_success({
      passwords: passwords,
      count: count,
      length: length,
      options: options
    })
  end
  
  def validate
    validate_required_params([:password])
    password = params[:password]
    validate_input_length(password, 128)
    
    strength_info = calculate_strength(password)
    common_password = is_common_password?(password)
    
    render_success({
      password_length: password.length,
      strength: strength_info[:level],
      strength_score: strength_info[:score],
      strength_details: strength_info[:details],
      is_common_password: common_password,
      recommendations: generate_recommendations(password, strength_info)
    })
  end
  
  def hash_password
    validate_required_params([:password])
    password = params[:password]
    validate_input_length(password, 128)
    
    hashed = SharedUtilities::ApiHelpers.hash_password(password)
    
    render_success({
      hashed_password: hashed,
      algorithm: 'SHA256 with salt',
      note: 'Store this hash securely. The original password cannot be recovered.'
    })
  end
  
  def verify_password
    validate_required_params([:password, :hashed_password])
    password = params[:password]
    hashed_password = params[:hashed_password]
    
    validate_input_length(password, 128)
    validate_input_length(hashed_password, 200)
    
    is_valid = SharedUtilities::ApiHelpers.verify_password(password, hashed_password)
    
    render_success({
      is_valid: is_valid,
      message: is_valid ? 'Password is correct' : 'Password is incorrect'
    })
  end
  
  private
  
  def calculate_strength(password)
    score = 0
    details = []
    
    if password.length >= 8
      score += 1
      details << 'Good length (8+ characters)'
    else
      details << 'Password too short (less than 8 characters)'
    end
    
    if password.length >= 12
      score += 1
      details << 'Excellent length (12+ characters)'
    end
    
    if password.match?(/[a-z]/)
      score += 1
      details << 'Contains lowercase letters'
    else
      details << 'Missing lowercase letters'
    end
    
    if password.match?(/[A-Z]/)
      score += 1
      details << 'Contains uppercase letters'
    else
      details << 'Missing uppercase letters'
    end
    
    if password.match?(/[0-9]/)
      score += 1
      details << 'Contains numbers'
    else
      details << 'Missing numbers'
    end
    
    if password.match?(/[^a-zA-Z0-9]/)
      score += 1
      details << 'Contains special characters'
    else
      details << 'Missing special characters'
    end
    
    # Check for patterns that reduce strength
    if password.match?(/123|abc|qwe|asd/i)
      score -= 1
      details << 'Contains common patterns (reduces strength)'
    end
    
    level = case score
    when 0..2
      'Weak'
    when 3..4
      'Medium'
    when 5..6
      'Strong'
    else
      'Very Strong'
    end
    
    {
      level: level,
      score: score,
      details: details
    }
  end
  
  def is_common_password?(password)
    common_passwords = %w[
      password 123456 password123 admin qwerty abc123 
      letmein monkey 1234567890 dragon sunshine
    ]
    
    common_passwords.include?(password.downcase)
  end
  
  def generate_recommendations(password, strength_info)
    recommendations = []
    
    recommendations << 'Use at least 8 characters' if password.length < 8
    recommendations << 'Use at least 12 characters for better security' if password.length < 12
    recommendations << 'Include lowercase letters' unless password.match?(/[a-z]/)
    recommendations << 'Include uppercase letters' unless password.match?(/[A-Z]/)
    recommendations << 'Include numbers' unless password.match?(/[0-9]/)
    recommendations << 'Include special characters' unless password.match?(/[^a-zA-Z0-9]/)
    recommendations << 'Avoid common patterns like 123, abc, qwe' if password.match?(/123|abc|qwe|asd/i)
    recommendations << 'Avoid common passwords' if is_common_password?(password)
    
    recommendations.empty? ? ['Password meets security requirements'] : recommendations
  end
end