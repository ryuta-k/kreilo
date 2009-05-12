
require 'kreilo/site'
require 'kreilo/signaling'
require 'kreilo/data_source'

class TestKreilo
  def initialize
    site = Kreilo::Site.new
    games = []
    site.types_available.each do |game_n|
      game = site.new_game_of_type game_n
      puts "new game of type #{game_n}"
      if game.nil?
        raise "nill gamee"
      end
      Kreilo::SigSlot.connect(game,:max_time_reached,self,:on_game_finished)
      game.add_player "jugador1"
      while not game.runnable?
        puts game.time_to_wait_players
      sleep(1)
        game.add_player "jugador2"
        sleep (100)
      end
      games << game.run.id
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


