# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jsroutes}
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Flip Sasser"]
  s.date = %q{2009-11-14}
  s.description = %q{}
  s.email = %q{flip@x451.com}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    "MIT-LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "jsroutes.gemspec",
     "lib/templates/router.js",
     "rails/init.rb",
     "spec/jsroutes_spec.rb",
     "spec/rails_initializer_spec.rb"
  ]
  s.homepage = %q{http://github.com/flipsasser/jsroutes}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A Rails router to JavaScript plugin}
  s.test_files = [
    "spec/js_routes_spec.rb",
     "spec/rails_initializer_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jsmin>, [">= 1.0.1"])
    else
      s.add_dependency(%q<jsmin>, [">= 1.0.1"])
    end
  else
    s.add_dependency(%q<jsmin>, [">= 1.0.1"])
  end
end

