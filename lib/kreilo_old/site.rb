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

$LOAD_PATH.unshift( File.dirname(__FILE__) )

#$VERBOSE = true; 

#require 'signaling'
#class Object
#  include Kreilo::Signaling
#end


module Kreilo

require 'globals'
require 'configuration'
require 'game'
require 'base'

=begin
Outer class of the framework.
Starts everything 
 def Kreilo.const_missing(name)
    puts constants
    @looked_for ||= {}
    str_name = name.to_s
    raise "Class not found: #{name}" if @looked_for[str_name]
    @looked_for[str_name] = 1
    file = str_name.downcase
    require "data_source"
    require "signaling"
    require "configuration"
    require "alarmclock"
    klass = const_get(name)
    @looked_for = nil
    return klass if klass
    raise "Class not found: #{name}"
  end
=end


class Site < KObject
  slots :on_game_finished

  def initialize (parent =nil)
    super
    puts "new site has been created, congratulations"
    @game_types = Array.new
    @games = Array.new
    $logger = Logger.new(STDERR)
    $logger.level = Logger::DEBUG #overwritten by the config 

    conf_file = $Site_configuration_file #File.join( $Working_directory, $Site_configuration_file)
    Configuration.parse conf_file do |doc, a| 
      if doc["debug"] == true
        $logger.level = Logger::DEBUG
      else
        $logger.level = Logger::WARN
      end	
      doc["games"]["names"].split(',').each do |game_name|
        game_name.strip!
        @game_types << game_name
      end
      		
    end	  
    return self
  end

  def run
    app = Qt::CoreApplication.new(ARGV)
    Thread.new { app.exec }
  end

  def new_game_of_type(game_type)
    #clean already finished games
    clean_dead_games

    puts "game of type #{game_type} requested"
    if not @game_types.include? game_type
      raise "the game type requested (#{game_type}) can not be found in this site, game available:  " + games_available.join("  ")
    end
    game = @games.detect {|g| g.state == Kreilo::GameState::Waiting_players and g.type == game_type}
    if not game.nil?
      return game #we are done, return a game waiting for players.
    end

    game = Kreilo::Game.new game_type
    if game.nil?
      raise "Null game returned, we can not create games of type #{game_type}"
    else
      @games << game
    end
    game.id = @games.rindex(game)
    konnect(game,:max_time_reached,self,:on_game_finished)			  	
    return game 
  end
	
  def on_game_finished
    puts "game finished"
    finish
  end


  def finish
    @games.each {|game| game.finish}
    $logger.info "The site and all the games have been finalized"
  end

  def types_available
    @game_types
  end
  
  def game (id) 
    @games[id]
  end

	private
	
=begin
  periodically delete games not alive? from the array
=end
  def clean_dead_games
    if @games.size > 10000
      @games.delete_if{ |type,game| !game.alive?}		
    end	
  end
end

end




