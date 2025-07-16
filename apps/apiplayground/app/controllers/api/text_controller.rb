class Api::TextController < ApplicationController
  protect_from_forgery with: :null_session
  
  def analyze
    text = params[:text]
    
    if text.blank?
      render json: { error: "Text parameter is required" }, status: :bad_request
      return
    end
    
    analysis = SharedUtilities::ApiHelpers.analyze_text(text)
    
    render json: {
      success: true,
      data: analysis,
      timestamp: Time.current.iso8601
    }
  end
  
  def reading_time
    text = params[:text]
    
    if text.blank?
      render json: { error: "Text parameter is required" }, status: :bad_request
      return
    end
    
    time = SharedUtilities::StringHelpers.reading_time(text)
    
    render json: {
      success: true,
      data: { reading_time: time },
      timestamp: Time.current.iso8601
    }
  end
end