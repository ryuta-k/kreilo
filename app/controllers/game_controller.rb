class GameController < ApplicationController

  def show
    @game = $site.new_game_of_type(params[:id])
    @game.start
  end

  def update_game_time
    raise @game.running_time.to_s
    render :partial => 'countdown', :layout => false
    #render :update do |page| page.replace_html 'warning', "Invalid options supplied" end
  end

end
