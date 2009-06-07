class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|

      t.timestamps
      t.column :name, :string
      t.column :timeout, :integer
      t.column :player_num, :integer
      t.column :player_wait_new, :integer
    end
  end

  def self.down
    drop_table :games
  end
end
