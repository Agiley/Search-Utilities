# -*- encoding : utf-8 -*-
module SearchUtilities
  module Cookies
    
    def format_key(key)
      return "#{current_controller_key}_#{key}"
    end
    
    def get_cookie(key)
      return cookies[format_key(key).to_sym]
    end
    
    def set_cookie!(key, value, expires = 7.days.from_now)
      set_cookies!({key.to_sym => value})
    end
    
    def set_cookies!(values, expires = 7.days.from_now)
      values.each do |key, value|
        cookies[format_key(key).to_sym] = {:value => value, :expires => expires}
      end
    end
    
    def has_cookie?(key)
      return cookies.has_key?(format_key(key).to_sym)
    end
    
    def clear_cookies!(keys)
      keys.each do |key|
        clear_cookie!(key)
      end
    end
    
    def clear_cookie!(key)
      #Somehow cookies.delete doesn't really work - we need to reset the cookie instead.
      #cookies.delete(format_key(key))
      cookies[format_key(key)] = {:value => nil, :expires => Time.at(0)}
    end
    
  end  
end