# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "jsroutes"
  s.version = "0.1.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marcel Jackwerth"]
  s.date = "2011-09-16"
  s.description = ""
  s.email = "marceljackwerth@gmail.com"
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    "MIT-LICENSE",
    "README.markdown",
    "Rakefile",
    "VERSION",
    "jsroutes.gemspec",
    "lib/jasmine/index.js",
    "lib/jasmine/jasmine-0.10.2.js",
    "lib/jsroutes.rb",
    "lib/jsroutes/rack.rb",
    "lib/jsroutes/railtie.rb",
    "lib/jsroutes/tasks.rb",
    "lib/templates/router.js",
    "spec/javascripts/fixtures/jquery-1.6.4.min.js",
    "spec/javascripts/js-routes/js-routes.js",
    "specs.js",
    "tasks/jsroutes.rake"
  ]
  s.homepage = "http://github.com/sirlantis/jsroutes"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Expose Rails's routes to JavaScript"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<jsmin>, [">= 1.0.1"])
      s.add_development_dependency(%q<jasmine>, [">= 1.1.0"])
      s.add_development_dependency(%q<rails>, [">= 3.0.0"])
    else
      s.add_dependency(%q<jsmin>, [">= 1.0.1"])
      s.add_dependency(%q<jasmine>, [">= 1.1.0"])
      s.add_dependency(%q<rails>, [">= 3.0.0"])
    end
  else
    s.add_dependency(%q<jsmin>, [">= 1.0.1"])
    s.add_dependency(%q<jasmine>, [">= 1.1.0"])
    s.add_dependency(%q<rails>, [">= 3.0.0"])
  end
end

