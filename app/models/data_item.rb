class DataItem < ActiveRecord::Base
has_many :labels
set_table_name "dataItem"

  def DataItem.random
    d = DataItem.find_by_id rand(DataItem.count) + 1 
    d.data
  end

 def addLabel (new_label)
    label = labels.find(:first, :conditions => { :label => new_label} )
    if label.nil? 
      created = Label.new(:label => new_label)
      created.count = 0
      labels << created 
      save
   else
      label.count += 1
      label.save
   end 
 end 

end
