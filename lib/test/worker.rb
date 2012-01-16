require File.expand_path('../test_helper', __FILE__)
require "active_beans/queue/beanstalk"

class WorkerTest < Test::Unit::TestCase

  def setup
  	@config = {:server => "localhost:11300"}
		beanstalk = Beanstalk::Connection.new(@config[:server])

		beanstalk.watch("REQS")

		loop do
		  job = beanstalk.reserve

		  raw_req = JSON.load(job.body)
		  ActiveBeans.log("Get JobID #{job.id} #{raw_req.inspect.to_s[0..64]}")

		  #response = ActiveBeans::Response.from_request(raw_req, :job_id => job.id, :server => job.server)
		  #new(Kernel.const_get(raw_req["c"]), raw_req["m"], false, raw_req[:args])
		  subject = if raw_req["cm"]
		  	Kernel.const_get(raw_req["c"])
		  else
		  	Kernel.const_get(raw_req["c"]).new
		  end
		  
		  subject.attributes = Marshal.load(raw_req["attrs"]) unless raw_req["cm"]

    	request = ActiveBeans::Request.new(subject, raw_req["m"], false, Marshal.load(raw_req["args"]))

		  reply = Beanstalk::Connection.new(job.server)
		  reply.use("RESP#{job.id}")

		  result = nil
		  begin
		  	result = request.perform
		  rescue Exception => e
		  	ActiveBeans.log("Exception #{e.class}, #{e.message}")
		  	result = {:error => {:ex => e.class.to_s, :m => e.message}}.to_json
		  end

		  ActiveBeans.log("Response RESP#{job.id} back to #{job.server}: #{result.inspect.to_s[0..64]}")
		  reply.put(result)
		  reply.close
		  job.delete
		end
  end

end