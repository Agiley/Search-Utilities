# -*- encoding : utf-8 -*-
module SearchUtilities
  module Search
    include ::SearchUtilities::RequestUtility
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
      set_cookie!(request_key, query)
      
      return query
    end
    
    def set_order(search_options, default_order, request_key)
      search_options[:order] = default_order
      sort_order_request_value = get_request_value(request_key)
      
      if (sort_order_request_value)
        set_cookie!(request_key, sort_order_request_value)
        search_options[:order] = sort_order_request_value
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
    
    def set_date(search_options, request_key, option_key, fallback_value = nil)
      date_val = get_request_value(request_key)
      
      date = Date.strptime(date_val, "%Y-%m-%d") rescue nil if (date_val && date_val.present?)
      
      if (!date && fallback_value && !params[:is_search])
        date = fallback_value
      end

      if (date)
        set_cookie!(request_key, date.to_s(:db))      
        search_options[:with][option_key] = date.to_time.beginning_of_day..date.to_time.end_of_day
      end
      
      return search_options, date
    end
    
    def set_date_interval(search_options, from_key, to_key, option_key, from_date_fallback, type = :with, fallback_to = nil)
      from_request_val = get_request_value(from_key)
      to_request_val = get_request_value(to_key)
      
      from_date = Date.strptime(from_request_val.to_s, "%Y-%m-%d") rescue nil
      to_date = Date.strptime(to_request_val.to_s, "%Y-%m-%d") rescue nil
      
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
    
    def set_with_option(search_options, request_key, option_key)
      request_value = get_request_value(request_key)
      
      if (request_value && request_value.present?)
        set_cookie!(request_key, request_value)
        search_options[:with][option_key] = request_value.to_i
      end
      
      return search_options
    end
    
  end
  
end