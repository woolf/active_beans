require 'rubygems'
require 'json'

require File.join(File.dirname(__FILE__), "active_beans/beans")
require File.join(File.dirname(__FILE__), "active_beans/version")
require File.join(File.dirname(__FILE__), "active_beans/queue")
require File.join(File.dirname(__FILE__), "active_beans/request")
require File.join(File.dirname(__FILE__), "active_beans/response")

require File.join(File.dirname(__FILE__), "active_beans/queue/beanstalk")

if defined?(ActiveRecord::Base)
  require File.join(File.dirname(__FILE__), "active_beans/adapters/active_record")
end

if defined?(Rails)
  require File.join(File.dirname(__FILE__), "active_beans/railtie")
end