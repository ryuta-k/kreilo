class Datas < ActiveRecord::Base
has_many :Labels
set_table_name "datas"

  def get_random
 
    Data.find_by_id rand(Data.count) + 1  
end
  def Data.rand
    Data.find_by_id rand(Data.count) + 1  
  end


end
