class DataController < ApplicationController

def update
#  if (params[:button] == 'pos')
    d = DataItem.find_by_data(params[:datas])
    if not d.nil?
      d.add params[:button]
    end

   @data = DataItem.random
   render :text => @data , :layout => false
end

end
