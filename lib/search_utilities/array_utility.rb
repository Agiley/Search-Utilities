module SearchUtilities
  class ArrayUtilility
    def self.create_array_from_params(id, params)
      arrayed = []

      if (params[id])
        params[id].each do |param|
          arrayed << param
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