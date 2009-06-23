class RenameTables < ActiveRecord::Migration
  def self.up
    rename_table :datas, :dataItem
    rename_column "labels", "data_id", "dataItem_id" 
  end


  def self.down
    rename_table :dataItem, :datas
    rename_column "labels",  "dataItem_id", "data_id" 
  end
end
