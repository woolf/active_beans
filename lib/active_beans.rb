require 'rubygems'
require 'json'
require 'eventmachine'
require 'em-beanstalk'
require 'logger'

require File.join(File.dirname(__FILE__), "active_beans/beans")
require File.join(File.dirname(__FILE__), "active_beans/version")
require File.join(File.dirname(__FILE__), "active_beans/queue")
require File.join(File.dirname(__FILE__), "active_beans/request")
require File.join(File.dirname(__FILE__), "active_beans/response")
require File.join(File.dirname(__FILE__), "active_beans/syncronize")

require File.join(File.dirname(__FILE__), "active_beans/queue/beanstalk")

if defined?(ActiveRecord::Base)
  require File.join(File.dirname(__FILE__), "active_beans/adapters/active_record")
end

if defined?(Rails)
  require File.join(File.dirname(__FILE__), "active_beans/railtie")
end

module ActiveBeans
  class << self
    def configure config
      @options = options.merge(config)
    end

    def options
      @options ||= {
        :server => "localhost:11300",
        :log => true,
        :timeout => 0
      }
    end

    def log message
      logger.info("[active_beans] #{message}") if logging?
    end

    def logger #:nodoc:
      @logger ||= options[:logger] || Logger.new(STDOUT)
    end

    def logger=(laogger)
      @logger = logger
    end

    def logging? #:nodoc:
      options[:log]
    end
  end
end

