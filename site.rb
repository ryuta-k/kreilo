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

require 'configuration'
require 'globals'
require 'data_source'
require 'signaling'

=begin
class Object
  include Signaling
end
=end

=begin
Outer class of the framework.
Starts everything 
=end
class Site
  attr_reader :games
	def initialize
		@games = Array.new
   	Configuration.parse $Site_configuration_file do |doc, a| load_site (doc) end
	end
	
 private

  def load_site(doc)
	  doc["games"]["names"].split(',').each do |game_name|
				filename = $Config_prefix + game_name.strip + ".yml"
				game = Game.new filename				  
				@games.push game if not game.nil?
	  end	
  end

end

end



framework = Kreilo::Site.new



=begin
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

