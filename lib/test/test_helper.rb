require 'test/unit'
require 'rubygems'
gem 'activerecord', ENV['ACTIVE_RECORD_VERSION'] if ENV['ACTIVE_RECORD_VERSION']
require 'active_record'
require 'guard'
require 'guard/guard'

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.dirname(__FILE__))

require 'active_beans'

puts "\nTesting with ActiveRecord #{ActiveRecord::VERSION::STRING rescue ENV['ACTIVE_RECORD_VERSION']}"

puts "Starting Beanstalk should be started on port 11300"

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'

def create_users_table
  silence_stream(STDOUT) do
    ActiveRecord::Schema.define(:version => 1) do
      create_table :users do |t|
        t.string   :first_name
        t.string   :last_name
      end
    end
  end
end

create_users_table

ActiveRecord::MissingAttributeError = ActiveModel::MissingAttributeError unless defined?(ActiveRecord::MissingAttributeError)

class User < ActiveRecord::Base
  def name
    "#{first_name} #{last_name}"
  end

  def echo param
    param
  end

  def self.echo_class param
    param
  end

  def self.full_name
    "John Doe"
  end

  def self.hello str
    "Hello #{str}"
  end

  def join_object str1, str2
    puts "str1 #{str1}"
    puts "str2 #{str2}"
    "#{str1} #{str2}"
  end

  def self.join_class str1, str2
    "#{str1} #{str2}"
  end
end
