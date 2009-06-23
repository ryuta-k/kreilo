class CreateWaitingPlayers < ActiveRecord::Migration
  def self.up
    create_table "waiting_players" do |t|
      t.column "game_id", :integer
      t.column "counter", :integer
    end



  end

  def self.down
    drop_table :waiting_players
  end
end
