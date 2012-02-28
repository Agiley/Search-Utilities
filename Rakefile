begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "search_utilities"
    gemspec.summary = "Search Utilities used with Thinking Sphinx"
    gemspec.description = "Common search methods/helpers extracted from various projects"
    gemspec.email = "sebastian@agiley.se"
    gemspec.homepage = "http://github.com/Agiley/search_utilities"
    gemspec.authors = ["Sebastian Johnsson"]
    gemspec.add_dependency 'rails'
    gemspec.add_development_dependency 'jeweler'
    gemspec.add_development_dependency 'rspec'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler -s http://gemcutter.org"
end

require 'bundler'
Bundler::GemHelper.install_tasks
