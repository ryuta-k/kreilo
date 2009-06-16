class CreateLabels < ActiveRecord::Migration
  def self.up
    create_table :labels do |t|
      t.integer :data_id
      t.string :label
      t.integer :count

      t.timestamps
    end
  end

  def self.down
    drop_table :labels
  end
end
