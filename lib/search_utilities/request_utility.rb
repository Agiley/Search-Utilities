# -*- encoding : utf-8 -*-
module SearchUtilities
  module RequestUtility
    
    def current_controller_key
      return "#{controller_name.gsub("_controller", "")}_#{action_name}"
    end
    
    def get_request_value(key)
      return get_request_values(key).try(:first)
    end
    
    def get_request_values(key)
      values = []
      param_values = ::SearchUtilities::ArrayUtility.create_array_from_params(key.to_sym, params)
      cookie_values = ::SearchUtilities::ArrayUtility.create_array_from_cookies("#{current_controller_key}_#{key}".to_sym, cookies)
      values = param_values | cookie_values
      
      return values
    end
    
  end  
end