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

  def test_should_return_object_method_with_param
    response = ActiveBeans::Queue.perform(ActiveBeans::Request.new(User.new, "echo", false, "hello object!"))
    assert(response == "hello object!", "Response should be array 'hello object!'")
  end

  def test_should_call_class_methods
    response = ActiveBeans::Queue.perform(ActiveBeans::Request.new(User, "echo_class", false, "hello class!"))
    assert(response == "hello class!", "Response should be array 'hello class!'")
    #assert(response == [1,2,3], "Response should be array [1,2,3]")
  end

  def test_should_return_result_with_many_params
    args = ["hello", "object"]
    response = ActiveBeans::Queue.perform(ActiveBeans::Request.new(User.new, "join_object", false, args))
    assert(response == "hello object", "Response should be array 'hello object'")

    response = ActiveBeans::Queue.perform(ActiveBeans::Request.new(User, "join_class", false, args))
    assert(response == "hello object", "Response should be array 'hello object'")
  end
end