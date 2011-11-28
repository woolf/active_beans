require File.expand_path('../test_helper', __FILE__)
require "active_beans/queue/beanstalk"

class QueueTest < Test::Unit::TestCase

  def setup
  	@config = {:servers => ["localhost:11300"], :queue => "requests"}
  end

  def test_should_get_class_method_results
    response = ActiveBeans::Queue.perform(ActiveBeans::Request.new(User, "full_name", false))
    assert(response == "John Doe", "Response should be 'John Doe' but recieved '#{response.inspect}'")
  end

  def test_should_get_result_from_string_class
    response = ActiveBeans::Queue.perform(ActiveBeans::Request.new(String, "methods", false))
    assert(response.is_a?(Array), "Response should be an Array")

    response = ActiveBeans::Queue.perform(ActiveBeans::Request.new(String, "class", false))
    assert(response == Class, "Response should be Class")
  end

  def test_should_raise_exception_on_undefined_methods
    assert_raise NoMethodError do 
      response = ActiveBeans::Queue.perform(ActiveBeans::Request.new(User, "nonexistendmethod", false))
    end
  end

  def test_should_accept_methods_with_arguments
    response = ActiveBeans::Queue.perform(ActiveBeans::Request.new(User, "hello", false, "World"))
    assert(response == "Hello World", "Response should be 'Hello World'")

    response = ActiveBeans::Queue.perform(ActiveBeans::Request.new(User, "join", false, "Hello", "World"))
    assert(response == "Hello World", "Response should be 'Hello World'")
  end
end