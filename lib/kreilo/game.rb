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


require 'logger'

module Kreilo

  
require 'configuration'
require 'data_source'
require 'turnmanager'
require 'alarmclock'
require 'signaling'



class Game
  attr_reader :logger, :state, :type
  attr_accessor :id  

  #FIXME: this include should be global! See signaling.rb
  include Signaling

  def initialize (game_name)
    @debug = false
    @state = GameState::Waiting_players
    @type = game_name
    @waiting_players = true

    filename = File.join($Config_prefix, game_name + ".yml")
    begin
      Configuration.parse filename do 
        |doc, doc_number| 
        load_doc(doc, doc_number) 
       end
    rescue Exception => e  

      $logger.error("Game file #{filename} could not be loaded, ignoring it")
      $logger.debug(e)
      $logger.debug(e.backtrace.join("\n"))
      raise "Game not loaded"
      return nil
    else
      return self
    end
  end

  def run 
    if runnable?
      @state = GameState::Running
      @clock.start 
      return self
    else
      return nil
    end
  end

  def finish
    @state = GameState::Dead
    @clock.stop
  end

  #FIXME: texts sent to interface can be personalized by user
#use the I18N files for this 
  def running_time
    if @max_time_limit.nil?
      if @clock.running 
        return "stopped"
      else
        return "no limit"
      end
    else
      @max_time_limit - @clock.running_time
    end
#    @clock.running_time
  end

  def alive?
    not @state == GameState::Dead 
  end

  #either adding a player or the timeout of waiting for players will make us be in Waiting_start state
  def runnable? 
    @state == GameState::Waiting_start
  end

  def time_to_wait_players
    @players.time_to_wait
  end

  def add_player (player)
    unless @state == GameState::Waiting_players
      return false
    end
    @players.add_to_queue(player)
    if @players.enough?
      @state = GameState::Waiting_start
    end
    return true
  end


# signals connect to here  
#TODO: move to _emit method
  def on_max_time_reached
    @clock.stop
    emit :max_time_reached   	
  end
 
  #TODO:Delete this
  def test
    puts "arrived signal"
  end

  #TODO: options to max players with recordings?
  #this should put us in GameState::Waiting_start
  def on_players_max_wait_reached
    str = "No users to play with this one ..."
    puts str
    raise str
  end


 private
 #several documents, first one is the game
 #all other documents are steps 
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

   @clock = AlarmClock.new
   #TODO: does it has any meaning this? Can be used to make the user aware of time running out
   #@clock.set_alarm("min_time_reached", @min_time_limit) unless @min_time_limit.nil?
   @clock.set_alarm(self, "on_max_time_reached", @max_time_limit) unless @max_time_limit.nil?

   @steps = StepManager.new

   @turn = TurnManager.new doc

   @players = PlayerManager.new doc['player']

   SigSlot.connect(@players, :max_wait_reached, self, :on_players_max_wait_reached)

 end   
end


class GameState
  #waiting other players to come
  Waiting_players = 1
  #all the players are here, waiting the start of the game
  Waiting_start = 2 
  #game is running
  Running = 3
  Dead = 4
end

end
