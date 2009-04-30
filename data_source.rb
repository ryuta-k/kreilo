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

#libraries
require "rubygems"
require "activerecord"
 
require 'logger'  


module Kreilo

require 'clock'
require 'globals'
require 'configuration'




class InputData < ActiveRecord::Base
  has_many :annotations
  
end

class Annotation < ActiveRecord::Base
  belongs_to :inputdata
  
end


=begin rdoc
Configuration options:
input:
  number: number of data elements that will be read each time
  type: type of the data (posible values are image, text, TODO:sound, video)
  src: location of the database. 
  TODO: offset and lenght of offset of the files
  TODO: policy (fair, random, first_new, first_partial)
=end

class Input
  def initialize (doc)
    options = doc["input"]
    @batch_size = options["number"]
    @type = options["type"]
    @policy = options["policy"]

    #Need to do this for each ActiveRecord based class so that they can use different databases
    dbconfig = Configuration.loadDatabase 
    [InputData, Annotation].each { |aclass| 
      aclass.establish_connection(dbconfig)
    }
  end
  
  #Read a batch of data 
  def get
    send("get_" + @policy).to_sym
=begin
    case @policy
    when "fair" then get_fair
    when "random" then get_random
    when "first_new" then get_first_new
    when "first_patial" then get_first_partial
=end
  end


end



class InputManager
  attr_reader :shared
  
	def initialize 
	end

  def load (doc)
		options = doc["input"]
		
		@shared = options["shared"]		
		@inputs = Array.new.insert Input.new doc
		
	end
	def get_new_input
		if not @shared
			@inputs.insert Input.new
		end
		@inputs.last
	end
	
end

#Manages Players and Groups
class PlayerManager
  attr_reader :groups_number
  attr_reader :players_number
  
	def initialize (doc)
		
    @groups_number = doc["groups"]
	  @players_number = doc["number"] 
		
		@players = Array.new
		@players_number.to_i.times { @players.insert Player.new.connect_to_input InputManager.get_new_input}
	end
	
	
end

#one player
class Player
	def initialize
		
		
	end
	
	def connect_to_input (input)
		@input = input
	end
	
	
end


class Step
	def initialize(doc)
		
	end
	
	
end

#manage input output feedback and output face of steps
class StepManager
	def initialize 
		@inputs = InputManager.new 
		@steps = Array.new		
	end
	
	def load (doc)
		@inputs.load doc
		@steps.push Step.new doc 
	end
	
end


class Game
  attr_reader :logger

	def initialize (filename)
		@debug = false
		@steps = StepManager.new
		Configuration.parse filename do |doc, doc_number| load_doc(doc, doc_number) end

		return self
  end

 private
  def load_doc(doc, doc_number)
		if doc_number == 1 then
      load_game(doc)					
    else
      @steps.load doc
    end
  end
      
	def load_game (doc)	
		
	  game = doc['game']

		if game["debug"] == true
      @debug = true
      ActiveRecord::Base.logger = Logger.new(STDERR)  
    end  

    @min_time_limit, @max_time_limit = Configuration.read_limits(game, "time_limit")

    if not doc["turn"].nil?
      @turns = TurnManager.new doc
    end
   
    if not doc["player"].nil?
      @players = PlayerManager.new doc
    end
     
	end 

#ok private class?  I need a clock counting seconds
  #clock should send a signal when the max_time is reached connect to this class finished
  class TurnManager 
    attr_reader :skipable, :min_number, :max_number, :min_time_limit, :max_time_limit
    def initialize (doc)
      turn = doc["turn"]
      @min_number, @max_number = Configuration.read_limits(turn, "number")
      @min_time_limit, @max_time_limit = Configuration.read_limits(turn, "time_limit")
      @skipable = turn["skipable"]
      @current = 0
      @clock = Clock.new(@min_time_limit, @max_time_limit)
    end
    def start
      @current += 1
      @clock.start 
    end
    def finish
      @clock.stop
    end
  end
		
end

  


end
