if defined?(DataMapper)
  module ActiveBeans
    module Adapters
      module DataMapper
        def self.extended(base) # :nodoc:
          class << base
            alias_method :included_without_active_beans, :included
            alias_method :included, :included_with_active_beans
          end
        end

        def included_with_active_beans(base)
          included_without_active_beans(base)
          base.active_beans_options[:encode] = true
        end
      end
    end
  end

  DataMapper::Resource.extend ActiveBeans::Adapters::DataMapper
end