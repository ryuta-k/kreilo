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

require 'alarmclock'

  class TurnManager 
    attr_reader :allow_skip, :min_number, :max_number, :current
    def initialize (doc)
      turn = doc["turn"]
      if turn.nil?
        @min_number = @max_number = @min_time_limit = @max_time_limit = nil
        @skipable =true
      else
        @min_number, @max_number = Configuration.read_limits(turn, "number")
        @min_time_limit, @max_time_limit = Configuration.read_limits(turn, "time_limit")
        @skipable = turn["skipable"] |= true
      end
      @allow_skip = @skipable and @min_time_limit.nil?
      @current = 0
      @clock = AlarmClock.new
    end
    
    def new_turn
      @current += 1
      #TODO: create a emit_once in signaling.rb
      if not @min_number.nil? and @current >= @min_number
        emit min_number_turns_reached
      end
      if not @max_number.nil? and @current >= @max_number
        emit max_number_turns_reached
      end
      @clock.set_alarm("min_time_reached", @min_time_limit) unless @min_time_limit.nil?
      @clock.set_alarm("max_time_reached", @max_time_limit) unless @max_time_limit.nil?
      @clock.start 
    end
    
    def skip
      if (@allow_skip)
        @clock.stop
        new_turn
        return true
      else
        return false
      end
    end
    
    def finish
      @clock.stop
    end
    
    def seconds
    	@clock.running_time
    end
    
    def min_time_reached 
      @allow_skip = true  
    end
    
    def max_time_reached
    	emit max_time_turn_reached
    end
  end
end
