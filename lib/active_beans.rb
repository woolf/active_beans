require File.join(File.dirname(__FILE__), "active_beans/version")
require File.join(File.dirname(__FILE__), "active_beans/queue")
require File.join(File.dirname(__FILE__), "active_beans/request")
require File.join(File.dirname(__FILE__), "active_beans/response")

if defined?(ActiveRecord::Base)
  require File.join(File.dirname(__FILE__), "active_beans/adapters/active_record")
end

module ActiveBeans

end
