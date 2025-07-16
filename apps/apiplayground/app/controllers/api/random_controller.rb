class Api::RandomController < ApplicationController
  protect_from_forgery with: :null_session
  
  def number
    min = params[:min]&.to_i || 1
    max = params[:max]&.to_i || 100
    
    if min > max
      render json: { error: "Min value cannot be greater than max value" }, status: :bad_request
      return
    end
    
    if max - min > 1_000_000
      render json: { error: "Range too large (max 1,000,000)" }, status: :bad_request
      return
    end
    
    random_number = SharedUtilities::ApiHelpers.generate_random_number(min, max)
    
    render json: {
      success: true,
      data: {
        number: random_number,
        min: min,
        max: max
      },
      timestamp: Time.current.iso8601
    }
  end
  
  def numbers
    count = params[:count]&.to_i || 5
    min = params[:min]&.to_i || 1
    max = params[:max]&.to_i || 100
    
    if count > 100
      render json: { error: "Count cannot exceed 100" }, status: :bad_request
      return
    end
    
    if min > max
      render json: { error: "Min value cannot be greater than max value" }, status: :bad_request
      return
    end
    
    numbers = count.times.map { SharedUtilities::ApiHelpers.generate_random_number(min, max) }
    
    render json: {
      success: true,
      data: {
        numbers: numbers,
        count: count,
        min: min,
        max: max
      },
      timestamp: Time.current.iso8601
    }
  end
end