
require 'kreilo/site'
require 'kreilo/signaling'
require 'kreilo/data_source'

class TestKreilo
  def initialize
    site = Kreilo::Site.new
    games = []
    site.types_available.each do |game_n|
      game = site.new_game_of_type (game_n)
      Kreilo::SigSlot.connect(game,:max_time_reached,self,:on_game_finished)	
      games << game.start.id
    end

    running = true
    while running do
      games.each do |game_id|
        running = site.game(game_id).alive?
        puts game_id.to_s + ": " + site.game(game_id).running_time.to_s
        sleep 1
      end
    end
  end
  def on_game_finished
    puts "game finished"
  end

end



test = TestKreilo.new


