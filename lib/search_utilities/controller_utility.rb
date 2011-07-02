module SearchUtilities
  module ControllerUtility
    def current_controller_key
      return "#{controller_name.gsub("_controller", "")}_#{action_name}"
    end
  end  
end