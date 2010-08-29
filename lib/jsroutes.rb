require 'jsroutes/railtie' if defined?(Rails::Railtie)

module JSRoutes
  autoload(:Router, 'jsroutes/router')
  
  def self.build
    routes = {}
    
    Rails.application.routes.named_routes.each do |name, route|
      routes[name] = {
        :keys => route.segment_keys,
        :path => route.path
      }
    end

    template_file = File.join(File.dirname(__FILE__), 'templates', 'router.js')
    
    return script unless File.exists?(template_file)
    
    template = IO.read(template_file)
    
    script = template.gsub('%routes%', routes.to_json).gsub('%global%', @@options[:global])
    script = JSMin.minify(script).gsub("\n", '') if @@options[:minify]
    script = "// JSRoutes 1.0\n// Copyright (C) 2009 Flip Sasser\n// http://x451.com\n#{script}"
    
    return unless @@options[:append]
    
    append_path = File.join(RAILS_ROOT, 'public', @@options[:path])
    original = File.read(append_path).split("\n")
    beginning = nil
    ending = nil
    
    script << '//EndJSRoutes (DoNotRemoveThisComment!)'
    
    original.each_with_index do |line, index|
      if !beginning && line =~ /this\.bindRoute\s*=\s*function/
        beginning = index
        if line !~ first_regex = /=\s*new\(function\(/
          previous = beginning - 1
          while original[previous] !~ first_regex
            previous -= 1
          end
          beginning = previous if previous > 0
        end
      end
      if !ending && line =~ /EndJSRoutes/
        ending = index
      end
    end
    
    if beginning && ending
      # If we found old routes, prepare to remove them. First, strip out leading comments and whitespace
      blank = beginning - 1
      while original[blank] =~ /^\s*(\/\/|\/\*)/
        beginning = blank
        blank -= 1
      end
      original = original[0, beginning - 1] + original[ending + 1, original.length - 1]
    end
    
    File.open(File.join(RAILS_ROOT, 'public', @@options[:path]), 'w+') do |file|
      file.puts("#{original.join("\n")}\n\n#{script}")
    end
  end

  def self.configure(options = {})
    @@options = {:append => false, :global => 'Router', :minify => RAILS_ENV == 'production', :path => '/javascripts/router.js'}.merge(options)
  end

  def self.options
    @@options
  end
end