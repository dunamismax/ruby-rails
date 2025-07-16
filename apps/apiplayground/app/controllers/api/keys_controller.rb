class Api::KeysController < ApplicationController
  protect_from_forgery with: :null_session
  
  def generate
    length = params[:length]&.to_i || 32
    
    if length < 8 || length > 128
      render json: { error: "Length must be between 8 and 128" }, status: :bad_request
      return
    end
    
    api_key = SharedUtilities::ApiHelpers.generate_api_key(length)
    
    render json: {
      success: true,
      data: {
        api_key: api_key,
        length: length * 2, # hex encoding doubles the length
        format: "hexadecimal"
      },
      timestamp: Time.current.iso8601
    }
  end
  
  def batch
    count = params[:count]&.to_i || 5
    length = params[:length]&.to_i || 32
    
    if count > 20
      render json: { error: "Count cannot exceed 20" }, status: :bad_request
      return
    end
    
    if length < 8 || length > 128
      render json: { error: "Length must be between 8 and 128" }, status: :bad_request
      return
    end
    
    keys = count.times.map do
      SharedUtilities::ApiHelpers.generate_api_key(length)
    end
    
    render json: {
      success: true,
      data: {
        api_keys: keys,
        count: count,
        length: length * 2,
        format: "hexadecimal"
      },
      timestamp: Time.current.iso8601
    }
  end
end