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
require 'timer'
require 'turnmanager'
require 'base'
require 'enumeration'

=begin
Create game
Add players
Run game
=end
class Game < KObject
  attr_reader :logger, :state, :type, :players
  attr_accessor :id  
  signals :max_time_reached, :state_changed 
  slots :on_players_max_wait_reached
  #FIXME: this include should be global! All classes depending on this. See signaling.rb
#  include Signaling


  def initialize (game_name, parent = nil)
    @state = GameState::Waiting_players
    @type = game_name
    super parent
    filename = File.join($Config_prefix, game_name + ".yml")
    begin
      Configuration.parse filename do  |doc, doc_number|
        #several documents, first one is the game
        #all other documents are steps 
        if doc_number == 1 then
          game = doc['game']

          if game["debug"] == true
            ActiveRecord::Base.logger = Logger.new(STDERR)  
          end  

          @min_time_limit, @max_time_limit = Configuration.read_limits(game, "time_limit")

          #if max_time_limit is nil, this will never fire
          @timer = Timer.new

          @steps = StepManager.new

          @turn = TurnManager.new doc

          @players = PlayerManager.new doc['player']

          @timer.connect( SIGNAL :timeout ) {puts "game finitto"; setState GameState::Dead; emit :max_time_reached }

          konnect(@players,:max_wait_reached, self, :on_players_max_wait_reached ) 


        else
          @steps.load doc
        end

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
      setState GameState::Running
      @timer.start @max_time_limit if @max_time_limit
      return self
    else
      return nil
    end
  end

  def finish
    setState GameState::Dead
    @timer.stop
  end



  #FIXME: texts sent to interface can be personalized by user
#use the I18N files for this 
  def running_time
    if @max_time_limit.nil?
      if not @timer.active? 
        return "stopped"
      else
        return "no limit"
      end
    else
      @max_time_limit - @timer.counter
    end
  end



  def alive?
    not @state == GameState::Dead 
  end



  #either adding a player or the timeout of waiting for players will make us be in Waiting_start state
  def runnable? 
    @state == GameState::Waiting_start
  end

  def running? 
    @state == GameState::Running
  end



  def time_to_wait_players
    @players.time_to_wait
  end



  def add_player (player)
    puts "adding new player to the game with " + @players.number.to_s + "  players"
    unless @state == GameState::Waiting_players
      raise "Trying to add players to a game in " + @state.to_s + " state" 
      return false
    end
    @players.add_to_queue(player)
    if @players.enough?
      puts "enough players"
      setState GameState::Waiting_start
    end
    return true
  end




  #TODO:Delete this
  def test
    puts "arrived signal"
  end




  #this should put us in GameState::Waiting_start
  def on_players_max_wait_reached

    #TODO: options to max players with recordings?
    str = "No users to play with this one ..."
    puts str
    setState GameState::Waiting_start

  end

private

  def setState (state)
    @state = state
    puts "state changes"
    emit :state_changed
  end

end





class GameState < Enumeration
  #waiting other players to come
  self.add( :Waiting_players, 1 )
  #all the players are here, waiting the start of the game
  self.add( :Waiting_start, 2 )
  #game is running
  self.add( :Running, 3 )
  self.add( :Dead, 4 )
end

end
