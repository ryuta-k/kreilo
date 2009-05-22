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

module Kreilo

require 'timer'
require 'base'

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
class PlayerManager < KObject

  attr_reader :groups_number
  attr_reader :players_number

  signals :max_wait_reached


  def initialize (doc, parent= nil)
    super nil
    @groups_number = doc["groups"]
    @players_number = doc["number"] 
    @max_wait = doc["max_wait"]
    #FIXME: this goes to the global config class
    if @max_wait.nil?
      @max_wait = 10
    end
   puts "inititiaial"
    @wait_clock = Timer.new
    @wait_clock.connect(SIGNAL :timeout) { puts "aaaaaaaaaaaaa"; emit :max_wait_reached} 
    #players on this game 
    @players = Array.new
    #    @players_number.to_i.times { @players.insert Player.new.connect_to_input InputManager.get_new_input}
    #    @players_queue = []
  end

  def enough?
    if @players.size > @players_number
      raise "Too many players joined this game"
    end
    @players.size == @players_number
  end

  
  #all the players in the same clock.
  #this means that when waiting for more than one player, the clock will restart
  #this is cool and OK IMHO
  def add_to_queue (player)
    puts "aaaaaaaalll"
    @wait_clock.stop
    @players.push Player.new(player)
    @wait_clock.start @max_wait
  end

  def number
    @players.size
  end

  def time_to_wait 
    @max_wait - @wait_clock.counter
  end


end


#one player
class Player
  attr_reader :ready
  def initialize (player)
    @player_id = player
    return self
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


  


end
