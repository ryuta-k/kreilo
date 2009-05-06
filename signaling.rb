# Another Signals + Slots Implementation for Ruby, (c) Axel Plinge 2006
# no license, just use it if you like it
#
# - 17.01.2006  axel@plinge.de  started
# - 24.01.2006  axel@plinge.de  renamed to __connect to avoid name conflicts

# in order to avoid eval(...) cascades, all signaling Objects
# have to 'include Signaling' in order to be able to 'emit'

#This code is taken from Axel Plinge, thank you very much
module Kreilo

module Signaling   
  # connect one of our signals to one someones slot i.e. method
  def __connect(signal,recipient,slot,*args)
    @connections = Hash.new unless @connections
    @connections[signal] = [] unless @connections[signal]
    @connections[signal].push [recipient,slot,args]
  end
    
  def __disconnect(signal,recipient,slot)
    return unless @connections
    return unless @connections[signal]
    @connections[signal].select{ |m|  m[0] == recipient and m [1]==slot }.each do |r|
      @connections[signal].delete(r)
    end
  end
  
  def __disconnect(signal,recipient)
    return unless @connections
    return unless @connections[signal]
    @connections[signal].select{ |m| recipient==m[0] }.each do |r|
      @connections[signal].delete(r)
    end
  end
  
  # emit :signal name => call associated method with args or default value
  def emit(name,*args)
    return if !@connections
    connected_slots = @connections[name]
    return if !connected_slots
    connected_slots.each do |slot|
      slot[0].method(slot[1]).call(*(slot[2]+args))
    end
  end
  
end

# for singeltons or other non class instance objects,
# make your own SigSlot::Sender 
# and provide a method __connect(signal,recipient,slot,*args)

module SigSlot
  class  Sender
  include Signaling
  end
end

# connect sender's signal to one recipient's slot i.e. method
# if a value is given, recipient.slot(value) will be invoked,
# otherwise the value is expected after the emit statement

module SigSlot  
  def SigSlot.connect(sender,signal,recipient,slot,*args)
    sender.__connect(signal,recipient,slot,*args)
  end  
  def SigSlot.disconnect(sender,signal,recipient,slot,*args)
    sender.__disconnect(signal,recipient,slot)
  end  
  def SigSlot.disconnect(sender,signal,recipient)
    sender.__disconnect(signal,recipient)
  end    
end

#include Slotty
module Slotty
  def connect(sender,signal,recipient,slot,*args)
    sender.__connect(signal,recipient,slot,*args)
  end  
end 


end
