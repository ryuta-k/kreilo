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
  desc "Run all bootstrapping tasks"
  task :all => [:default_data]
  end

