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

  id = $site.new_game_of_type(params[:id]).id
  if id.nil?
    raise "Game of type #{params[:id]} has been requested but the engine doesn't recognize it"
  end
  redirect_to :controller => 'game', :action => 'show', :id => id

end

end
