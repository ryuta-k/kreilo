# Kreilo - Human computation gaming framework
# Copyright (C) 2009 Jordi Polo Carres
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require 'actiontimer'

module Kreilo


=begin
  Alarmclock is able to keep a set of alarms related to a particular clock
  If several clocks counting are needed, several AlarmClocks should be used.
=end
  class Timer 
    attr_reader :counter
    attr_reader :interval

    def initialize
      @timer = ActionTimer::Timer.new
      @count_timer = ActionTimer::Timer.new
      @counter = 0
      return self
    end

    def active?
      @timer.running?
    end

    def counter
      @counter.round
    end

    def set_action  (time=nil, single=true, &action)
      @interval = time
      @emit_once = single 
      @action = action
      ab= Proc.new { puts "xaaaaaa"}
      @timer.add(time,single, &ab)
#      @timer.add(1,single, &ab)
      @count_timer.add(0.1) do 
        @counter += 0.1
        puts "count " + @counter.to_s
        if @counter >=@interval
          @count_timer.stop
        end
      end
      running = true
      return self
    end

    def single_shot (time, &action)
      puts "single shot with " + time.to_s
      set_action(time, true, &action)
      return self 
    end

    def multiple_shot (time, &action)
      set_action(time, false, &action)
      return self
    end

    def start
      @timer.start
      @count_timer.start
    end
    #FIXME: for multishot clocks we have to kill the thread
    #as we work with a thread, we can use true instead of @running ...
    def stop
      @timer.stop
      @count_timer.stop
      @counter = 0
      puts "counter to 0"
#      @working_thread.kill 
    end



=begin



    def pause
      @running = false
    end
    def resume
      @running = true
    end



    def single_shot (time, owner, method_name, *parameters)
      @alarm = Alarm.new(time, owner, method_name, parameters)
      @alarm.emit_once = true
      repeat_every yield
    end

    def multiple_shot (time, owner, method_name, *parameters)
      @alarm = Alarm.new(time, owner, method_name, parameters)
      repeat_every yield
    end

    def repeat_every(seconds)
      @running = true
      while @running do
        time_spent = time_block { yield } # To handle -ve sleep interaval
        sleep(seconds - time_spent) if time_spent < seconds
        @running_time += seconds
        puts "running time #{@running_time}"
        if @running_time >= @alarm.time 
          @alarm.owner.send @alarm.name.to_sym, @alarm.parameters
          if @alarm.emit_once
            @running = false
          end
        end
      end
    end


    def repeater(seconds)
      @running = true
      @counter = 0
      while @running do
        time_spent = time_block { yield } # To handle -ve sleep interaval
        sleep(seconds - time_spent) if time_spent < seconds
        @counter += seconds
        puts "clock counter #{@counter}"
        if @counter >= @interval
          @action.call 
          if @emit_once
            @running = false
          else
            @counter = 0
          end
        end
      end
    end


    def repeat_every (seconds)  
      @working_thread = Thread.new {
      if block_given?
        repeater (seconds){ yield }
      else
        repeater seconds
      end
      }
    end





    def time_block
      start_time = Time.now
      Thread.new { yield }
      Time.now - start_time
    end



    class Alarm
      attr_accessor :fired, :emit_once
      attr_reader :name, :time, :caller
      def initialize (time, owner, name, *parameters)
        @caller = owner
        @name = name
        @time = time
        @fired = false
        @emit_signal = false
      end
    end


=end
  end


end


