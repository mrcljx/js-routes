require 'jsroutes'
require 'rails'

module JSRoutes
  class Railtie < Rails::Railtie
    config.jsroutes = ActiveSupport::OrderedOptions.new.tap do |c|
      c.global  = "Router"
      c.minify  = Rails.env.production?
      c.path    = 'javascripts/router.js'
      c.mode    = Rails.env.production? ? :write : :mount
    end
    
    config.before_initialize do |app|
      JSRoutes.configure(app)
    end
    
    config.after_initialize do |app|
      JSRoutes.build if JSRoutes.write?
    end
  end
end
