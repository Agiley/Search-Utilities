# -*- encoding : utf-8 -*-
module SearchUtilities
  class ArrayUtility    
    def self.create_array_from_params(id, params)
      arrayed = []
      values = params[id]

      if (values)
        if (values.is_a?(Array))
          values.each do |param|
            arrayed << param
          end
        else
          arrayed << values
        end
      end

      return arrayed
    end

    def self.create_array_from_cookies(id, cookies)
      values = cookies[id].to_s.split(',')
      return values
    end
  end 
end