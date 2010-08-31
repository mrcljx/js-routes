require 'jsmin'
require 'jsroutes/railtie' if defined?(Rails::Railtie)

module JSRoutes
  COPYRIGHT_NOTE = '// JSRoutes, http://github.com/sirlantis/js-routes'
  
  autoload :Router, 'jsroutes/router'
  
  mattr_accessor :global, :minify, :path, :mount, :write
  
  @@global = 'Router'
  @@minify = false
  @@mount  = true
  @@path   = 'public/javascripts/router.js'
  @@write  = true
  
  @@setup  = nil
  
  class << self
    alias minify? minify
    alias mount? mount
    alias write? write
    
    def build
      template_file = File.join(File.dirname(__FILE__), 'templates', 'router.js')
      template = IO.read(template_file)

      script = template.gsub('%routes%', converted_routes.to_json).gsub('%global%', global)
      script = JSMin.minify(script) if minify?

      if write?
        File.open(full_output_path, 'w') do |file|
          file.puts(COPYRIGHT_NOTE)
          file.puts(script)
        end
      end
    
      script
    end

    def setup(&block)
      @@setup = block
    end
    
    def configured?
      !!@@setup
    end
    
    def boot!(app)
      @@setup.call(self) if configured?
      
      self.build if write?
      app.middleware.use "JSRoutes::Router" if mount?
    end
  
    protected
  
    def converted_routes
      {}.tap do |routes|
        named_routes.each do |name, route|
          routes[name] = {
            :keys => route.segment_keys,
            :path => route.path
          }
        end
      end
    end
  
    def named_routes
      Rails.application.routes.named_routes
    end
  
    def full_output_path
      Rails.root.join(path)
    end
  end
end
