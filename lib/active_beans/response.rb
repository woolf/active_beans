class ActiveBeans::Response
  attr_reader :active_beans_request
  attr_reader :active_beans_queue_job_id

  def initialize request
    connection = Beanstalk::Connection.new(ActiveBeans.options[:server])
    connection.use("REQS")
    job_id = connection.put(request.message, 65536, ActiveBeans.options[:timeout])

    if connection.is_a? Beanstalk::Pool
      last_server = connection.last_server
    else
      last_server = connection.addr
    end

    @proxy = nil
    @active_beans_queue_job_id = job_id
    @active_beans_queue_server = last_server
    @active_beans_request = request

    ActiveBeans.log("Sent new #{request.async? ? 'a' : ''}sync request '#{request.message.to_s[0..64]}...' to #{last_server}")
    
    if @active_beans_request.async?
      ActiveBeans::Queue.push(self)
    else
      active_beans_response_perform
    end
  end

  def == comparison_object
    unless active_beans_response_ready?
      raise StandardError, "ActiveBeans No Respond"
    end

    comparison_object == @proxy[:payload]
  end

  def inspect
    if active_beans_response_ready?
      @proxy[:payload].inspect
    else
      super
    end
  end

  def method_missing method, *args, &block
    unless active_beans_response_ready?
      raise StandardError, "ActiveBeans No Respond"
    end

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
    if active_beans_response_ready?
      @proxy[:payload].is_a? const
    else
      super const
    end
  end

  def to_s
    unless active_beans_response_ready?
      raise StandardError, "ActiveBeans No Respond"
    end
    
    @proxy[:payload].to_s
  end

  def syncronize!
    unless active_beans_response_ready?
      active_beans_response_perform
      ActiveBeans::Queue.remove(@active_beans_queue_job_id)
    end
  end

  def active_beans_response_async_perform
    host, port =  @active_beans_queue_server.split(":")
    connection = EM::Beanstalk.new(:host => host, :port => port, :raise_on_disconnect => false)

    ActiveBeans.log("EM::Beanstalk watching RESP#{@active_beans_queue_job_id}")
    connection.watch("RESP#{@active_beans_queue_job_id}")
    defered_result = connection.reserve

    defered_result.on_success do |job|
      result = JSON.load(job.body)
      job.delete
      if result["error"]
        ActiveBeans.log("Async Exception for #{job.id}: #{result["error"]["ex"]} #{result["error"]["m"]}")
        raise Kernel.const_get(result["error"]["ex"]), result["error"]["m"]
      end
      @proxy = {:payload => ActiveBeans.from_bean(result["payload"])}

      ActiveBeans.log("Async Response JobID #{job.id}: #{@proxy[:payload].inspect.to_s[0..48]}")
      ActiveBeans::Queue.remove(@active_beans_queue_job_id)
      EM.stop if ActiveBeans::Queue.empty?
    end

    defered_result.on_error do |error|
      ActiveBeans.log("Async ERROR #{error} for JobID RESP#{@active_beans_queue_job_id}")
      ActiveBeans::Queue.remove(@active_beans_queue_job_id)
      EM.stop if ActiveBeans::Queue.empty?
    end
  end

  def active_beans_response_perform
    connection = Beanstalk::Connection.new(@active_beans_queue_server)
    ActiveBeans.log("Sync retrieve #{@active_beans_queue_job_id} from #{@active_beans_queue_server}")
    connection.watch("RESP#{@active_beans_queue_job_id}")
    job = connection.reserve
    job.delete
    result = JSON.load(job.body)
    if result["error"]
      ActiveBeans.log("Sync Response Exception for JobID #{@active_beans_queue_job_id}: #{result["error"]["ex"]} #{result["error"]["m"]}")
      raise Kernel.const_get(result["error"]["ex"]), result["error"]["m"]
    end
    @proxy = {:payload => ActiveBeans.from_bean(result["payload"])}

    ActiveBeans.log("Sync Response JobID #{@active_beans_queue_job_id}: #{@proxy[:payload].inspect.to_s[0..48]}")
  end

  def active_beans_response_ready?
    !@proxy.nil?
  end
end