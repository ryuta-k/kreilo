class GameController < ApplicationController

  def show
    current_game.start
  end

  def update_game_time
    
    render :partial => 'countdown', :layout => false, :locals => { :game => current_game }

    #render :update do |page| page.replace_html 'warning', "Invalid options supplied" end
  end

  def current_game
    $site.game(params[:id].to_i)
  end

end
