require 'rails'

module ActiveBeans
  class Railtie < Rails::Railtie
    initializer :after_initialize do
      ActiveSupport.on_load(:active_record) do
        config = YAML.load_file("#{Rails.root}/config/active_beans.yml")
        raise StandardError, "Not valid config/active_beans.yml file" unless config && config[Rails.env]
        
        ActiveBeans.configure(config[Rails.env].symbolize_keys)
        ActiveBeans.options[:logger] = defined?(ActiveRecord) ? ActiveRecord::Base.logger : Rails.logger
      end
    end
  end
end

module AbstractController
  module Rendering
    def _process_options(options)
      ActiveBeans.syncronize!
    end
  end
end
