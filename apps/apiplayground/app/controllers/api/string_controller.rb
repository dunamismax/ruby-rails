class Api::StringController < ApplicationController
  include ApiSecurity
  protect_from_forgery with: :null_session
  
  def slugify
    validate_required_params([:text])
    text = sanitize_input(params[:text])
    validate_input_length(text, 1000)
    
    slug = SharedUtilities::StringHelpers.slugify(text)
    
    render_success({
      original: text,
      slug: slug,
      length: slug.length
    })
  end
  
  def truncate
    validate_required_params([:text])
    text = sanitize_input(params[:text])
    validate_input_length(text, 10000)
    
    word_count = params[:word_count]&.to_i || 50
    
    if word_count < 1 || word_count > 1000
      raise SharedUtilities::ValidationError, "Word count must be between 1 and 1000"
    end
    
    truncated = SharedUtilities::StringHelpers.truncate_words(text, word_count)
    
    render_success({
      original: text,
      truncated: truncated,
      word_count: word_count,
      was_truncated: truncated != text,
      original_word_count: text.split.length
    })
  end
  
  def highlight
    validate_required_params([:text])
    text = sanitize_input(params[:text])
    validate_input_length(text, 5000)
    
    language = params[:language] || 'ruby'
    language = sanitize_input(language)
    
    highlighted = SharedUtilities::StringHelpers.highlight_code(text, language)
    
    render_success({
      original: text,
      highlighted: highlighted,
      language: language,
      character_count: text.length
    })
  end
  
  def extract_emails
    validate_required_params([:text])
    text = sanitize_input(params[:text])
    validate_input_length(text, 10000)
    
    emails = SharedUtilities::StringHelpers.extract_emails(text)
    
    render_success({
      text: text,
      emails: emails,
      email_count: emails.length
    })
  end
  
  def word_frequency
    validate_required_params([:text])
    text = sanitize_input(params[:text])
    validate_input_length(text, 10000)
    
    frequency = SharedUtilities::StringHelpers.word_frequency(text)
    top_words = frequency.sort_by { |_, count| -count }.first(10).to_h
    
    render_success({
      text: text,
      word_frequency: frequency,
      top_words: top_words,
      unique_words: frequency.keys.length,
      total_words: frequency.values.sum
    })
  end
  
  def sanitize_html
    validate_required_params([:text])
    text = params[:text] # Don't sanitize input for this method
    validate_input_length(text, 10000)
    
    sanitized = SharedUtilities::StringHelpers.sanitize_html(text)
    
    render_success({
      original: text,
      sanitized: sanitized,
      was_sanitized: sanitized != text
    })
  end
end