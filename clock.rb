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
