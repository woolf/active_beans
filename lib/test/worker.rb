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
		  raw_req = JSON.load(job.body)
		  puts "Recieved JobID #{job.id}"
		  p raw_req

		  response = ActiveBeans::Response.from_request(raw_req, :job_id => job.id, :server => job.server)
		  #new(Kernel.const_get(raw_req["c"]), raw_req["m"], false, raw_req[:args])

		  reply = Beanstalk::Connection.new(job.server)
		  reply.use("responses#{job.id}")
		  puts "Sending response back to #{job.server}"
		  p reply.put(response.active_beans_response_perform)
		  reply.close

		  job.delete
		end
  end

end