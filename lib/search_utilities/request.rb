# -*- encoding : utf-8 -*-
module SearchUtilities
  module Request
    
    def current_controller_key
      return "#{controller_name.gsub("_controller", "")}_#{action_name}"
    end
    
    def get_request_value(key)
      return get_request_values(key).first rescue nil
    end
    
    def get_request_values(key)
      values          =   []
      param_values    =   get_param_values(key)
      cookie_values   =   get_cookie_values(key)
      values          =   param_values | cookie_values
      
      return values
    end
    
    def get_param_values(key)
      return create_array_from_params(key.to_sym)
    end
    
    def get_cookie_values(key)
      return create_array_from_cookies("#{current_controller_key}_#{key}".to_sym)
    end
    
    def create_array_from_params(id)
      arrayed = []
      values = params[id]

      if (values)
        if (values.is_a?(Array))
          values.each do |param|
            param = param.force_encoding("utf-8") if (param && param.is_a?(String))
            arrayed << param if (param)
          end
        else
          param = (values.is_a?(String)) ? values.force_encoding("utf-8") : values
          arrayed << param if (param)
        end
      end

      return arrayed
    end

    def create_array_from_cookies(id)
      return cookies[id].to_s.force_encoding("utf-8").split(',') rescue []
    end
    
  end  
end