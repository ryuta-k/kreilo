class Renamedataitem < ActiveRecord::Migration
  def self.up
    rename_column :labels, :dataItem_id, :data_item_id
  end

  def self.down
    rename_column :labels, :data_item_id, :dataItem_id
  end
end
