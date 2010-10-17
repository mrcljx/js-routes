module JSRoutes
  class Rack
    def initialize(app)
      @app = app
    end
    
    def call(env)
      if env['PATH_INFO'] =~ /^#{Regexp.escape(JSRoutes.mount_url)}$/
        script = JSRoutes.build
        [200, {'Content-Type' => 'text/javascript', 'Content-Length' => script.length.to_s}, script]
      else
        @app.call(env)
      end
    end
  end
end