require File.expand_path('../test_helper', __FILE__)
require "active_beans/queue/beanstalk"

class QueueTest < Test::Unit::TestCase

  def setup
  	@config = {:servers => ["localhost:11300"], :queue => "requests"}
  end

  def test_should_connect_to_queue
  	client = ActiveBeans::Queue::Beanstalk.new(@config)
  	job_id = client.put(["User", "name"].to_json)
  	assert(job_id.to_i > 0, "Job not sent or not recieved JobID")
  end

  def test_should_send_sync_requests
  	response = ActiveBeans::Queue.perform(ActiveBeans::Request.new(["User", "name"]))
    assert(response == ["User", "name"], "Response should be same as request")
  end

  def test_should_get_class_method_results
    response = ActiveBeans::Queue.perform(ActiveBeans::Request.new(["User", "full_name"]))
    assert(response == "John Doe", "Response should be 'John Doe' but recieved '#{response.inspect}'")
  end
end