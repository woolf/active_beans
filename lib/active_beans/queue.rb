#require File.join(File.dirname(__FILE__), "queue/beanstalk")

module ActiveBeans::Queue
	class << self
		def perform request
			job = connection.put(request.message)
			ActiveBeans::Response.new(request, job)
		end

		def retrieve job_id, server = nil
			connection.retrieve("RESP#{job_id}", server)
		end

		def connection
			@connection = ActiveBeans::Queue::Beanstalk.new(:server => 'localhost:11300', :queue => "REQS")
		end
	end
end