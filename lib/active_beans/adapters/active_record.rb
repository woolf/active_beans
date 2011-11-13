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
		  #def active_beans_remote_method method, *args
		  #	puts "active_beans_remote_method"
		  #	self.send(method.to_sym, *args)
		  #end

			def method_missing_with_active_beans_remote_method(method, *args, &block)
				#puts "class method_missing_with_active_beans_remote_method"
				if method.to_s =~ /^a?sync_(.+)$/ && self.respond_to?($1)
					#active_beans_remote_method($1, *args)
					self.send($1.to_sym, *args)
				else
  				method_missing_without_active_beans_remote_method(method, *args, &block)
				end
			end


			module InstanceMethods
			  def method_missing(method, *args, &block)
			    if method.to_s =~ /^a?sync_(.+)$/ && self.respond_to?($1)
			      send($1.to_sym, *args)
			    else
			      super
			    end
			  end
			end
		end
	end
end

ActiveRecord::Base.extend ActiveBeans::Adapters::ActiveRecord
