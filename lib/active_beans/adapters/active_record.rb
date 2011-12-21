module ActiveBeans
  module Adapters
	  module ActiveRecord
	    def self.extended(base) # :nodoc:
	      base.class_eval do
	      	include InstanceMethods
	        class << self; alias_method_chain :method_missing, :active_beans_remote_method; end
	      end
	    end

		  protected

			def method_missing_with_active_beans_remote_method(method, *args, &block)
				if method.to_s =~ /^(a?sync)_(.+)$/ && self.respond_to?($2)
					#active_beans_remote_method($1, *args)
					#self.send($1.to_sym, *args)
					#ActiveBeans::Response.new(ActiveBeans::Request.new(self, $2, $1 == "async", *args))
					#self.send($2.to_sym, *args)
					ActiveBeans::Queue.perform(ActiveBeans::Request.new(self, $2, $1 == "async", *args))
				else
  				method_missing_without_active_beans_remote_method(method, *args, &block)
				end
			end


			module InstanceMethods
			  def method_missing(method, *args, &block)
			    if method.to_s =~ /^(a?sync)_(.+)$/ && self.respond_to?($2)
			      #send($1.to_sym, *args)
			    	ActiveBeans::Queue.perform(ActiveBeans::Request.new(self, $2, $1 == "async", *args))
			    else
			      super
			    end
			  end
			end
		end
	end
end

ActiveRecord::Base.extend ActiveBeans::Adapters::ActiveRecord
