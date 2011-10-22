# -*- encoding : utf-8 -*-
module SearchUtilities
  module Cookies
    
    def format_key(key, options = {})
      prepend_key = options.delete(:prepend_key) { |e| true }
      return prepend_key ? "#{current_controller_key}_#{key}".to_sym : key.to_sym
    end
    
    def get_cookie(key, options = {})
      return cookies[format_key(key, options)]
    end
    
    def set_cookie!(key, value, options = {})
      set_cookies!({key.to_sym => value}, options)
    end
    
    def set_cookies!(values, options = {})
      expires = options.delete(:expires) { |e| 7.days.from_now }
      
      values.each do |key, value|
        cookies[format_key(key, options)] = {:value => value, :expires => expires}
      end
    end
    
    def has_cookie?(key, options = {})
      return cookies.has_key?(format_key(key, options).to_sym)
    end
    
    def clear_cookies!(keys, options = {})
      keys.each do |key|
        clear_cookie!(key, options)
      end
    end
    
    def clear_cookie!(key, options = {})
      #Somehow cookies.delete doesn't really work - we need to reset the cookie instead.
      #cookies.delete(format_key(key))
      cookies[format_key(key, options)] = {:value => nil, :expires => Time.at(0)}
    end
    
  end  
end