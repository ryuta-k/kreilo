
require 'kreilo/site'

site = Kreilo::Site.new
site.games_available.each do |game_n|
  site.new_game_of_type (game_n)
end
