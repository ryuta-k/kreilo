class AddIdToLabels < ActiveRecord::Migration
  def self.up
    add_column :labels, :id, :integer
  end

  def self.down
    remove_column :labels, :id
  end
end
