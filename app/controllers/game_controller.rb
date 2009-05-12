class GameController < ApplicationController

  def show
    SigSlot.connect(current_game,:max_time_reached,self,:on_game_finished)	
    current_game.run
  end
  
  def wait_for_players
    if current_game.runnable?
      redirect_to :show
    else
      time = current_game.time_to_wait_players
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
