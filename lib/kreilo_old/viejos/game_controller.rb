require 'signaling'
class GameController < ApplicationController
#  include Signaling

  def show
    logger.debug "The game should have been"
    raise "aaaaaaaa"
    Kreilo::SigSlot.connect(current_game,:max_time_reached,self,:on_game_finished)	
    current_game.run
    puts "The game should have been shown"
  end
  
  def wait_for_players
    raise "aaaa"
    logger.debug "2222222s2222222222222222222"

    render :partial => 'waiting_for_players', :layout => false, :locals => { :game => current_game }
    if current_game.runnable?
      redirect_to :action => "show"
    else
      time = current_game.time_to_wait_players
      puts "we should be rendering a partial"
      render :partial => 'waiting_for_players', :layout => false, :locals => { :time => time }
    end
#    puts "current queue size" + current_game.players.size.to_s
  end

  def update_game_time
    render :partial => 'countdown', :layout => false, :locals => { :game => current_game }
  end

  def update_waiting_for_players
    render :partial => 'waiting_for_players', :layout => false, :locals => { :game => current_game }
  end

  def on_game_finished
    raise "game finished"
   page_name = "on_" + current_game.type + "_finished"
#   render partial_name     
  end

private
  def current_game
    $site.game(params[:id].to_i)
  end

end
