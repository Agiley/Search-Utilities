# -*- encoding : utf-8 -*-
module SearchUtilities
  class ArrayUtility    
    def self.create_array_from_params(id, params)
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

    def self.create_array_from_cookies(id, cookies)
      return cookies[id].to_s.force_encoding("utf-8").split(',') rescue []
    end
  end 
end