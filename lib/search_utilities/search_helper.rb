# -*- encoding : utf-8 -*-
module SearchUtilities
  module SearchHelper
    include ::SearchUtilities::RequestUtility

    def render_multi_checkbox_list(title, collection, id_field, name_field, parenthize_column = nil, identifier = nil)
      output = ""
      clazz_singular = ""

      if (collection && collection.any?)
        clazz_singular = collection.first.class.to_s.underscore
        clazz_plural = collection.first.class.to_s.pluralize.underscore
        identifier_singular = (identifier) ? identifier : clazz_singular
        identifier = (identifier) ? identifier : clazz_plural

        values = get_request_values(identifier)

        output = "<h4>#{title}</h4>"
        output += "<ul>"
        collection.each do |item|
          checked = ((values && values.include?(item.send(id_field).to_s))) ? " checked=\"checked\"" : ""
          parenthized = (parenthize_column) ? " (#{item.send(parenthize_column)})" : ""
          output += "<li><input type=\"checkbox\" id=\"#{identifier_singular}_#{item.send(id_field)}\" class=\"checkbox\" name=\"#{identifier}[]\" value=\"#{item.send(id_field)}\"#{checked}/><label for=\"#{identifier_singular}_#{item.send(id_field)}\">#{item.send(name_field)}#{parenthized}</label></li>"
        end
        output += "</ul>"
      end
    end

    def render_text_field(id, clazz = "", default_value = nil)
      value = get_request_value(id)
      value = default_value if (default_value && (!value || !value.present?))

      return text_field_tag(id, value, :class => clazz)
    end

    def render_checkbox(id, value = "false", clazz = "")
      existing_value = get_request_value(id) || "false"    
      checked = existing_value.match(/(true|t|yes|y|1)$/i) != nil
      return check_box_tag(id, value, checked, :class => clazz)
    end

    def render_dropdown(id, values, options = {})        
      if (values && values.any?)
        value_column = options.delete(:value_column) { |opt| :value } 
        label_column = options.delete(:label_column) { |opt| :label }
        parenthize_column = options.delete(:parenthize_column)
        include_blank = options.delete(:include_blank)

        stored_values = get_request_values(id)
        stored_values = stored_values.collect {|v| v.to_s }

        if (values.is_a?(Array))
          values = values.collect {|v| [(parenthize_column) ? "#{v[label_column]} (#{v[parenthize_column]})" : v[label_column], v[value_column].to_s] }
        else
          values = values.collect {|v| [(parenthize_column) ? "#{v.send(label_column)} (#{v.send(parenthize_column)})" : v.send(label_column), v.send(value_column).to_s] }
        end

        values.insert(0, ["", ""]) if (include_blank)

        return select_tag(id, options_for_select(values, :selected => stored_values), options)
      end
    end

  end  
end