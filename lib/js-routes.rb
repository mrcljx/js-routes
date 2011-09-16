require 'jsmin'
require 'js-routes/railtie' if defined?(Rails::Railtie)

module JsRoutes
  COPYRIGHT_NOTE = '// JsRoutes, http://github.com/sirlantis/js-routes'

  autoload :Rack, 'js-routes/rack'

  mattr_reader :config

  @@config = nil

  class << self
    delegate :mode, :minify, :path, :global, :to => :config

    alias minify? minify

    def write?
      mode == :write || mode == :write_once
    end

    def overwrite?
      mode == :write
    end

    def mount?
      mode == :mount
    end

    def build(force = false)
      template_file = File.join(File.dirname(__FILE__), 'templates', 'router.js')
      template = IO.read(template_file)

      script = "" << template << global << " = " << "new RouterClass(" << converted_routes.to_json << ");"
      script = JSMin.minify(script) if minify?

      if force or (write? and (overwrite? or !File.exist?(full_output_path)))
        File.open(full_output_path, 'w') do |file|
          file.puts(COPYRIGHT_NOTE)
          file.puts(script)
        end
      end

      script
    end

    def configure(app)
      @@config = app.config.js_routes

      if mount?
        File.delete(full_output_path) if File.file?(full_output_path)
        app.config.middleware.use(JsRoutes::Rack)
      end
    end

    def mount_url
      "/#{path}"
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
      File.join(Rails.public_path, path)
    end
  end
end
