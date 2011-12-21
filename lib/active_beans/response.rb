class ActiveBeans::Response
	attr_reader :active_beans_request
  attr_reader :active_beans_queue_job_id

	def initialize request, job
		@proxy = nil
    @active_beans_queue_job_id = job[:job_id]
    @active_beans_queue_server = job[:server]
		@active_beans_request = request
    active_beans_response_perform
	end

  def == comparison_object
    # unless active_beans_response_ready?
    #   raise StandardError, "ActiveBeans No Respond"
    # end
    comparison_object == @proxy[:payload]
  end

  def inspect
    @proxy[:payload].inspect
  end

  def method_missing method, *args, &block
    # unless active_beans_response_ready?
    #   raise StandardError, "ActiveBeans No Respond"
    # end

  	@proxy[:payload].send method, *args
  end

  def methods
    if active_beans_response_ready?
      @proxy[:payload].methods
    else
      Object.methods << "active_beans_response_ready?"
    end
  end

  def is_a? const
    @proxy[:payload].is_a? const
  end

  def to_s
    @proxy[:payload].to_s
  end

  def active_beans_response_perform
    if @active_beans_request.async?
      raise StandardError, "Async Methods Not Implemented"
    end

    puts "response.new got job #{@active_beans_queue_job_id}"
    result = ActiveBeans::Queue.retrieve(@active_beans_queue_job_id, @active_beans_queue_server)
    puts "get result"
    p result
    if result["error"]
      puts "Exception #{result["error"]["ex"]} #{result["error"]["m"]}"
      raise Kernel.const_get(result["error"]["ex"]), result["error"]["m"]
    end

    @proxy = {:payload => ActiveBeans.from_bean(result["payload"])}

    #if @proxy["c"] == "Class"
    #  @proxy["payload"] = Kernel.const_get(@proxy["payload"])
    #end
  end

  def active_beans_response_ready?
    @proxy.nil?
  end
end