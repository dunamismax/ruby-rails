require 'time'

module SharedUtilities
  module DateHelpers
    VALID_FORMATS = %i[short long iso default rfc3339 unix].freeze
    
    def self.time_ago_in_words(time)
      return "just now" if time.nil?
      
      begin
        current_time = Time.now
        time_obj = time.is_a?(Time) ? time : Time.parse(time.to_s)
        
        seconds = current_time - time_obj
        return "in the future" if seconds < 0
        return "just now" if seconds < 60
        
        minutes = seconds / 60
        return "#{minutes.to_i} minute#{'s' if minutes.to_i != 1} ago" if minutes < 60
        
        hours = minutes / 60
        return "#{hours.to_i} hour#{'s' if hours.to_i != 1} ago" if hours < 24
        
        days = hours / 24
        return "#{days.to_i} day#{'s' if days.to_i != 1} ago" if days < 30
        
        months = days / 30
        return "#{months.to_i} month#{'s' if months.to_i != 1} ago" if months < 12
        
        years = months / 12
        "#{years.to_i} year#{'s' if years.to_i != 1} ago"
      rescue ArgumentError, TypeError
        "unknown time"
      end
    end

    def self.format_date(date, format = :default)
      return "" if date.nil?
      
      begin
        date_obj = date.is_a?(Date) || date.is_a?(Time) ? date : Date.parse(date.to_s)
        
        case format
        when :short
          date_obj.strftime("%m/%d/%Y")
        when :long
          date_obj.strftime("%B %d, %Y")
        when :iso
          date_obj.strftime("%Y-%m-%d")
        when :rfc3339
          date_obj.is_a?(Time) ? date_obj.strftime("%Y-%m-%dT%H:%M:%S%z") : date_obj.strftime("%Y-%m-%d")
        when :unix
          date_obj.is_a?(Time) ? date_obj.to_i.to_s : Date.parse(date_obj.to_s).to_time.to_i.to_s
        else
          date_obj.strftime("%B %d, %Y")
        end
      rescue ArgumentError, TypeError
        "invalid date"
      end
    end
    
    def self.parse_date(date_string)
      return nil if date_string.nil? || date_string.strip.empty?
      
      begin
        Date.parse(date_string.to_s)
      rescue ArgumentError
        nil
      end
    end
    
    def self.business_days_between(start_date, end_date)
      return 0 if start_date.nil? || end_date.nil?
      
      begin
        start_date = Date.parse(start_date.to_s) unless start_date.is_a?(Date)
        end_date = Date.parse(end_date.to_s) unless end_date.is_a?(Date)
        
        return 0 if start_date >= end_date
        
        business_days = 0
        current_date = start_date
        
        while current_date < end_date
          business_days += 1 unless current_date.saturday? || current_date.sunday?
          current_date += 1
        end
        
        business_days
      rescue ArgumentError
        0
      end
    end
    
    def self.format_duration(seconds)
      return "0 seconds" if seconds.nil? || seconds <= 0
      
      seconds = seconds.to_i
      
      if seconds < 60
        "#{seconds} second#{'s' if seconds != 1}"
      elsif seconds < 3600
        minutes = seconds / 60
        "#{minutes} minute#{'s' if minutes != 1}"
      elsif seconds < 86400
        hours = seconds / 3600
        "#{hours} hour#{'s' if hours != 1}"
      else
        days = seconds / 86400
        "#{days} day#{'s' if days != 1}"
      end
    end
  end
end