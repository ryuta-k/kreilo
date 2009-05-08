
require 'kreilo/site'
require 'kreilo/data_source'

site = Kreilo::Site.new
games = []
site.types_available.each do |game_n|
   games << site.new_game_of_type (game_n).start.id
end

running = true
while running do
  games.each do |game_id|
    running = site.game(game_id).alive?
    puts game_id.to_s + ": " + site.game(game_id).running_time.to_s
    sleep 1
  end
end

