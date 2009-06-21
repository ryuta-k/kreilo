namespace :bootstrap do
desc "add some data"
task :default_data => :environment do
  File.open("forgame2.t", "r") do |infile|
    while (line = infile.gets)
      Datas.create(:data => line.gsub(/\s/, ''))

     # Datas.create (:data => "プレゼントに最適だ")
    end
  end

end
desc "add a couple of games"
task :games => :environment do
  g = Game.new
  g.name = "game_test1"
  g.timeout = 10
  g.player_num = 2
  g.player_wait_new = 20
  g.save

  g = Game.new
  g.name = "game_test2"
  g.timeout = 60
  g.player_num = 1
  g.save


end



  desc "Run all bootstrapping tasks"
  task :all => [:default_data, :games]
end

