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

module ActionView
  class TemplateRenderer < AbstractRenderer
    def render(context, options)
      @view = context
      ActiveBeans.syncronize!
      wrap_formats(options[:template] || options[:file]) do
        template = determine_template(options)
        freeze_formats(template.formats, true)
        render_template(template, options[:layout], options[:locals])
      end
    end
  end
end