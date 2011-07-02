module SearchUtilities
  module Cookies
    def current_cookie_controller
      return "#{controller_name.gsub("_controller", "")}_#{action_name}"
    end
    
    def get_cookie(key)
      return cookies["#{current_cookie_controller}_#{key}".to_sym]
    end
    
    def set_cookie!(key, value)
      set_cookies!({key.to_sym => value})
    end
    
    def set_cookies!(values)
      values.each do |key, value|
        cookies["#{current_cookie_controller}_#{key}".to_sym] = value
      end
    end
    
    def has_cookie?(key)
      return cookies.has_key?("#{current_cookie_controller}_#{key}".to_sym)
    end
    
    def clear_cookies!(keys)
      keys.each do |key|
        cookies.delete "#{current_cookie_controller}_#{key.to_s}"
      end
    end
  end  
end