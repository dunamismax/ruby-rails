class Api::PasswordController < ApplicationController
  protect_from_forgery with: :null_session
  
  def generate
    length = params[:length]&.to_i || 12
    
    if length < 4 || length > 128
      render json: { error: "Length must be between 4 and 128" }, status: :bad_request
      return
    end
    
    password = SharedUtilities::ApiHelpers.generate_password(length)
    
    render json: {
      success: true,
      data: {
        password: password,
        length: length,
        strength: calculate_strength(password)
      },
      timestamp: Time.current.iso8601
    }
  end
  
  def batch
    count = params[:count]&.to_i || 5
    length = params[:length]&.to_i || 12
    
    if count > 50
      render json: { error: "Count cannot exceed 50" }, status: :bad_request
      return
    end
    
    if length < 4 || length > 128
      render json: { error: "Length must be between 4 and 128" }, status: :bad_request
      return
    end
    
    passwords = count.times.map do
      password = SharedUtilities::ApiHelpers.generate_password(length)
      {
        password: password,
        strength: calculate_strength(password)
      }
    end
    
    render json: {
      success: true,
      data: {
        passwords: passwords,
        count: count,
        length: length
      },
      timestamp: Time.current.iso8601
    }
  end
  
  private
  
  def calculate_strength(password)
    score = 0
    
    score += 1 if password.length >= 8
    score += 1 if password.length >= 12
    score += 1 if password.match?(/[a-z]/)
    score += 1 if password.match?(/[A-Z]/)
    score += 1 if password.match?(/[0-9]/)
    score += 1 if password.match?(/[^a-zA-Z0-9]/)
    
    case score
    when 0..2
      "Weak"
    when 3..4
      "Medium"
    when 5..6
      "Strong"
    else
      "Very Strong"
    end
  end
end