module SearchUtilities
  module Cookies
    
    def format_key(key)
      return "#{current_controller_key}_#{key}"
    end
    
    def get_cookie(key)
      return cookies[format_key(key).to_sym]
    end
    
    def set_cookie!(key, value)
      set_cookies!({key.to_sym => value})
    end
    
    def set_cookies!(values)
      values.each do |key, value|
        cookies[format_key(key).to_sym] = value
      end
    end
    
    def has_cookie?(key)
      return cookies.has_key?(format_key(key).to_sym)
    end
    
    def clear_cookies!(keys)
      keys.each do |key|
        cookies.delete format_key(key)
      end
    end
  end  
end