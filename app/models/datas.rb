class Datas < ActiveRecord::Base
has_many :Labels
set_table_name "datas"

   def Datas.random
    d = Datas.find_by_id rand(Datas.count) + 1 
    d.data
  end

 def add (new_label)
   
 end 

end
