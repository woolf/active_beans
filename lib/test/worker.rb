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

		  #response = ActiveBeans::Response.from_request(raw_req, :job_id => job.id, :server => job.server)
		  #new(Kernel.const_get(raw_req["c"]), raw_req["m"], false, raw_req[:args])
		  request = ActiveBeans::Request.new(Kernel.const_get(raw_req["c"]), raw_req["m"], false, raw_req["args"])

		  reply = Beanstalk::Connection.new(job.server)
		  reply.use("responses#{job.id}")

		  result = nil
		  begin
		  	result = request.perform
		  rescue Exception => e
		  	puts "Exception #{e.class}, #{e.message}"
		  	result = {:error => {:ex => e.class.to_s, :m => e.message}}.to_json
		  end

		  puts "Sending response back to #{job.server}: #{result.inspect}"
		  p reply.put(result)
		  reply.close
		  job.delete
		end
  end

end