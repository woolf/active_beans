require 'rails'

module ActiveBeans
  class Railtie < Rails::Railtie
    initializer :after_initialize do
      ActiveSupport.on_load(:active_record) do
        Resque::Plugins::AsyncDeliver.initialize
      end
    end
  end
end
