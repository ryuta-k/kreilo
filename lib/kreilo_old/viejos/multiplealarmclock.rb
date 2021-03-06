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
  class AlarmClock 
    attr_reader :running
    attr_reader :running_time

    def initialize (name=nil, time=nil)
      @running_time = 0
      @running = false
      @alarms = Array.new
      @alarms << Alarm.new(name, time) unless name.nil?
    end

=begin
    method_name: name of the method of the caller that will be caller
    when the alarm rings
    time: how much time we want for the alarm to ring
=end
    def set_alarm (caller, method_name, time)
      del_alarm(method_name)
      alarm = Alarm.new(caller, method_name, time)
      @alarms << alarm
      alarm
    end

=begin
    method_name: name of the method of the caller that will be emited
    with emit by the caller when the alarm rings 
    time: how much time we want for the alarm to ring
=end
    def set_alarm_emit(caller, method_name, time)
      set_alarm(caller, method_name, time).emit_signal = true
    end

    def del_alarm (method_name)
      puts "ants "  + @alarms.size.to_s
      @alarms.delete_if {|a| a.name == method_name}
      puts "aft " + @alarms.size.to_s
    end

    def repeat_every(seconds)
      @running = true
      while @running do
        time_spent = time_block { yield } # To handle -ve sleep interaval
        sleep(seconds - time_spent) if time_spent < seconds
        @running_time += seconds
        puts "running time #{@running_time}"
        all_alarms_fired = true
        @alarms.each do |alarm|
          if @running_time >= alarm.time and not alarm.fired 
            if alarm.emit_signal
              alarm.caller.send "emit".to_sym, alarm.name.to_sym
            else
              alarm.caller.send alarm.name.to_sym
            end
            alarm.fired=true
            #if one alarm is not yet fired all_alarms_fired will be false
          end
          all_alarms_fired &&= alarm.fired
        end
        if all_alarms_fired 
          stop
        end
      end
    end

    def start
      @working_thread = Thread.new {
      if block_given?
        repeat_every (1){ yield }
      else
        repeat_every 1
      end
      }
    end

    #as we work with a thread, we can use true instead of @running ...
    def stop
      @running = false
      @running_time = 0
      @working_thread.kill 
    end

    def pause
      @running = false
    end
    def resume
      @running = true
    end

    private

    def time_block
      start_time = Time.now
      Thread.new { yield }
      Time.now - start_time
    end

    class Alarm
      attr_accessor :fired, :emit_signal
      attr_reader :name, :time, :caller
      def initialize (caller, name, time)
        @caller = caller
        @name = name
        @time = time
        @fired = false
        @emit_signal = false
      end
    end


  end


end


