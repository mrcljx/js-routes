require 'jsroutes'
require 'rails'

module JSRoutes
  class Railtie < Rails::Railtie
    initializer "jsroutes.route_mapper" do |app|
      JSRoutes.configure
      app.middleware.use "JSRoutes::Router"
    end
  end
end
