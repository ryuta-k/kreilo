require "rubygems"
require "activerecord"
require 'yaml'  
require 'logger'  

module Kreilo


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
  type: type of the data (posible values are image, text, sound, video)
  src: location of the database. 
   
  TODO: import data: The location can be a directory (where each file is a data element),
  a file (where each line is a data element) or a database (where a "data" column should exist) 
  TODO: offset of the files
=end

class Input
  def initialize
    options = $framework.get_configuration("input", false)
    @batch_size = options["number"]
    @type = options["type"]

    #Need to do this for each ActiveRecord based class so that they can use different databases
    dbconfig = YAML::load(File.open('database.yml'))  
    [InputData, Annotation].each { |aclass| 
      aclass.establish_connection(dbconfig)
    }
  end
  
  #Read a batch of data 
  def get
    
  end


end



class InputManager
  attr_reader :shared
  
	def initialize
		options = $framework.get_configuration("input")
		@shared = options["shared"]		
		@inputs = Array.new.insert Input.new
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
  
	def initialize
		options = $framework.get_configuration("group", :allow_empty => true)
		if not options.nil?
			@groups_number = options["number"]
		end
		
		options = $framework.get_configuration("player")
		@players_number = options["number"]
		
		@players = Array.new
		@players_number.times { @players.insert Player.new.connect_to_input InputManager.get_new_input}
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

require "yaml"
class Configuration

  def parse
    if not File.exists? Filename
      raise "configuration file #{Filename} can not be found."
    end
    @data = YAML::load(File.open(Filename, "r"))

    if @data.nil?
      raise "Configuration file #{Filename} can not be parsed."
    end
  end
  
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





class Framework
  attr_reader :logger

	def initialize
		@configuration = Configuration.new 
	  @configuration.parse
			
	  options = get_configuration("general", true)
		if options["debug"] == true
      ActiveRecord::Base.logger = Logger.new(STDERR)  
    end  
  
	  @inputs = InputManager.new
		@players = PlayerManager.new
	  
		
  end
	
	#provided for convenience
	def get_configuration (label, allow_empty)
		@configuration.get_configuration(label, allow_empty)
	end
	
end


$framework = Framework.new

i = Input.new

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

end
