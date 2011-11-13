class ActiveBeans::Request

  def initialize subject, async = false, *args, &block
  	@subject = subject
  	@async = async
  end

  def queue_server

  end

  def perform
    puts "ActiveBeans::Request subject:"
    p @subject
    #@subject.to_json
    {:body => Kernel.const_get(@subject[0]).send(@subject[1])}.to_json
  end

  def async?
  	@async
  end

  def message
  	@subject.to_json
  end

end