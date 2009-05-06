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
Alarmclock
=end
class Clock 
  attr_reader :running
  attr_reader :running_time
  
  def initialize (name=nil, time=nil)
    @running_time = 0
    @alarms = Array.new
    @alarms << Alarm.new(name, time) unless name.nil?
  end
  
  def set_alarm (name, time)
    del_alarm(name)
    @alarms << Alarm.new(caller, name, time)
  end

  def del_alarm (name)
    @alarms.delete_if {|a| a.name == name}
  end
  
  def repeat_every(seconds)
    @running = true
    while @running do
      time_spent = time_block { yield } # To handle -ve sleep interaval
      sleep(seconds - time_spent) if time_spent < seconds
      @running_time += seconds
      
      @alarms.each do |alarm|
        if @running_time >= alarm.time and not alarm.fired? 
          alarm.caller.send alarm.name.to_sym
          alarm.fired=true
        end
      end
      
    end
  end
  
  def start
  	repeat_every 1 
  end
    
  def stop
    @running = false
    @running_time = 0
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
    attr_accessor :fired
    attr_reader :name, :time 
    def initialize (caller, name, time)
      @caller = caller
      @name = name
      @time = time
      @fired = false
    end
  end
  
  
end


end


