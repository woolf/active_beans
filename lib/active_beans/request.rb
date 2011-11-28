class ActiveBeans::Request

  def initialize subject, method, async = false, *args
    @class_method = subject.class == Class ? true : false
    @klass = @class_method ? subject.to_s : subject.class.to_s
    @method = method.to_sym
    @attrs = {}
    @async = async
    @args = *args
  end

  def queue_server

  end

  def perform
    puts "ActiveBeans::Request subject:"
    p message
    if @class_method
      if @args
        payload = Kernel.const_get(@klass).send(@method, *@args)
      else
        payload = Kernel.const_get(@klass).send(@method)
      end
      klass = payload.class
      {:payload => klass == Class ? payload.to_s : payload, :c => klass.to_s}.to_json
    else
      raise StandardError, "ActiveBeans Instance methods not implemented"
    end
  end

  def async?
  	@async
  end

  def message
  	{:c => @klass, :m => @method, :cm => @class_method, :args => @args, :attrs => @attrs}.to_json
  end

end