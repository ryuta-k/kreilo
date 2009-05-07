# Loading all sport classes under app/models/sports directory
Dir["#{RAILS_ROOT}/lib/kreilo/*.rb"].each do |file|
  require_dependency file
end
#require_dependency "kreilo/site.rb"
class HomeController < ApplicationController
def index
  @@framework ||= Kreilo::Site.new
  game_id=@@framework.start_game_type("game1")
#  while framework.games[game_id].alive?
#    puts framework.games[game_id].running_time 
#    sleep(1)
#  end

end

end
