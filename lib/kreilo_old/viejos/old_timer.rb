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


module Kreilo


=begin
  Alarmclock is able to keep a set of alarms related to a particular clock
  If several clocks counting are needed, several AlarmClocks should be used.
=end
  class Timer 
    attr_reader :counter
    attr_reader :interval

    def initialize (time=nil, single=true, &action)
      @counter = 0
      @running = false
      @interval = time
      @emit_once = single 
      @action = action
      return self
    end

    def active?
      running
    end

    def self.single_shot (time, &action)
      timer = Timer.new(time, true, &action)
      return timer 
    end

    def self.multiple_shot (time, &action)
      timer = Timer.new(time, false, &action)
      return timer 
    end

    def start
      count
    end

    #FIXME: for multishot clocks we have to kill the thread
    #as we work with a thread, we can use true instead of @running ...
    def stop
      @running = false
      @counter = 0
#      @working_thread.kill 
    end

    def pause
      @running = false
    end
    def resume
      @running = true
    end


    private

    def count
      @running = true
      @counter = 0
      seconds = 0.5
      @working_thread = Thread.new {
        while @running 
        sleep(seconds)
        @counter += seconds
        puts "clock counter #{@counter}"
        next if @interval.nil?
        if @counter >= @interval
          puts "clock finitto"
          @action.call 
          if @emit_once
            stop
            @working_thread.exit
          else
            @counter = 0
          end
        end
        end
      }
    end



=begin
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


