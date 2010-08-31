require 'jsroutes/railtie' if defined?(Rails::Railtie)

module JSRoutes
  COPYRIGHT_NOTE = '// JSRoutes, http://github.com/sirlantis/js-routes'
    
  DEFAULT_GLOBAL = 'Router'
  
  autoload :Router, 'jsroutes/router'
  
  class << self
    def build
      template = IO.read(template_file)
      script = template.gsub('%routes%', converted_routes.to_json).gsub('%global%', @@options[:global])
      script = JSMin.minify(script) if minify?
    
      File.open(output_path, 'w') do |file|
        file.puts(COPYRIGHT_NOTE)
        file.puts(script)
      end
    
      script
    end

    def configure(options = {})
      @@options ||= {
        :global => DEFAULT_GLOBAL,
        :minify => Rails.env.production?,
        :path => default_output_path
      }
    
      @@options = @@options.merge(options)
    end

    def options
      @@options
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
  
    def minify?
      @@options[:minify]
    end
  
    def template_file
      File.join(File.dirname(__FILE__), 'templates', 'router.js')
    end
  
    def named_routes
      Rails.application.routes.named_routes
    end
  
    def default_output_path
      Rails.root.join('public', 'javascripts', 'routes.js')
    end
  
    def output_path
      Rails.root.join('public', @@options[:path])
    end
  end
end
