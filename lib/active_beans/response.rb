class ActiveBeans::Response
	attr_reader :active_beans_request
  attr_reader :active_beans_queue_job_id

	def initialize request, job
		@proxy = nil
    @active_beans_queue_job_id = job[:job_id]
    @active_beans_queue_server = job[:server]
		@active_beans_request = request
    if request.async?
      
    else
      puts "response.new got job #{@active_beans_queue_job_id}"
      @proxy = ActiveBeans::Queue.retrieve(@active_beans_queue_job_id, @active_beans_queue_server)["body"]
    end
	end

  def == comparison_object
    comparison_object == @proxy
  end

  def method_missing method, *args, &block
  	@proxy.send method, *args
  end

  def methods
    if active_beans_response_ready?
      @proxy.methods
    else
      Object.methods << "active_beans_response_ready?"
    end
  end

  def active_beans_response_ready?
    @proxy.nil?
  end
  
end