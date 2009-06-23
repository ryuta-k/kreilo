class DataItem < ActiveRecord::Base
has_many :labels
set_table_name "dataItem"

   def DataItem.random
    d = DataItem.find_by_id rand(DataItem.count) + 1 
    d.data
  end

 def add (new_label)
   
 end 
end
