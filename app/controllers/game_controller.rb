class GameController < ApplicationController
before_filter :set_titles

#display something spinning with timeout of 3 seconds
#calling new should wait till all the players called this
#def new
#end

#the real game
def show

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
