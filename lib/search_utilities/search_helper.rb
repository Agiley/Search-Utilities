# -*- encoding : utf-8 -*-
module SearchUtilities
  module SearchHelper
    include ::SearchUtilities::Request

    def render_text_field(id, default_value = nil, options = {})
      return render_field(:text_field, id, default_value, options)
    end
    
    def render_hidden_field(id, default_value = nil, options = {})
      return render_field(:hidden_field, id, default_value, options)
    end
    
    def render_field(field_type, id, default_value = nil, options = {})
      value = get_request_value(id) || nil
      value = default_value if (default_value && (value.nil? || value.blank?))
      return send("#{field_type}_tag", id, value, options)
    end

    def render_checkbox(id, value, options = {})
      checked         =   options.fetch(:checked, false)
      multiple        =   options.fetch(:multiple, false)
      name            =   options.fetch(:name, nil)
      name            =   name.to_s if (name)
      key             =   (multiple && name && name != "") ? name.gsub("[", "").gsub("]", "") : id
      
      existing_values =   get_request_values(key) || nil
      
      existing_values.each do |existing_value|
        is_checked = (existing_value && existing_value.present? && existing_value.to_s.downcase.eql?(value.to_s.downcase))
        if (is_checked)
          checked = is_checked
          break
        end
      end if (existing_values && existing_values.any?)
      
      return check_box_tag(id, value, checked, options)
    end

    def render_dropdown(id, values, options = {})        
      if (values && values.any?)
        value_column        =   options.delete(:value_column) { |opt| :value } 
        label_column        =   options.delete(:label_column) { |opt| :label }
        parenthize_column   =   options.delete(:parenthize_column)
        include_blank       =   options.delete(:include_blank)
        blank_label         =   options.delete(:blank_label) { |opt| "" } 

        stored_values = get_request_values(id)
        stored_values = stored_values.collect {|v| v.to_s }

        if (values.is_a?(Array))
          values = values.collect {|v| [(parenthize_column) ? "#{v[label_column]} (#{v[parenthize_column]})" : v[label_column], v[value_column].to_s] }
        else
          values = values.collect {|v| [(parenthize_column) ? "#{v.send(label_column)} (#{v.send(parenthize_column)})" : v.send(label_column), v.send(value_column).to_s] }
        end

        values.insert(0, [blank_label, ""]) if (include_blank)

        return select_tag(id, options_for_select(values, :selected => stored_values), options)
      end
    end

  end  
end