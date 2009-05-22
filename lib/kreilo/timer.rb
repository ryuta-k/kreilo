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

require 'base'
class Eein < Kreilo::KObject 
def initialize(parent =nil, single = true)
end
end

#module Kreilo


=begin
  Alarmclock is able to keep a set of alarms related to a particular clock
  If several clocks counting are needed, several AlarmClocks should be used.
=end
class Timer < Kreilo::KObject
  attr_reader :counter
  signals :timeout
  slots :count, :internal_timeout

  def initialize ()
    super 
    @timer = Qt::Timer.new self 
    @timer.setSingleShot true # true by default 
    @count_timer = Qt::Timer.new self 
    @counter = 0
    konnect(@timer, :timeout, self, :internal_timeout )
    konnect(@count_timer, :timeout, self, :count )
    return self
  end

  def active?
#    @timer.isActive
  end


  def set_single_shot (single)
#    @timer.setSingleShot single
  end

  def start (time)
    stop
    puts "starting new count #{time}"
    @count_timer.start 100
    @timer.start time
  end

  def stop
    @timer.stop
    @count_timer.stop
    @counter = 0
    puts "counter to 0"
    #      @working_thread.kill 
  end


=begin
    def set_action  (time=nil, single=true, &action)
      @action = action
      puts "our time is  " + time.to_s
      @count_timer.start 100 
      @timer.start time
      @timer.connect (SIGNAL :timeout) 

      @timer.add(time,single, &ab)
      @timer.add(time,single, &action)
      @timer.add(time,single) {@count_timer.stop}

    end

    def single_shot (time, &action)
      puts "single shot with " + time.to_s
      set_action(time, true, &action)
      return self 
    end

 #   def multiple_shot (time, &action)
 #     set_action(time, false, &action)
 #     return self
 #   end
=end
  #FIXME: for multishot clocks we have to kill the thread
  #as we work with a thread, we can use true instead of @running ...
  private

  #fired to keep the count
  def count
    @counter += 0.1
    puts "count " + @counter.to_s
    #        if @counter >=@interval
    #          @count_timer.stop
    #        end

  end
  #fired to stop the count and emit signal

  def internal_timeout
    @count_timer.stop
    emit :timeout
  end

end

#end


