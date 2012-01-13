module ActiveBeans
  class << self
    def syncronize!
      ActiveBeans.log("Syncronize all")
      return if ActiveBeans::Queue.empty?

      EM.run do
        ActiveBeans::Queue.each do |job_id, response|
          response.active_beans_response_async_perform
        end

        # check_for_queue = proc {
        #   if ActiveBeans::Queue.empty?
        #     EM.stop
        #   end
        #   EM.next_tick(&check_for_queue)
        # }
        # EM.next_tick(&check_for_queue)
      end
    end
  end
end
