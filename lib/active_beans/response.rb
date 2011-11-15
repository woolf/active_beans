class ActiveBeans::Response
	attr_reader :active_beans_request
  attr_reader :active_beans_queue_job_id

	def initialize request, job
		@proxy = nil
    @active_beans_queue_job_id = job[:job_id]
    @active_beans_queue_server = job[:server]
		@active_beans_request = request
	end

  # {"args"=>nil, "attrs"=>{}, "m"=>"full_method", "c"=>"User", "cm"=>true}
  def self.from_request raw_data, job
    if raw_data["cm"]
      if raw_data["args"]
        sels.new(ActiveBeans::Request.new(Kernel.const_get(raw_data["c"]), raw_data["m"], false, raw_data["args"]), job)
      else
        self.new(ActiveBeans::Request.new(Kernel.const_get(raw_data["c"]), raw_data["m"]), job)
      end
    else
      raise StandardError, "ActiveBeans Instance methods Not Implemented"
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

  def active_beans_response_perform
    if @active_beans_request.async?
      raise StandardError, "Not implemented"
    else
      puts "response.new got job #{@active_beans_queue_job_id}"
      @proxy = ActiveBeans::Queue.retrieve(@active_beans_queue_job_id, @active_beans_queue_server)["body"]
    end
  end

  def active_beans_response_ready?
    @proxy.nil?
  end
  
end