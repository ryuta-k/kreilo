require 'Thread'

module Kreilo

class Clock 
  attr_reader :allow
  attr_reader :running
  def initialize (min, max)
    @min, @max = min, max
    @allow = false
  end
  
  def repeat_every(seconds)
    @running = true
    while @running do
      time_spent = time_block { yield } # To handle -ve sleep interaval
      sleep(seconds - time_spent) if time_spent < seconds
      @running_time += 1
      if (@running_time >= @min)
        @min_expired_method.call
      end
      if (@running_time >= @max)
        @max_expired_method.call
        stop
      end
      
    end
  end
  
  def on_min_expired=(method_name)
    @min_expired_method = method_name
    @allow = true
  end

  def on_max_expired=(method_name)
    @max_expired_method = method_name
    @allow = false
  end
  
  def stop
    @running = false
  end
  
 private
 
  def time_block
    start_time = Time.now
    Thread.new { yield }
    Time.now - start_time
  end

  
end


end
