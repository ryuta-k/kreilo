class CreateDatas < ActiveRecord::Migration
  def self.up
    create_table :datas do |t|
      t.binary :data

      t.timestamps
    end
  end

  def self.down
    drop_table :datas
  end
end
