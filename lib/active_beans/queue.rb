#require File.join(File.dirname(__FILE__), "queue/beanstalk")

module ActiveBeans::Queue
	class << self
		def perform request
			#job = connection.put(request.message)
			#ActiveBeans::Response.new(request, job)
			ActiveBeans::Response.new(request)
		end

		def push response
			@response_queue ||= {}
			if response.is_a? ActiveBeans::Response
			  @response_queue[response.active_beans_queue_job_id] = response
			end
		end

		def each &block
			@response_queue ||= {}
			@response_queue.each &block
		end

		def remove job_id
			@response_queue ||= {}
      @response_queue.delete(job_id)
		end

		def empty?
			@response_queue ||= {}
      @response_queue.empty?
		end

		# def retrieve job_id, server = nil
		# 	connection.retrieve("RESP#{job_id}", server)
		# end

		# def connection
		# 	@connection = ActiveBeans::Queue::Beanstalk.new(:server => 'localhost:11300', :queue => "REQS")
		# end
	end
end
