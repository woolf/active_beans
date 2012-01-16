class ActiveBeans::Request

  def initialize subject, method, async = false, *args
    @subject = subject
    @class_method = subject.class == Class ? true : false
    @klass = @class_method ? subject.to_s : subject.class.to_s
    @method = method.to_sym
    @attrs = @class_method ? {} : subject.attributes
    @async = async
    @args = *args
  end

  def perform
    ActiveBeans.log("Execute #{@subject} class #{@klass}, args #{@args.inspect.to_s[0..64]}")

    if !@args.nil?
      payload = @subject.send(@method, *@args)
    else
      payload = @subject.send(@method)
    end

    {:payload => ActiveBeans.to_bean(payload), :c => payload.class.to_s}.to_json
  end

  def async?
  	@async
  end

  def message
  	{:c => @klass, :m => @method, :cm => @class_method, :args => Marshal.dump(@args), :attrs => Marshal.dump(@attrs)}.to_json
  end

end