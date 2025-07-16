class Api::StringController < ApplicationController
  protect_from_forgery with: :null_session
  
  def slugify
    text = params[:text]
    
    if text.blank?
      render json: { error: "Text parameter is required" }, status: :bad_request
      return
    end
    
    slug = SharedUtilities::StringHelpers.slugify(text)
    
    render json: {
      success: true,
      data: {
        original: text,
        slug: slug
      },
      timestamp: Time.current.iso8601
    }
  end
  
  def truncate
    text = params[:text]
    word_count = params[:word_count]&.to_i || 50
    
    if text.blank?
      render json: { error: "Text parameter is required" }, status: :bad_request
      return
    end
    
    if word_count < 1 || word_count > 1000
      render json: { error: "Word count must be between 1 and 1000" }, status: :bad_request
      return
    end
    
    truncated = SharedUtilities::StringHelpers.truncate_words(text, word_count)
    
    render json: {
      success: true,
      data: {
        original: text,
        truncated: truncated,
        word_count: word_count,
        was_truncated: truncated != text
      },
      timestamp: Time.current.iso8601
    }
  end
  
  def highlight
    text = params[:text]
    language = params[:language] || 'ruby'
    
    if text.blank?
      render json: { error: "Text parameter is required" }, status: :bad_request
      return
    end
    
    highlighted = SharedUtilities::StringHelpers.highlight_code(text, language)
    
    render json: {
      success: true,
      data: {
        original: text,
        highlighted: highlighted,
        language: language
      },
      timestamp: Time.current.iso8601
    }
  end
end