# -*- encoding : utf-8 -*-
module SearchUtilities
  module Search
    include ::SearchUtilities::Request
    include ::SearchUtilities::Cookies
    
    def set_search_options(options = {})
      search_options = {}
      search_options[:conditions] = {}
      search_options[:with] = {}
      search_options[:without] = {}
      search_options[:with_all] = {}
      search_options.merge!(options)
      
      return search_options
    end
    
    def set_query(request_key)
      query = get_request_value(request_key)
      set_cookie!(request_key, query) if (query)
      
      return query
    end
    
    def set_order(search_options, request_key, default_order = nil)
      sort_order_request_value = get_request_value(request_key)
      
      if (sort_order_request_value && sort_order_request_value.present?)
        set_cookie!(request_key, sort_order_request_value)
        search_options[:order] = sort_order_request_value
      elsif ((sort_order_request_value.nil? || sort_order_request_value.blank?) && default_order && default_order.present?)
        set_cookie!(request_key, default_order)
        search_options[:order] = default_order
      else
        set_cookie!(request_key, "@relevance desc")
        search_options[:order] = "@relevance desc"
      end
      
      return search_options
    end
    
    def set_page_options(search_options, per_page_default = 10)
      page = (params[:page]) ? params[:page].to_i : 1

      per_page = get_request_value(:per_page).to_i
      per_page = per_page_default if (per_page <= 0)
      
      set_cookie!(:per_page, per_page)

      search_options[:page] = page
      search_options[:per_page] = per_page
      
      return search_options
    end
    
    def set_multi_value_option(search_options, request_key, option_key, convert_method = :to_i)
      request_values = get_request_values(request_key)
      
      if (request_values && request_values.any?)
        set_cookie!(request_key, request_values.join(","))
        search_options[:with][option_key] = []
        request_values.each do |val|
          search_options[:with][option_key] << val.send(convert_method) if (val && val.present?)
        end
        search_options[:with].delete(option_key) if (search_options[:with][option_key].nil? || search_options[:with][option_key].empty?)
      end
      
      return search_options
    end
    
    def set_date(search_options, request_key, option_key, fallback_value = nil, date_parsing_format = "%Y-%m-%d")
      date_val = get_request_value(request_key)
      
      date = Date.strptime(date_val, date_parsing_format) rescue nil if (date_val && date_val.present?)
      
      if (!date && fallback_value && !params[:is_search])
        date = fallback_value
      end

      if (date)
        set_cookie!(request_key, date.to_s(:db))      
        search_options[:with][option_key] = date.to_time.beginning_of_day..date.to_time.end_of_day
      end
      
      return search_options, date
    end
    
    def set_date_interval(search_options, from_key, to_key, option_key, from_date_fallback, type = :with, fallback_to = nil, date_parsing_format = "%Y-%m-%d")
      from_request_val = get_request_value(from_key)
      to_request_val = get_request_value(to_key)
      
      from_date = Date.strptime(from_request_val.to_s, date_parsing_format) rescue nil
      to_date = Date.strptime(to_request_val.to_s, date_parsing_format) rescue nil
      
      if (from_date && to_date)
        set_cookie!(from_key, from_date.to_s(:db))
        set_cookie!(to_key, to_date.to_s(:db))

        search_options[type][option_key] = from_date.to_time.beginning_of_day..to_date.to_time.end_of_day

      elsif (from_date && !to_date)
        set_cookie!(from_key, from_date.to_s(:db))

        search_options[type][option_key] = from_date.to_time.beginning_of_day..Time.now.end_of_day

      elsif (!from_date && to_date)
        set_cookie!(to_key, to_date.to_s(:db))

        search_options[type][option_key] = from_date_fallback.to_time.beginning_of_day..to_date.to_time.end_of_day
      else
        if (fallback_to)
          date = fallback_to.to_date
          set_cookie!(from_key, date.to_s(:db))
          set_cookie!(to_key, date.to_s(:db))
          
          search_options[type][option_key] = date.to_time.beginning_of_day..date.to_time.end_of_day
        end
      end
      
      return search_options
    end
    
    def set_integer_interval(search_options, from_key, to_key, option_key, type = :with)
      from_request_val = get_request_value(from_key)
      to_request_val = get_request_value(to_key)
      
      from_value = (from_request_val.present?) ? from_request_val.to_i : nil
      to_value = (to_request_val.present?) ? to_request_val.to_i : nil
      
      if (from_value && to_value)
        set_cookie!(from_key, from_value)
        set_cookie!(to_key, to_value)

        search_options[type][option_key] = from_value..to_value

      elsif (from_value && !to_value)
        set_cookie!(from_key, from_value)

        search_options[type][option_key] = from_value..from_value

      elsif (!from_value && to_value)
        set_cookie!(to_key, to_value)

        search_options[type][option_key] = to_value..to_value
      end
      
      return search_options
    end
    
    def set_minimum_range(search_options, data_type, key, option_key, maximum_value, type = :with)
      value = parse_value(key, data_type)

      if (value)
        maximum_value = case data_type
          when :integer, :int             then maximum_value.to_i rescue nil
          when :float, :decimal, :double  then maximum_value.to_f rescue nil
        end
        
        if (maximum_value)
          set_cookie!(key, value)
          search_options[type][option_key] = value..maximum_value
        end
      end
            
      return search_options
    end
    
    def set_maximum_range(search_options, data_type, key, option_key, minimum_value = nil, type = :with)
      value = parse_value(key, data_type)
      
      if (value)
        minimum_value = (minimum_value) ? minimum_value : 0
        minimum_value = case data_type
          when :integer, :int             then minimum_value.to_i rescue nil
          when :float, :decimal, :double  then minimum_value.to_f rescue nil
        end
        
        if (minimum_value)
          set_cookie!(key, value)
          search_options[type][option_key] = minimum_value..value
        end
      end
            
      return search_options
    end
    
    def parse_value(key, data_type = :integer)
      value = nil
      request_val = get_request_value(key)
      
      if (request_val.present?)
        value = case data_type
          when :integer, :int             then request_val.to_i rescue nil
          when :float, :decimal, :double  then request_val.gsub(",", ".").to_f rescue nil
        end
      end
      
      return value
    end
    
    def set_with_option_from_request(search_options, request_key, search_option_key, convert_method = nil)
      request_value       =   get_request_value(request_key)
      
      if (request_value && request_value.to_s.present?)
        value             =   convert_value(request_value, convert_method)
        search_options    =   set_with_option(search_options, request_key, search_option_key, value)
      end
      
      return search_options
    end
    
    def set_with_option(search_options, cookie_key, search_option_key, value)
      set_cookie!(cookie_key, value)
      search_options[:with][search_option_key] = value
      
      return search_options
    end
    
    def convert_value(value, convert_method = nil)
      return (convert_method && value.respond_to?(convert_method)) ? value.send(convert_method) : value
    end
    
  end
end