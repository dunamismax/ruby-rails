module SharedUtilities
  module DateHelpers
    def self.time_ago_in_words(time)
      return "just now" if time.nil?
      
      seconds = Time.now - time
      return "just now" if seconds < 60
      
      minutes = seconds / 60
      return "#{minutes.to_i} minutes ago" if minutes < 60
      
      hours = minutes / 60
      return "#{hours.to_i} hours ago" if hours < 24
      
      days = hours / 24
      return "#{days.to_i} days ago" if days < 30
      
      months = days / 30
      return "#{months.to_i} months ago" if months < 12
      
      years = months / 12
      "#{years.to_i} years ago"
    end

    def self.format_date(date, format = :default)
      return "" if date.nil?
      
      case format
      when :short
        date.strftime("%m/%d/%Y")
      when :long
        date.strftime("%B %d, %Y")
      when :iso
        date.strftime("%Y-%m-%d")
      else
        date.strftime("%B %d, %Y")
      end
    end
  end
end