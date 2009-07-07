class GameController < ApplicationController
before_filter :set_titles

#new game, instructions and other information showed
def new 

end

#waiting for other players
def wait
  wait = WaitingPlayer.new
  wait.new_game_of_type(@game)
  if (wait.enough_players(@game))
    redirect_to @game
  end

end

=begin
def waiting_player
  wait = WaitingPlayer.new
 
  if (wait.enough_players(@game))
    redirect_to  @game
  end
  puts wait.players(@game)
end
=end

#the real game
def show
 #display something spinning with timeout of 3 seconds
 #calling start should wait till all the players called this
# RunningGame.start(game)

end


#game finished
def finish  
 raise RAILS_GEM_VERSION
end


def set_titles
  @game = Game.find(params[:id]) 
  @page_title = @game.name
  @header_header = @game.name
  @header_subheader = "just testing"
  @controller_name = "game"
end

end
