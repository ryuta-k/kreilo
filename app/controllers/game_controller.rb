class GameController < ApplicationController
before_filter :set_titles

def prestart

end

def wait
  wait = WaitingPlayer.new
  wait.new_game_of_type(@game)
  if (wait.enough_players(@game))
    redirect_to :play, @game
  end
  
  render

end

def waiting_player
  wait = WaitingPlayer.new
  if (wait.enough_players(@game))
    redirect_to :play, @game
  end
  puts wait.players(@game)
end



def play (game)
 #display something spinning with timeout of 3 seconds
 #calling start should wait till all the players called this
# RunningGame.start(game)
 

 render
end


def button

#  if (params[:button] == 'pos') 
    d = DataItem.find_by_data(params[:datas])
    if not d.nil?
      d.add params[:button]
    end
  
   @data = DataItem.random
   render :text => @data , :layout => false 
end


def finish
  wait = WaitingPlayer.new
  if (wait.enough_players(@game))
    redirect play @game
  end
  puts wait.players(@game)
end


def set_titles
  @game = Game.find(params[:id]) 
  @page_title = @game.name
  @header_header = @game.name
  @header_subheader = "just testing"
  @controller_name = "game"
end

end
