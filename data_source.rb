module Kreilo


require "activerecord"

# This class is only to configure ActiveRecord to use a different database
# Configured in DataElement
class DataSource < ActiveRecord::Base	
	
end

class Inputdata < Datasource
  has_many :annotations
  
end

class Annotation < Datasource
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

class DataElement 
  def initialize
    options = $framework.get_configuration("input", false)
    @batch_size = options["number"]
    @type = options["type"]
    @src = options["src"]	
    
    if not File.exists? @src
      raise "The database file #{@src} does NOT exist. Data can not be loaded."
    end
      
    DataSource.establish_connection (
    :adapter => "sqlite3",
    :database => @src,
    :pool => 5,
    :timeout => 5000
    )
		
			
  end


end


class Input
	def initialize
		options = $framework.get_configuration("input", false)
		@shared = 
		
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
		
		
  end
	
	#provided by convenience
	def get_configuration (label, allow_empty)
		@configuration.get_configuration(label, allow_empty)
	end
	
end


$framework = Framework.new

a = DataSource.new






end
