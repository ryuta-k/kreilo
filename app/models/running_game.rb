require 'singleton'
class WaitingPlayer < ActiveRecord::Base
#  include Singleton
  set_table_name "waiting_players"
 
  def WaitingPlayer.new_game_of_type (game)
    g =  WaitingPlayer.find(:first, :conditions => {:game_id => game.id})
    if g.nil?
      g = WaitingPlayer.new
      g.game_id = game.id
      g.counter = 1
    else
      g.counter += 1
    end
    g.save
  end
  
  def WaitingPlayer.enough_players (game)
    g = WaitingPlayer.find(:first, :conditions => {:game_id => game.id})
    players = g.counter
    if players >= game.player_num 
      g.counter = 0
      g.save
      return true
    end  
    return false
  end

  def WaitingPlayer.players (game)
    g = WaitingPlayer.find(:first, :conditions => {:game_id => game.id})
    g.counter
  end


=begin
  def new_game_of_type (game)
    
    Settings.waiting = Hash.new
    Settings.waiting[game.id] ||= 0
    debugger
    Settings.waiting[game.id] += 1
    puts "waiting created"
    puts game.id
    puts Settings.waiting[game.id]
  end

  def enough_players (game)
    if Settings.waiting[game.id] >= game.player_num
      Settings.waiting[game.id] = 0
      return true
    end
    false
  end

  def players (game)
    Settings.waiting[game.id].size
  end
=end

end
