require 'jsroutes'
require 'rails'

module JSRoutes
  class Railtie < Rails::Railtie
    config.after_initialize do |app|
      logger = Logger.new($stdout)
      
      unless JSRoutes.configured?
        logger.warn 'JSRoutes was not configured.'
      end
      
      JSRoutes.boot!(app)
    end
  end
end
