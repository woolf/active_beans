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
    #@subject.to_json
    if @class_method
      if @args
        {:body => Kernel.const_get(@klass).send(@method, @args)}.to_json
      else
        {:body => Kernel.const_get(@klass).send(@method)}.to_json
      end
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