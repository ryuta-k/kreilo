#TODO: site should be created only once
class HomeController < ApplicationController
def index
#  @site ||= Kreilo::Site.new
   
  #game_id=@@framework.start_game_type("game1")
#  while framework.games[game_id].alive?
#    puts framework.games[game_id].running_time 
#    sleep(1)
#  end

end


def new_game

  game = $site.new_game_of_type(params[:id])
  if game.id.nil?
    raise "Game of type #{params[:id]} has been requested but the engine doesn't recognize it"
  end

  i = 0
  #the game we the site assigned to us can not receive more players
  while not game.add_player(current_user_session) do
    game = $site.new_game_of_type(params[:id])
    #TODO: delete this before going to production
    i += 1
    if (i >5)
      raise "Something is going wrong with the assignments of players"
    end
  end
  if (i == 0)
    puts "fresh game"
  end

#  redirect_to :controller => 'game', :action => 'wait_for_players'#, :id => game.id
  redirect_to :controller => 'game', :action => 'show'#, :id => game.id

end

end
