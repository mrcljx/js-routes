module JsRoutes
  class Rack
    def initialize(app)
      @app = app
    end

    def call(env)
      if env['PATH_INFO'] =~ /^#{Regexp.escape(JsRoutes.mount_url)}$/
        script = JsRoutes.build
        [200, {'Content-Type' => 'text/javascript', 'Content-Length' => script.length.to_s}, [script]]
      else
        @app.call(env)
      end
    end
  end
end