require 'beanstalk-client'

class ActiveBeans::Queue::Beanstalk
	def initialize config
		@config = config
		@beanstalk = Beanstalk::Connection.new(@config[:server])
	end

	def put message
		@beanstalk.use("requests")
		job_id = @beanstalk.put(message, 65536, 0)
		if @beanstalk.is_a? Beanstalk::Pool
			last_server = @beanstalk.last_server
		else
			last_server = @beanstalk.addr
		end
		puts "put #{message} to #{@config[:queue]}@#{last_server}"
    {:job_id => job_id, :server => last_server}
	end

	def retrieve job_id, server
		unless server.nil?
			@beanstalk = Beanstalk::Connection.new(server)
		end
		puts "trying to retrieve #{job_id} from #{server}"
		@beanstalk.watch(job_id)
	  job = @beanstalk.reserve
	  # job.class Beanstalk::Job
	  puts "got jobid #{job.id} with body: #{job.body}"
	  job.delete
	  JSON.load(job.body)
	end

	def close
		@beanstalk.close
	end
end