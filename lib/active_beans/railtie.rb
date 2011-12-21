require 'rails'

module ActiveBeans
  class Railtie < Rails::Railtie
    initializer :after_initialize do
      ActiveSupport.on_load(:active_record) do
      	puts "LOAD active_beans CONFIG"
      	ActiveBeans.init(YAML.load_file("#{Rails.root}/config/active_beans.yml")[Rails.env].symbolize_keys)
      end
    end
  end
end
