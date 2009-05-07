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
require  'data_source'
require "signaling"


#require File.join(File.dirname(__FILE__), 'data_source')
#require File.join($Working_directory, 'data_source')
#autoload :SigSlot, File.join($Working_directory, 'signaling')
#autoload :Game, File.join($Working_directory, 'data_source')
#autoload :Game, File.join(File.dirname(__FILE__), 'data_source') 
#require File.join($Working_directory, 'signaling')

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
  attr_reader :games
  
	def initialize
#                puts  File.dirname(__FILE__) 
#                puts $LOAD_PATH
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
	def start_game_type(id)
                  puts "new game started"
		  clean_dead_games
			game = Kreilo::Game.new @game_types[id] 
			if game.nil?
				return nil
			else
				@games << game
			end
		  game.start
  	  SigSlot.connect(game,:max_time_reached,self,:on_game_finished)			  	
			return @games.rindex(game) #return the index in the array
	end
	
	def on_game_finished
		puts "game finished"
		puts caller.class
		finish

	end


	def finish
		@games.each {|game| game.finish}
		$logger.info "The site and all the games are finished"
	end
	
	private
	
=begin
	periodically @games not alive? should be deleted from the array
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




=begin
require "yaml"
class Configuration
  
  def get_configuration (label, allow_empty = false)
    options = @data[label]
    if options.empty? and not allow_empty 
      raise "We could find the requested configuration data for #{label}"
    end
    options
  end  
  
  private
  Filename = "configuration.yml"
end
=end

