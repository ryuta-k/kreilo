module Kreilo

class DataSource

  def initialize
    options=$framework.get_configuration("input", false)
    
    options.each { 
      |key,value| 
      
    }
			
			
  end


end

require "yaml"
class Configuration

  def parse
    if not File.exists? Filename
      raise "configuration file #{Filename} can not be found."
    end
#    @data = YAML::parse(File.open(Filename, "r"))
#    @data.transform
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


#example configuration


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
