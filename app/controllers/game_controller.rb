class GameController < ApplicationController

  def show
    SigSlot.connect(game,:max_time_reached,self,:on_game_finished)	
    current_game.start
  end

  def update_game_time
    render :partial => 'countdown', :layout => false, :locals => { :game => current_game }
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
