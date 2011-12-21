require 'rails'

module ActiveBeans
  class Railtie < Rails::Railtie
    initializer :after_initialize do
      ActiveSupport.on_load(:active_record) do
    	  config = YAML.load_file("#{Rails.root}/config/active_beans.yml")[Rails.env].symbolize_keys
    	  raise StandardError, "Not valid config/active_beans.yml file" unless config
      	ActiveBeans.init(config)
      end
    end
  end
end
