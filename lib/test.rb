
require 'rubygems'
require 'kreilo/site'
require 'kreilo/signaling'
require 'kreilo/data_source'

class TestKreilo
  def initialize
    site = Kreilo::Site.new
    games = []
    #    site.types_available.each do |game_n|
    @game = site.new_game_of_type "game1"
    #      puts "new game of type #{game_n}"
    if @game.nil?
      raise "nill gamee"
    end

    Kreilo::SigSlot.connect(@game,:state_changed, self,:on_wait_finished)
    @game.add_player "jugador1"

    while not @game.runnable?
      puts "waiting for players " + @game.time_to_wait_players.to_s + " to go"
      sleep (3)
      @game.add_player "jugador2"
    end
    #  games << game.run.id
    # end

    if @game.run.nil?
      raise "we can not run the game"
    end
    puts @game.running?

    while @game.running? do
      puts game.id.to_s + " with running time: " + game.running_time.to_s
      sleep 1
    end
  end
  #  end

  def on_wait_finished (state)
    puts "waiting for players have finished"
    if @game.runnable?
      "runable"
    else
      "no runablE!"
    end

  end

end



test = TestKreilo.new
sleep (2)

