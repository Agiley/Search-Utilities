module SearchUtilities
  require File.join(File.dirname(__FILE__), 'search_utilities/railtie') if defined?(Rails)
  require File.join(File.dirname(__FILE__), 'search_utilities/array_utility')
  require File.join(File.dirname(__FILE__), 'search_utilities/controller_utility')
  require File.join(File.dirname(__FILE__), 'search_utilities/cookies')
  require File.join(File.dirname(__FILE__), 'search_utilities/search')
  require File.join(File.dirname(__FILE__), 'search_utilities/search_helper')
end
