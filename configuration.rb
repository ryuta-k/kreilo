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

require 'yaml'

module Kreilo
  
require 'globals'
  
class Configuration
  
  def self.parse (file) 
    if not File.exists? file
      raise "configuration file #{file} can not be found."
    end
    doc_number = 0
    data = YAML::load_documents(File.open(file, "r")) do |doc| 
      doc_number += 1
      if not doc.nil?
        yield doc, doc_number
      else
        raise "Configuration file can not be parsed."  
      end
    end
    
    if doc_number == 0
      raise "Configuration file #{file} can not be parsed."
    end    
  end
  
  def self.loadDatabase 
    YAML::load(File.open($Database_configuration_file))  
  end
  
end


end
