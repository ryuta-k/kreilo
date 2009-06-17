class Data < ActiveRecord::Base
has_many :Labels

  def get_random
 
    Data.find_by_id rand(Data.count) + 1  
end
  def Data.rand
    Data.find_by_id rand(Data.count) + 1  
  end


end
