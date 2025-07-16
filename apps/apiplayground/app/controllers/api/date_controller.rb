class Api::DateController < ApplicationController
  protect_from_forgery with: :null_session
  
  def format
    date_param = params[:date]
    format_param = params[:format] || 'default'
    
    if date_param.blank?
      render json: { error: "Date parameter is required" }, status: :bad_request
      return
    end
    
    begin
      date = Date.parse(date_param)
    rescue Date::Error
      render json: { error: "Invalid date format" }, status: :bad_request
      return
    end
    
    format_symbol = case format_param
                   when 'short' then :short
                   when 'long' then :long
                   when 'iso' then :iso
                   else :default
                   end
    
    formatted = SharedUtilities::DateHelpers.format_date(date, format_symbol)
    
    render json: {
      success: true,
      data: {
        original: date_param,
        formatted: formatted,
        format: format_param
      },
      timestamp: Time.current.iso8601
    }
  end
  
  def time_ago
    date_param = params[:date]
    
    if date_param.blank?
      render json: { error: "Date parameter is required" }, status: :bad_request
      return
    end
    
    begin
      date = DateTime.parse(date_param)
    rescue Date::Error
      render json: { error: "Invalid date format" }, status: :bad_request
      return
    end
    
    time_ago = SharedUtilities::DateHelpers.time_ago_in_words(date)
    
    render json: {
      success: true,
      data: {
        original: date_param,
        time_ago: time_ago,
        exact_difference: Time.current - date
      },
      timestamp: Time.current.iso8601
    }
  end
  
  def current
    now = Time.current
    
    render json: {
      success: true,
      data: {
        iso: now.iso8601,
        unix: now.to_i,
        formatted: {
          default: SharedUtilities::DateHelpers.format_date(now.to_date),
          short: SharedUtilities::DateHelpers.format_date(now.to_date, :short),
          long: SharedUtilities::DateHelpers.format_date(now.to_date, :long)
        }
      },
      timestamp: now.iso8601
    }
  end
end