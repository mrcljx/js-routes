module JSRoutes
  class Router
    def call(env)
      if env['PATH_INFO'] =~ /#{JSRoutes.options[:path]}/
        script = JSRoutes.build
        [200, {'Content-Type' => 'text/javascript', 'Content-Length' => script.length.to_s}, script]
      else
        @app.call(env)
      end
    end

    def initialize(app)
      @app = app
    end
  end
end