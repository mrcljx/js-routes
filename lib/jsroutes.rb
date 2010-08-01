require 'jsmin'

module JSRoutes

  autoload(:Router, 'jsroutes/router')

  def self.build
    routes = {}
    ActionController::Routing::Routes.named_routes.routes.each do |name, route|
      routes[name] = route.segments
    end

    template_file = File.join(File.dirname(__FILE__), 'templates', 'router.js')
    if File.exists?(template_file)
      template = IO.read(template_file)
      script = template.gsub('%routes%', routes.to_json).gsub('%global%', @@options[:global])
      if @@options[:minify]
        script = JSMin.minify(script).gsub("\n", '')
      end
      script = "// JSRoutes 1.0\n// Copyright (C) 2009 Flip Sasser\n// http://x451.com\n#{script}"
      if @@options[:append]
        script << '//EndJSRoutes (DoNotRemoveThisComment!)'
        original = File.read(File.join(RAILS_ROOT, 'public', @@options[:path])).split("\n")
        beginning = nil
        ending = nil
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
        File.open(File.join(RAILS_ROOT, 'public', @@options[:path]), 'w+') {|file|
          file.puts("#{original.join("\n")}\n\n#{script}")
        }
      else
        script
      end
    end
  end

  def self.enable(options = {})
    @@options = {:append => false, :global => 'Router', :minify => RAILS_ENV == 'production', :path => '/javascripts/router.js'}.merge(options)
    ActionController::Dispatcher.middleware.use(JSRoutes::Router) unless options[:append]
    ActionView::Helpers::AssetTagHelper.register_javascript_expansion :router => @@options[:path]
  end

  def self.options
    @@options
  end
end
