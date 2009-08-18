module JSRoutes
  def self.copy_routes(options = {})
    options = {:global => 'Router', :minify => RAILS_ENV == 'production', :filename => 'router.js', :path => 'javascripts'}.merge(options)
    # No idea what kind of overhead this module takes, but if you don't need it, you don't need it.
    require 'js_routes/js_min' if options[:minify]
    routes = {}
    ActionController::Routing::Routes.named_routes.routes.each do |name, route|
      routes[name] = route.segments
    end

    template_file = File.join(File.dirname(__FILE__), 'templates', 'router.js')
    if File.exists?(template_file)
      template = IO.read(template_file)
      script = template.gsub('%routes%', routes.to_json).gsub('%global%', options[:global])
      script = JSRoutes::JSMin.minify(script).gsub("\n", '') if options[:minify]
      script = "// JSRoutes 1.0\n// Copyright (C) 2009 Flip Sasser\n// http://x451.com\n#{script}"
      if options[:append]
        script << '//EndJSRoutes (DoNotRemoveThisComment!)'
        original = File.read(File.join(RAILS_ROOT, 'public', options[:append])).split("\n")
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
        File.open(File.join(RAILS_ROOT, 'public', options[:append]), 'w+') {|file|
          file.puts("#{original.join("\n")}\n\n#{script}")
        }
      else
        File.open(File.join(RAILS_ROOT, 'public', options[:path], options[:filename]), 'w+') {|file|
          file.puts(script)
        }
      end
    end
  end
end