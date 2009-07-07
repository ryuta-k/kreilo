class PregameController < ApplicationController
before_filter :set_titles

#new pregame, instructions and other information showed
def new 

end


# display the waiting page, we entered this pregame
def show
  WaitingPlayer.new_game_of_type(@game)
  if (WaitingPlayer.enough_players(@game))
    redirect_to @game
  end
  session[:waiting] = 0
end


#periodically check if other player joined this game
#this is called from the wait page
def waiting_player
  session[:waiting] += 1
  if (WaitingPlayer.enough_players(@game))
    redirect_to  @game
  elsif session[:waiting] >= 10 
    redirect_to  @game
  else
    head :success
  end
#  puts WaitingPlayer.players(@game)
end


def set_titles
  @game = Game.find(params[:id]) 
  @page_title = @game.name
  @header_header = @game.name
  @header_subheader = "just testing"
  @controller_name = "game"
end

end
