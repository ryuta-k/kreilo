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

module Kreilo

require 'globals'
require 'configuration'
require 'data_source'
require 'signaling'

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


class Site
  
  def initialize
    puts "new site has been created"
    @game_types = Hash.new
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
        filename = File.join($Config_prefix, game_name + ".yml")
        @game_types[game_name] = filename
      end
			
    end	  	
  end
	
  def new_game_of_type(id)
    puts "game of type #{id} requested"
    clean_dead_games
    if not @game_types.has_key? id
      raise "the game type requested (#{id}) can not be found in this site, game available:  " + games_available.join("  ")
    end

    game = Kreilo::Game.new @game_types[id]
    if game.nil?
      puts "Null game returned"
      return nil
    else
      @games << game
    end
    game.id = @games.rindex(game)
    SigSlot.connect(game,:max_time_reached,self,:on_game_finished)			  	
    return game 
  end
	
  def on_game_finished
    puts "game finished"
    finish
  end


  def finish
    @games.each {|game| game.finish}
    $logger.info "The site and all the games are finished"
  end

  def types_available
    @game_types.keys
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


=begin

framework = Kreilo::Site.new
game_id=framework.start_game_type("game1")
while framework.games[game_id].alive?
  puts framework.games[game_id].running_time 
  sleep(0.1)
end
game_id=framework.start_game_type("game1")
while framework.games[game_id].alive?
  puts framework.games[game_id].running_time 
  sleep(0.1)
end
game_id=framework.start_game_type("game1")
while framework.games[game_id].alive?
  puts framework.games[game_id].running_time 
  sleep(0.1)
end



#test
input = InputData.new
input.times_processed = 1
input.save!
a=input.annotations.create
a.offset=0
a.label_name = "label"
a.label="test"
a.times_selected=1
a.save!	

=end



