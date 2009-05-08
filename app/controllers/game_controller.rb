class GameController < ApplicationController

  def show
    @game = $site.new_game_of_type(params[:id])
    @game.start
  end

end
