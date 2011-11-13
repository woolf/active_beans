require File.expand_path('../test_helper', __FILE__)
require "active_beans/queue/beanstalk"

class WorkerTest < Test::Unit::TestCase

  def setup
  	@config = {:server => "localhost:11300", :queue => "requests"}
		beanstalk = Beanstalk::Connection.new(@config[:server])

		beanstalk.watch("requests")

		loop do
		  job = beanstalk.reserve
		  job.delete
		  raw_request = JSON.load(job.body)
		  puts "Recieved JobID #{job.id}"
		  p raw_request

		  request = ActiveBeans::Request.new(raw_request)

		  response = Beanstalk::Connection.new(job.server)
		  response.use("responses#{job.id}")
		  puts "Sending response back to #{job.server}"
		  p response.put(request.perform)
		  response.close

		  job.delete
		end
  end

end