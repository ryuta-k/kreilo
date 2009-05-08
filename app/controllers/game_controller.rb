class GameController < ApplicationController

  def show
    current_game.start
  end

  def update_game_time
    render :partial => 'countdown', :layout => false, :locals => { :game => current_game }
  end

  def current_game
    $site.game(params[:id].to_i)
  end

end
