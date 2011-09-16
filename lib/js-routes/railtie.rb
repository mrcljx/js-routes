require 'js-routes'
require 'rails'

module JsRoutes
  class Railtie < Rails::Railtie
    config.js_routes = ActiveSupport::OrderedOptions.new.tap do |c|
      c.global  = "Router"
      c.minify  = Rails.env.production?
      c.path    = 'javascripts/router.js'
      c.mode    = Rails.env.production? ? :write_once : :mount
    end

    config.before_initialize do |app|
      JsRoutes.configure(app)
    end

    config.after_initialize do |app|
      JsRoutes.build if JsRoutes.write?
    end
  end
end
