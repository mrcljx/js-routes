require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "jsroutes"
    gemspec.summary = "A Rails router to JavaScript plugin"
    gemspec.description = ""
    gemspec.email = "flip@x451.com"
    gemspec.homepage = "http://github.com/flipsasser/jsroutes"
    gemspec.authors = ["Flip Sasser"]
    gemspec.add_dependency('jsmin', '>= 1.0.1')
    gemspec.add_development_dependency('jasmine', '>= 0.11.1.0')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end

require 'jasmine'
load 'jasmine/tasks/jasmine.rake'

task :spec do
  exec "./specs.sh"
end